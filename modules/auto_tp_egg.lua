local M = {}
local LP = game:GetService("Players").LocalPlayer

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }
local TIER_COLOR = {
    Ethereal = "Ethereal",
    Divine   = "Divine",
    Mythic   = "Mythic",
    Legend   = "Legend",
    Epic     = "Epic",
    Rare     = "Rare",
    Common   = "Common",
}

M.enabled = false
M.minTier = "Divine"
M.autoPickup = true
M.cooldown = 2

function M.tierOf(name)
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

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function firePickup(egg)
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            if fireproximityprompt then fireproximityprompt(d) end
            return true
        end
    end
    return false
end

local lastTp = 0

task.spawn(function()
    while true do
        task.wait(1)
        if M.enabled then
            local h = hrp()
            if h then
                local re = workspace:FindFirstChild("RenderedEggs")
                if re then
                    local bestEgg, bestTier = nil, 0
                    for _, egg in ipairs(re:GetChildren()) do
                        local tier = M.tierOf(egg.Name)
                        local rank = TIER_ORDER[tier] or 0
                        if rank >= (TIER_ORDER[M.minTier] or 6) then
                            if rank > bestTier then
                                bestEgg, bestTier = egg, rank
                            end
                        end
                    end
                    if bestEgg and tick() - lastTp > M.cooldown then
                        lastTp = tick()
                        local base = bestEgg:FindFirstChild("EggBase")
                            or bestEgg:FindFirstChildWhichIsA("BasePart")
                        if base then
                            h.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                            if M.autoPickup then firePickup(bestEgg) end
                        end
                    end
                end
            end
        end
    end
end)

function M.toggle(on) M.enabled = on end
function M.setMinTier(t) M.minTier = t end
function M.setAutoPickup(on) M.autoPickup = on end

return M
