local M = {}
local LP = game:GetService("Players").LocalPlayer

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

-- TP ke egg terdekat (tanpa filter)
function M.tpNearest()
    local h = hrp()
    if not h then return false end
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return false end
    local best, minD = nil, math.huge
    for _, egg in ipairs(re:GetChildren()) do
        local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
        if base then
            local d = (base.Position - h.Position).Magnitude
            if d < minD then best, minD = base, d end
        end
    end
    if best then
        tp(best.CFrame + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

-- TP ke egg dengan tier tertinggi (rarity filter ignored, selalu highest)
function M.tpHighestTier()
    local h = hrp()
    if not h then return false end
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return false end
    local best, bestRank, bestDist = nil, -1, math.huge
    for _, egg in ipairs(re:GetChildren()) do
        local rank = TIER_ORDER[tierOf(egg.Name)] or 0
        local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
        if base then
            local d = (base.Position - h.Position).Magnitude
            if rank > bestRank or (rank == bestRank and d < bestDist) then
                best, bestRank, bestDist = base, rank, d
            end
        end
    end
    if best then
        tp(best.CFrame + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

-- TP ke egg dengan tier tertinggi TAPI ikut filter minTier
function M.tpHighestFiltered(minTier)
    local h = hrp()
    if not h then return false end
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return false end
    local minRank = TIER_ORDER[minTier] or 0
    local best, bestRank, bestDist = nil, -1, math.huge
    for _, egg in ipairs(re:GetChildren()) do
        local rank = TIER_ORDER[tierOf(egg.Name)] or 0
        if rank >= minRank then
            local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
            if base then
                local d = (base.Position - h.Position).Magnitude
                if rank > bestRank or (rank == bestRank and d < bestDist) then
                    best, bestRank, bestDist = base, rank, d
                end
            end
        end
    end
    if best then
        tp(best.CFrame + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

function M.tp(cf) tp(cf) end

return M
