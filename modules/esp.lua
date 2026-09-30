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
M.showTracer = true
M.showPanel = true

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

-- ============ PANEL BUILDER ============
local function buildPanel(parent, egg, tier)
    local color = TIER_COLOR[tier] or TIER_COLOR.Unknown

    local bb = Instance.new("BillboardGui")
    bb.Name = "OR4CLE_EggPanel"
    bb.Size = UDim2.fromOffset(200, 80)
    bb.StudsOffset = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = egg
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bb.LightInfluence = 0
    bb.Parent = parent

    -- panel background
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    panel.BackgroundTransparency = 0.15
    panel.BorderSizePixel = 0
    panel.Parent = bb

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 6)
    pc.Parent = panel

    local ps = Instance.new("UIStroke")
    ps.Name = "PanelStroke"
    ps.Color = color
    ps.Thickness = 1.5
    ps.Transparency = 0
    ps.Parent = panel

    -- top bar (tier color line)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, -12, 0, 2)
    topBar.Position = UDim2.fromOffset(6, 6)
    topBar.BackgroundColor3 = color
    topBar.BorderSizePixel = 0
    topBar.Parent = panel
    local tbc = Instance.new("UICorner")
    tbc.CornerRadius = UDim.new(1, 0)
    tbc.Parent = topBar

    -- dot + tier label
    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.fromOffset(8, 14)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = panel
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    local tierLbl = Instance.new("TextLabel")
    tierLbl.Name = "TierLbl"
    tierLbl.Size = UDim2.new(0.4, 0, 0, 14)
    tierLbl.Position = UDim2.fromOffset(18, 12)
    tierLbl.BackgroundTransparency = 1
    tierLbl.Text = tier:upper()
    tierLbl.TextColor3 = color
    tierLbl.Font = Enum.Font.GothamBold
    tierLbl.TextSize = 9
    tierLbl.TextXAlignment = Enum.TextXAlignment.Left
    tierLbl.Parent = panel

    -- egg name
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLbl"
    nameLbl.Size = UDim2.new(1, -12, 0, 18)
    nameLbl.Position = UDim2.fromOffset(6, 26)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = egg.Name
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = panel

    -- distance row
    local distRow = Instance.new("Frame")
    distRow.Name = "DistRow"
    distRow.Size = UDim2.new(1, -12, 0, 14)
    distRow.Position = UDim2.fromOffset(6, 46)
    distRow.BackgroundTransparency = 1
    distRow.Parent = panel

    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLbl"
    distLbl.Size = UDim2.new(0.5, 0, 1, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0 studs"
    distLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    distLbl.Font = Enum.Font.Code
    distLbl.TextSize = 11
    distLbl.TextXAlignment = Enum.TextXAlignment.Left
    distLbl.Parent = distRow

    -- distance bar
    local barBg = Instance.new("Frame")
    barBg.Name = "BarBg"
    barBg.Size = UDim2.new(0.45, 0, 0, 4)
    barBg.Position = UDim2.new(0.55, 0, 0.5, -2)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    barBg.BorderSizePixel = 0
    barBg.Parent = distRow
    local bbc = Instance.new("UICorner")
    bbc.CornerRadius = UDim.new(1, 0)
    bbc.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Size = UDim2.new(0.5, 0, 1, 0)
    barFill.BackgroundColor3 = color
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    local bfc = Instance.new("UICorner")
    bfc.CornerRadius = UDim.new(1, 0)
    bfc.Parent = barFill

    -- fade in animation
    panel.BackgroundTransparency = 1
    topBar.BackgroundTransparency = 1
    dot.BackgroundTransparency = 1
    barFill.BackgroundTransparency = 1
    tierLbl.TextTransparency = 1
    nameLbl.TextTransparency = 1
    distLbl.TextTransparency = 1
    task.spawn(function()
        task.wait(0.05)
        panel.BackgroundTransparency = 0.15
        topBar.BackgroundTransparency = 0
        dot.BackgroundTransparency = 0
        barFill.BackgroundTransparency = 0
        tierLbl.TextTransparency = 0
        nameLbl.TextTransparency = 0
        distLbl.TextTransparency = 0
    end)

    return bb
end

-- ============ TRACER BUILDER ============
local function buildTracer(parent, egg, color)
    local folder = Instance.new("Folder")
    folder.Name = "OR4CLE_Tracer"
    folder.Parent = parent

    local a0 = Instance.new("Attachment")
    a0.Name = "Start"
    a0.Parent = folder

    local a1 = Instance.new("Attachment")
    a1.Name = "End"
    a1.Parent = folder

    local beam = Instance.new("Beam")
    beam.Name = "Line"
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    beam.Color = ColorSequence.new(color)
    beam.Width0 = 0.08
    beam.Width1 = 0.08
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.7),
    })
    beam.Parent = folder

    return folder, a0, a1
end

-- ============ SCAN ============
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
                local color = TIER_COLOR[tier] or TIER_COLOR.Unknown

                local hl = Instance.new("Highlight")
                hl.Name = "OR4CLE_HL"
                hl.FillColor = color
                hl.OutlineColor = color
                hl.FillTransparency = 0.85
                hl.OutlineTransparency = 0.3
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = egg
                hl.Parent = parent

                local bb = buildPanel(parent, egg, tier)

                local tracerFolder, a0, a1
                if M.showTracer then
                    tracerFolder, a0, a1 = buildTracer(parent, egg, color)
                end

                cache[egg] = {
                    hl = hl, bb = bb, tier = tier, color = color,
                    tracer = tracerFolder, att0 = a0, att1 = a1,
                }
            else
                -- update posisi distance + tracer
                local c = cache[egg]
                if hrp then
                    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
                    if base then
                        local d = (base.Position - hrp.Position).Magnitude
                        local panel = c.bb:FindFirstChild("Panel")
                        if panel then
                            local dLbl = panel:FindFirstChild("DistRow") and panel.DistRow:FindFirstChild("DistLbl")
                            if dLbl then dLbl.Text = string.format("%d studs", math.floor(d)) end
                            local barFill = panel:FindFirstChild("DistRow") and panel.DistRow:FindFirstChild("BarBg") and panel.DistRow.BarBg:FindFirstChild("BarFill")
                            if barFill then
                                local ratio = math.clamp(1 - (d / 1000), 0.05, 1)
                                barFill.Size = UDim2.new(ratio, 0, 1, 0)
                            end
                        end
                        -- update tracer
                        if c.att0 and c.att1 then
                            c.att0.WorldPosition = hrp.Position + Vector3.new(0, 2, 0)
                            c.att1.WorldPosition = base.Position + Vector3.new(0, 2, 0)
                        end
                    end
                end
            end
        else
            if cache[egg] then
                if cache[egg].hl then cache[egg].hl:Destroy() end
                if cache[egg].bb then cache[egg].bb:Destroy() end
                if cache[egg].tracer then cache[egg].tracer:Destroy() end
                cache[egg] = nil
            end
        end
    end
end

function M.setMinTier(tier)
    M.minTier = tier
    M.clear()
end

function M.clear()
    for _, c in pairs(cache) do
        if c.hl then c.hl:Destroy() end
        if c.bb then c.bb:Destroy() end
        if c.tracer then c.tracer:Destroy() end
    end
    cache = {}
end

return M
