-- OR4CLE auto_farm.lua v2 — timer-aware
local M = {}
local LP = game:GetService("Players").LocalPlayer

M.enabled = false
M.mode = "Teleport"           -- "Teleport" | "Idle"
M.minTier = "Common"
M.returnToBase = true         -- pickup -> base -> loop (WAJIB on kalau ada timer)
M.loopDelay = 1.0
M.magmaAuto = false
M.idleSpeed = 250

M.stats = { farmed = 0, delivered = 0, magma = 0, startedAt = 0 }

local magma, idleFly, esp  -- inject

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function tierOf(name)
    local n = name:lower()
    if n:find("volcanic") or n:find("cherub") or n:find("solaris") or n:find("blackhole") or n:find("black hole") then return "Ethereal" end
    if n:find("bloom") or n:find("galaxy") or n:find("aurora") then return "Divine" end
    if n:find("tidal") or n:find("soul") or n:find("sinister") or n:find("flaming")
    or n:find("dominus") or n:find("asteroid") or n:find("skull") or n:find("crystal")
    or n:find("diamond") then return "Mythic" end
    if n:find("golden") or n:find("glass") then return "Legend" end
    if n:find("ice") or n:find("slime") or n:find("flower") or n:find("mushroom") then return "Epic" end
    if n:find("leaf") or n:find("stone") or n:find("easter") or n:find("cracked") then return "Rare" end
    if n:find("brown") or n:find("white") then return "Common" end
    return "Unknown"
end

local function passFilter(tier)
    return (TIER_ORDER[tier] or 0) >= (TIER_ORDER[M.minTier] or 0)
end

local function getBasePos()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner")
            if owner and owner.Value == LP then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok then return cf.Position end
            end
        end
    end
    return nil
end

local function findBestEgg()
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return nil end
    local h = hrp()
    local best, bestRank, bestDist = nil, -1, math.huge
    for _, egg in ipairs(re:GetChildren()) do
        local tier = tierOf(egg.Name)
        if passFilter(tier) then
            local rank = TIER_ORDER[tier] or 0
            local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
            if base then
                local d = h and (base.Position - h.Position).Magnitude or 0
                if rank > bestRank or (rank == bestRank and d < bestDist) then
                    best, bestRank, bestDist = egg, rank, d
                end
            end
        end
    end
    return best
end

local function findPickupPrompt(egg)
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            return d
        end
    end
end

local function findDropPromptAt(basePos)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") then
            local t = (o.ActionText .. " " .. o.ObjectText):lower()
            if t:find("drop") or t:find("place") or t:find("nest") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    if (parent.Position - basePos).Magnitude < 80 then return o end
                end
            end
        end
    end
    return nil
end

local function firePrompt(p)
    if not p then return false end
    if fireproximityprompt then
        fireproximityprompt(p)
        return true
    end
    p:InputHoldBegin()
    task.wait((p.HoldDuration or 0) + 0.05)
    p:InputHoldEnd()
    return true
end

local function hasEgg()
    local c = LP.Character
    if not c then return false end
    for _, o in ipairs(c:GetDescendants()) do
        if o.Name:lower():find("egg") then return true end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, o in ipairs(bp:GetChildren()) do
            if o.Name:lower():find("egg") then return true end
        end
    end
    return false
end

local function moveTo(targetPos, maxTime)
    if M.mode == "Idle" and idleFly then
        return idleFly.flyToTimed(targetPos, maxTime or 6)
    else
        tp(CFrame.new(targetPos))
        task.wait(0.2)
        return true
    end
end

local thread
local function loop()
    M.stats.startedAt = tick()
    while M.enabled do
        local egg = findBestEgg()
        if egg then
            local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
            if base then
                -- 1. gerak ke egg (max 6 detik)
                moveTo(base.Position + Vector3.new(0, 2, 0), 5)
                task.wait(0.2)

                -- 2. pickup
                local prompt = findPickupPrompt(egg)
                if prompt then
                    firePrompt(prompt)
                    task.wait(0.4)

                    if hasEgg() then
                        M.stats.farmed = M.stats.farmed + 1

                        -- 3. magma auto (opsional)
                        if M.magmaAuto and magma and magma.dropEgg then
                            local okDrop = magma.dropEgg()
                            if okDrop then M.stats.magma = M.stats.magma + 1 end
                        end

                        -- 4. bawa ke base SEGERA (timer jalan)
                        if M.returnToBase then
                            local basePos = getBasePos()
                            if basePos then
                                -- buffer 7 detik (timer 20, sisain 13 detik buat pickup)
                                moveTo(basePos, 7)
                                task.wait(0.3)

                                -- 5. drop di base
                                local dropP = findDropPromptAt(basePos)
                                if dropP then
                                    firePrompt(dropP)
                                    task.wait(0.5)
                                else
                                    -- gak ada prompt, diem di base 1.5 detik
                                    task.wait(1.5)
                                end

                                M.stats.delivered = M.stats.delivered + 1
                            end
                        end
                    end
                end
            end
        end
        task.wait(M.loopDelay)
    end
end

function M.start()
    if thread then return end
    M.enabled = true
    thread = task.spawn(loop)
end

function M.stop()
    M.enabled = false
    thread = nil
end

function M.toggle(on)
    if on then M.start() else M.stop() end
end

function M.setMode(m) M.mode = m end
function M.setMinTier(t) M.minTier = t end
function M.setReturn(on) M.returnToBase = on end
function M.setDelay(d) M.loopDelay = d end
function M.setMagma(on) M.magmaAuto = on end
function M.setIdleSpeed(s)
    M.idleSpeed = s
    if idleFly then idleFly.setSpeed(s) end
end

function M.inject(deps)
    magma = deps.magma
    idleFly = deps.idleFly
    esp = deps.esp
end

function M.findBestEggPublic() return findBestEgg() end
function M.hasEgg() return hasEgg() end

return M
