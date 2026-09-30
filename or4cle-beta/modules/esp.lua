local M = {}
local cache = {}

local TIER_COLOR = {
    Ethereal = Color3.fromRGB(255, 100, 255),
    Divine   = Color3.fromRGB(255, 215, 0),
    Mythic   = Color3.fromRGB(255, 80, 80),
    Legend   = Color3.fromRGB(255, 150, 50),
    Epic     = Color3.fromRGB(180, 100, 255),
    Rare     = Color3.fromRGB(80, 160, 255),
    Common   = Color3.fromRGB(180, 180, 180),
    Unknown  = Color3.fromRGB(120, 120, 120),
}

function M.tierOf(name)
    local n = name:lower()
    if n:find("volcanic") or n:find("cherub") or n:find("solaris") or n:find("blackhole") then return "Ethereal" end
    if n:find("bloom") or n:find("galaxy") or n:find("aurora") then return "Divine" end
    if n:find("tidal") or n:find("soul") or n:find("sinister") or n:find("flaming") or n:find("dominus")
    or n:find("asteroid") or n:find("skull") or n:find("crystal") or n:find("diamond") then return "Mythic" end
    if n:find("golden") or n:find("glass") then return "Legend" end
    if n:find("ice") or n:find("slime") or n:find("flower") or n:find("mushroom") then return "Epic" end
    if n:find("leaf") or n:find("stone") or n:find("easter") or n:find("cracked") then return "Rare" end
    if n:find("brown") or n:find("white") then return "Common" end
    return "Unknown"
end

function M.scan(parent)
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return end
    for _, egg in ipairs(re:GetChildren()) do
        if not cache[egg] or not cache[egg].Parent then
            local tier = M.tierOf(egg.Name)
            local hl = Instance.new("Highlight")
            hl.FillColor = TIER_COLOR[tier]
            hl.OutlineColor = TIER_COLOR[tier]
            hl.FillTransparency = 0.5
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = egg
            hl.Parent = parent
            cache[egg] = hl
        end
    end
end

function M.clear()
    for egg, hl in pairs(cache) do
        if hl then hl:Destroy() end
    end
    cache = {}
end

return M
