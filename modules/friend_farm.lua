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

local function getTargetPlot()
    if not M.targetPlayer then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner")
        if owner and owner.Value == M.targetPlayer then
            local ok, cf = pcall(function() return plot:GetPivot() end)
            if ok then return cf, plot end
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
            if t:find("drop") or t:find("place") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    local d = (parent.Position - cf.Position).Magnitude
                    if d < 50 then return o end
                end
            end
        end
    end
    return nil
end

local function dropAtTarget()
    local plotCF = getTargetPlot()
    if not plotCF then return false, "Target plot gak ketemu" end
    if M.mode == "Teleport" then
        tp(plotCF)
        task.wait(0.5)
    else
        idleMoveTo(plotCF.Position, 15)
        task.wait(0.3)
    end
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
    return true, "Sampai di plot target"
end

local function backToRanch()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner")
            if owner and owner.Value == LP then
                local cf = plot:GetPivot()
                if M.mode == "Teleport" then
                    tp(cf)
                else
                    idleMoveTo(cf.Position, 15)
                end
                task.wait(0.3)
                return
            end
        end
    end
end

local thread
local function loop()
    while M.enabled do
        if M.targetPlayer then
            local egg = findBestEgg()
            if egg then
                local picked = pickEgg(egg)
                if picked then
                    M.stats.farmed = M.stats.farmed + 1
                    task.wait(0.3)
                    if hasEgg() then
                        local ok = dropAtTarget()
                        if ok then
                            M.stats.shared = M.stats.shared + 1
                            task.wait(0.5)
                        end
                        backToRanch()
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

function M.getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p.Name) end
    end
    return list
end

return M
