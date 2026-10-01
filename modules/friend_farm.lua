local M = {}
local LP = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")

M.enabled = false
M.targetPlayer = nil
M.minTier = "Mythic"
M.mode = "Teleport"
M.loopDelay = 2
M.stats = { farmed = 0, shared = 0 }

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function hum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
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
    or n:find("dominus") or n:find("asteroid") or n:find("skull") or n:find("crystal") then return "Mythic" end
    if n:find("golden") or n:find("glass") then return "Legend" end
    if n:find("ice") or n:find("slime") or n:find("flower") or n:find("mushroom") then return "Epic" end
    if n:find("leaf") or n:find("stone") or n:find("easter") or n:find("cracked") then return "Rare" end
    if n:find("brown") or n:find("white") then return "Common" end
    return "Unknown"
end

local function passFilter(tier)
    return (TIER_ORDER[tier] or 0) >= (TIER_ORDER[M.minTier] or 0)
end

-- ============ AMBIL PLOT TARGET (BERDASARKAN NAMA) ============
local function getTargetPlotCF()
    if not M.targetPlayer then
        return nil, "targetPlayer nil"
    end

    -- pastiin targetPlayer itu Player instance
    local targetName = typeof(M.targetPlayer) == "Instance" and M.targetPlayer.Name or tostring(M.targetPlayer)
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then
        return nil, "target player gak ada di server"
    end

    -- jangan bawa ke base sendiri
    if targetPlayer == LP then
        return nil, "target = diri sendiri (skip)"
    end

    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return nil, "Plots folder gak ada"
    end

    for _, plot in ipairs(plots:GetChildren()) do
        local data = plot:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value and owner.Value == targetPlayer then
            local ok, cf = pcall(function() return plot:GetPivot() end)
            if ok then return cf, "found plot: " .. plot.Name end
            local eggs = plot:FindFirstChild("Eggs")
            if eggs then
                local base = eggs:FindFirstChildWhichIsA("BasePart")
                if base then return base.CFrame, "found via Eggs" end
            end
            local nests = plot:FindFirstChild("Nests")
            if nests then
                local nest = nests:GetChildren()[1]
                if nest then
                    local base = nest:FindFirstChildWhichIsA("BasePart")
                    if base then return base.CFrame, "found via Nests" end
                end
            end
        end
    end

    -- fallback: cari karakter target di workspace
    local targetChar = workspace:FindFirstChild(targetName)
    if targetChar then
        local th = targetChar:FindFirstChild("HumanoidRootPart")
        if th then return th.CFrame, "found via workspace char" end
    end

    return nil, "plot target gak ketemu"
end

-- ============ BASE SENDIRI (fallback ke sini setelah drop) ============
local function getOwnBaseCF()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local data = plot:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value and owner.Value == LP then
            local ok, cf = pcall(function() return plot:GetPivot() end)
            if ok then return cf end
        end
    end
    return nil
end

local function findBestEgg()
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return nil end
    local best, bestRank = nil, -1
    for _, egg in ipairs(re:GetChildren()) do
        local tier = tierOf(egg.Name)
        if passFilter(tier) then
            local rank = TIER_ORDER[tier] or 0
            if rank > bestRank then best, bestRank = egg, rank end
        end
    end
    return best
end

local function idleMoveTo(pos, timeout)
    local h = hum()
    if not h then return false end
    h:MoveTo(pos)
    local t = tick()
    while tick() - t < (timeout or 12) do
        local root = hrp()
        if not root then break end
        if (root.Position - pos).Magnitude < 4 then
            h:MoveTo(root.Position)
            return true
        end
        task.wait(0.1)
    end
    local root = hrp()
    if root then h:MoveTo(root.Position) end
    return false
end

local function pickEgg(egg)
    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
    if not base then return false end
    if M.mode == "Teleport" then
        tp(base.CFrame + Vector3.new(0, 3, 0))
        task.wait(0.25)
    else
        idleMoveTo(base.Position, 10)
        task.wait(0.2)
    end
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            if fireproximityprompt then
                fireproximityprompt(d)
            else
                d:InputHoldBegin()
                task.wait((d.HoldDuration or 0) + 0.05)
                d:InputHoldEnd()
            end
            task.wait(0.5)
            return true
        end
    end
    return false
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

local function findDropPromptAt(cf)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") then
            local t = (o.ActionText .. " " .. o.ObjectText):lower()
            if t:find("drop") or t:find("place") or t:find("nest") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    if (parent.Position - cf.Position).Magnitude < 80 then return o end
                end
            end
        end
    end
    return nil
end

-- ============ DROP KE BASE TARGET ============
local function dropAtTarget()
    local plotCF, reason = getTargetPlotCF()
    if not plotCF then
        return false, reason or "target plot gak ketemu"
    end

    -- gerak ke plot target
    if M.mode == "Teleport" then
        tp(plotCF)
        task.wait(0.5)
    else
        idleMoveTo(plotCF.Position, 15)
        task.wait(0.3)
    end

    -- cari prompt drop di sana
    local prompt = findDropPromptAt(plotCF)
    if prompt then
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait((prompt.HoldDuration or 0) + 0.05)
            prompt:InputHoldEnd()
        end
        task.wait(0.8)
        return true, "Dropped via prompt"
    end

    -- gak ada prompt: diam 2 detik biar target bisa pickup manual
    task.wait(2)
    return true, "Diem di base target (manual pickup)"
end

-- ============ BALIK KE BASE SENDIRI ============
local function backToOwnBase()
    local cf = getOwnBaseCF()
    if not cf then return end
    if M.mode == "Teleport" then
        tp(cf)
        task.wait(0.3)
    else
        idleMoveTo(cf.Position, 15)
        task.wait(0.3)
    end
end

-- ============ LOOP ============
local thread
local function loop()
    while M.enabled do
        -- guard: kalau gak ada target, stop
        if not M.targetPlayer then
            task.wait(1)
        else
            -- guard: kalau masih bawa egg (dari iterasi sebelumnya), bawa ke target
            if hasEgg() then
                local ok, reason = dropAtTarget()
                if ok then
                    M.stats.shared = M.stats.shared + 1
                    task.wait(0.5)
                    backToOwnBase()
                end
            else
                local egg = findBestEgg()
                if egg then
                    local picked = pickEgg(egg)
                    if picked then
                        M.stats.farmed = M.stats.farmed + 1
                        task.wait(0.3)
                        if hasEgg() then
                            local ok, reason = dropAtTarget()
                            if ok then
                                M.stats.shared = M.stats.shared + 1
                                task.wait(0.5)
                            end
                            backToOwnBase()
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
    local h = hum()
    if h and h.RootPart then h:MoveTo(h.RootPart.Position) end
end

function M.toggle(on)
    if on then M.start() else M.stop() end
end

function M.setTarget(player) M.targetPlayer = player end
function M.setMinTier(t) M.minTier = t end
function M.setMode(m) M.mode = m end

-- list nama player di server (kecuali diri sendiri)
function M.getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p.Name) end
    end
    return list
end

return M
