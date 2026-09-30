local M = {}
local LP = game:GetService("Players").LocalPlayer

-- deps
local magma -- diinject dari loader
local esp    -- diinject dari loader

M.enabled = false
M.mode = "Teleport"   -- "Teleport" | "Idle"
M.minTier = "Common"
M.returnToRanch = true
M.loopDelay = 1.5
M.magmaAuto = false

M.stats = {
    farmed = 0,
    mutations = 0,
    startedAt = 0,
}

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function getRanch()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner")
            if owner and owner.Value == LP then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok then return cf end
            end
        end
    end
    local char = LP.Character
    local h = char and char:FindFirstChild("HumanoidRootPart")
    return h and h.CFrame or CFrame.new(0, 40313, 900)
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
    local a = TIER_ORDER[M.minTier] or 0
    local b = TIER_ORDER[tier] or 0
    return b >= a
end

local function findPickupPrompt(egg)
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            return d
        end
    end
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

-- cari egg dengan tier tertinggi, lalu paling deket
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

-- idle move pakai MoveTo
local function idleMoveTo(pos, timeout)
    local hum = getHumanoid()
    if not hum then return false end
    hum:MoveTo(pos)
    local t = tick()
    while tick() - t < (timeout or 8) do
        local h = hrp()
        if not h then break end
        if (h.Position - pos).Magnitude < 4 then
            return true
        end
        if hum.MoveToFinished then
            -- udah sampe atau nyangkut
        end
        task.wait(0.1)
    end
    hum:MoveTo(hum.RootPart and hum.RootPart.Position or pos) -- stop
    return false
end

local function pickEgg(egg)
    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
    if not base then return false end

    if M.mode == "Teleport" then
        tp(base.CFrame + Vector3.new(0, 3, 0))
        task.wait(0.25)
    else
        -- idle: move ke posisi egg
        idleMoveTo(base.Position, 10)
        task.wait(0.2)
    end

    local prompt = findPickupPrompt(egg)
    if not prompt then return false end
    firePrompt(prompt)
    task.wait(0.6)
    return true
end

-- ===== LOOP =====
local thread

local function loop()
    M.stats.startedAt = tick()
    while M.enabled do
        local egg = findBestEgg()
        if egg then
            local ok = pickEgg(egg)
            if ok then
                M.stats.farmed = M.stats.farmed + 1

                -- magma auto
                if M.magmaAuto and magma and magma.dropEgg then
                    local okDrop = magma.dropEgg()
                    if okDrop then
                        M.stats.mutations = M.stats.mutations + 1
                    end
                end

                -- balik ke ranch
                if M.returnToRanch then
                    if M.mode == "Teleport" then
                        tp(getRanch())
                        task.wait(0.4)
                    else
                        idleMoveTo(getRanch().Position, 12)
                        task.wait(0.3)
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
    local hum = getHumanoid()
    if hum then hum:MoveTo(hum.RootPart and hum.RootPart.Position or Vector3.new()) end
end

function M.toggle(on)
    if on then M.start() else M.stop() end
end

function M.setMode(m)
    M.mode = m
end

function M.setMinTier(t)
    M.minTier = t
end

function M.setReturn(on)
    M.returnToRanch = on
end

function M.setDelay(d)
    M.loopDelay = d
end

function M.setMagma(on)
    M.magmaAuto = on
    if magma then magma.toggle(on) end
end

function M.inject(deps)
    magma = deps.magma
    esp = deps.esp
end

return M
