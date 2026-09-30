local M = {}

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }
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

M.minTier = "Common"
M.showLabel = true
M.showDistance = true

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

local function passFilter(tier)
    local a = TIER_ORDER[M.minTier] or 0
    local b = TIER_ORDER[tier] or 0
    return b >= a
end

local cache = {}

function M.scan(parent)
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return end
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    for _, egg in ipairs(re:GetChildren()) do
        local tier = M.tierOf(egg.Name)
        if passFilter(tier) then
            if not cache[egg] or not cache[egg].hl or not cache[egg].hl.Parent then
                -- Highlight
                local hl = Instance.new("Highlight")
                hl.FillColor = TIER_COLOR[tier]
                hl.OutlineColor = TIER_COLOR[tier]
                hl.FillTransparency = 0.6
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = egg
                hl.Parent = parent

                -- Billboard label
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.fromOffset(160, 50)
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.AlwaysOnTop = true
                bb.Adornee = egg
                bb.Parent = parent

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "NameLbl"
                nameLbl.Size = UDim2.new(1, 0, 0, 20)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = egg.Name
                nameLbl.TextColor3 = TIER_COLOR[tier]
                nameLbl.TextStrokeTransparency = 0
                nameLbl.Font = Enum.Font.GothamBold
                nameLbl.TextSize = 13
                nameLbl.Parent = bb

                local infoLbl = Instance.new("TextLabel")
                infoLbl.Name = "InfoLbl"
                infoLbl.Size = UDim2.new(1, 0, 0, 16)
                infoLbl.Position = UDim2.fromOffset(0, 20)
                infoLbl.BackgroundTransparency = 1
                infoLbl.Text = "[" .. tier .. "]"
                infoLbl.TextColor3 = Color3.fromRGB(220, 220, 240)
                infoLbl.TextStrokeTransparency = 0
                infoLbl.Font = Enum.Font.Gotham
                infoLbl.TextSize = 11
                infoLbl.Parent = bb

                local distLbl = Instance.new("TextLabel")
                distLbl.Name = "DistLbl"
                distLbl.Size = UDim2.new(1, 0, 0, 14)
                distLbl.Position = UDim2.fromOffset(0, 34)
                distLbl.BackgroundTransparency = 1
                distLbl.Text = "0 studs"
                distLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
                distLbl.TextStrokeTransparency = 0
                distLbl.Font = Enum.Font.Gotham
                distLbl.TextSize = 10
                distLbl.Parent = bb

                cache[egg] = { hl = hl, bb = bb }
            else
                -- update label dinamis
                local c = cache[egg]
                if M.showLabel and hrp then
                    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
                    if base then
                        local d = (base.Position - hrp.Position).Magnitude
                        local distLbl = c.bb:FindFirstChild("DistLbl")
                        if distLbl then distLbl.Text = string.format("%d studs", d) end
                    end
                end
            end
        else
            -- hapus kalau gak lolos filter
            if cache[egg] then
                if cache[egg].hl then cache[egg].hl:Destroy() end
                if cache[egg].bb then cache[egg].bb:Destroy() end
                cache[egg] = nil
            end
        end
    end
end

function M.setMinTier(tier)
    M.minTier = tier
    -- paksa re-scan
    for egg, c in pairs(cache) do
        if c.hl then c.hl:Destroy() end
        if c.bb then c.bb:Destroy() end
    end
    cache = {}
end

function M.clear()
    for _, c in pairs(cache) do
        if c.hl then c.hl:Destroy() end
        if c.bb then c.bb:Destroy() end
    end
    cache = {}
end

return M
