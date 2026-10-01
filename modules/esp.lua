-- OR4CLE esp.lua v6 — modern panel + bracket + tracer
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
M.showDistance = true
M.showTracer = true
M.style = "Panel"   -- "Panel" | "Bracket"

function M.tierOf(name)
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

-- ============ PANEL MODE ============
local function makePanelBB(parent, egg, tier, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "OR4CLE_EggPanel"
    bb.Size = UDim2.fromOffset(220, 90)
    bb.StudsOffset = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = egg
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bb.LightInfluence = 0
    bb.Parent = parent

    -- outer glow
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 10, 1, 10)
    glow.Position = UDim2.fromScale(0.5, 0.5)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundColor3 = color
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.Parent = bb
    local gc = Instance.new("UICorner")
    gc.CornerRadius = UDim.new(0, 10)
    gc.Parent = glow

    -- main panel
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.fromScale(1, 1)
    panel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    panel.BackgroundTransparency = 0.1
    panel.BorderSizePixel = 0
    panel.Parent = bb
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 8)
    pc.Parent = panel

    local ps = Instance.new("UIStroke")
    ps.Color = color
    ps.Thickness = 1.5
    ps.Transparency = 0.1
    ps.Parent = panel

    -- top accent bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, -16, 0, 3)
    topBar.Position = UDim2.fromOffset(8, 6)
    topBar.BackgroundColor3 = color
    topBar.BorderSizePixel = 0
    topBar.Parent = panel
    local tbc = Instance.new("UICorner")
    tbc.CornerRadius = UDim.new(1, 0)
    tbc.Parent = topBar

    -- tier row: dot + label
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.fromOffset(12, 16)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = panel
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    local tierLbl = Instance.new("TextLabel")
    tierLbl.Name = "TierLbl"
    tierLbl.Size = UDim2.new(1, -30, 0, 12)
    tierLbl.Position = UDim2.fromOffset(24, 13)
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
    nameLbl.Size = UDim2.new(1, -20, 0, 18)
    nameLbl.Position = UDim2.fromOffset(10, 32)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = egg.Name
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = panel

    -- distance row (bar + text)
    local distBg = Instance.new("Frame")
    distBg.Name = "DistBg"
    distBg.Size = UDim2.new(1, -20, 0, 4)
    distBg.Position = UDim2.fromOffset(10, 58)
    distBg.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    distBg.BorderSizePixel = 0
    distBg.Parent = panel
    local dbc = Instance.new("UICorner")
    dbc.CornerRadius = UDim.new(1, 0)
    dbc.Parent = distBg

    local distFill = Instance.new("Frame")
    distFill.Name = "DistFill"
    distFill.Size = UDim2.new(0.5, 0, 1, 0)
    distFill.BackgroundColor3 = color
    distFill.BorderSizePixel = 0
    distFill.Parent = distBg
    local dfc = Instance.new("UICorner")
    dfc.CornerRadius = UDim.new(1, 0)
    dfc.Parent = distFill

    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLbl"
    distLbl.Size = UDim2.new(1, -20, 0, 12)
    distLbl.Position = UDim2.fromOffset(10, 66)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0 studs"
    distLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    distLbl.Font = Enum.Font.Code
    distLbl.TextSize = 10
    distLbl.TextXAlignment = Enum.TextXAlignment.Right
    distLbl.Parent = panel

    -- fade in
    panel.BackgroundTransparency = 1
    topBar.BackgroundTransparency = 1
    dot.BackgroundTransparency = 1
    distFill.BackgroundTransparency = 1
    tierLbl.TextTransparency = 1
    nameLbl.TextTransparency = 1
    distLbl.TextTransparency = 1
    task.spawn(function()
        task.wait(0.05)
        panel.BackgroundTransparency = 0.1
        topBar.BackgroundTransparency = 0
        dot.BackgroundTransparency = 0
        distFill.BackgroundTransparency = 0
        tierLbl.TextTransparency = 0
        nameLbl.TextTransparency = 0
        distLbl.TextTransparency = 0
    end)

    return bb
end

-- ============ BRACKET MODE (Upgrade) ============
local function makeBracketBB(parent, egg, tier, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "OR4CLE_EggBracket"
    bb.Size = UDim2.fromOffset(140, 140)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = egg
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bb.LightInfluence = 0
    bb.Parent = parent

    -- bracket container
    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.Parent = bb

    local brSize = 18
    local brThick = 2

    local positions = {
        {UDim2.fromOffset(0, 0), 0, 0},
        {UDim2.new(1, -brSize, 0, 0), 1, 0},
        {UDim2.new(0, 0, 1, -brSize), 0, 1},
        {UDim2.new(1, -brSize, 1, -brSize), 1, 1},
    }

    for _, p in ipairs(positions) do
        local pos, isRight, isBottom = p[1], p[2], p[3]
        local corner = Instance.new("Frame")
        corner.Size = UDim2.fromOffset(brSize, brSize)
        corner.Position = pos
        corner.BackgroundTransparency = 1
        corner.Parent = holder

        -- horizontal line
        local h = Instance.new("Frame")
        h.Size = UDim2.fromOffset(brSize, brThick)
        h.Position = UDim2.fromOffset(0, isBottom == 1 and brSize - brThick or 0)
        h.BackgroundColor3 = color
        h.BorderSizePixel = 0
        h.Parent = corner

        -- vertical line
        local v = Instance.new("Frame")
        v.Size = UDim2.fromOffset(brThick, brSize)
        v.Position = UDim2.fromOffset(isRight == 1 and brSize - brThick or 0, 0)
        v.BackgroundColor3 = color
        v.BorderSizePixel = 0
        v.Parent = corner
    end

    -- info panel di atas bracket (bukan di dalam)
    local topPanel = Instance.new("Frame")
    topPanel.Name = "TopPanel"
    topPanel.Size = UDim2.new(1, 0, 0, 32)
    topPanel.Position = UDim2.new(0, 0, 0, -40)
    topPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    topPanel.BackgroundTransparency = 0.15
    topPanel.BorderSizePixel = 0
    topPanel.Parent = bb
    local tpc = Instance.new("UICorner")
    tpc.CornerRadius = UDim.new(0, 6)
    tpc.Parent = topPanel
    local tps = Instance.new("UIStroke")
    tps.Color = color
    tps.Thickness = 1
    tps.Transparency = 0.3
    tps.Parent = topPanel

    -- dot + tier
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.fromOffset(8, 6)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = topPanel
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    local tierLbl = Instance.new("TextLabel")
    tierLbl.Name = "TierLbl"
    tierLbl.Size = UDim2.new(1, -20, 0, 10)
    tierLbl.Position = UDim2.fromOffset(18, 4)
    tierLbl.BackgroundTransparency = 1
    tierLbl.Text = tier:upper()
    tierLbl.TextColor3 = color
    tierLbl.Font = Enum.Font.GothamBold
    tierLbl.TextSize = 8
    tierLbl.TextXAlignment = Enum.TextXAlignment.Left
    tierLbl.Parent = topPanel

    -- egg name
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLbl"
    nameLbl.Size = UDim2.new(1, -12, 0, 14)
    nameLbl.Position = UDim2.fromOffset(6, 16)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = egg.Name
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 10
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = topPanel

    -- distance di bawah bracket
    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLbl"
    distLbl.Size = UDim2.new(1, 0, 0, 16)
    distLbl.Position = UDim2.new(0, 0, 1, 4)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0 studs"
    distLbl.TextColor3 = color
    distLbl.Font = Enum.Font.Code
    distLbl.TextSize = 10
    distLbl.TextStrokeTransparency = 0.4
    distLbl.Parent = bb

    -- fade in
    topPanel.BackgroundTransparency = 1
    dot.BackgroundTransparency = 1
    tierLbl.TextTransparency = 1
    nameLbl.TextTransparency = 1
    distLbl.TextTransparency = 1
    task.spawn(function()
        task.wait(0.05)
        topPanel.BackgroundTransparency = 0.15
        dot.BackgroundTransparency = 0
        tierLbl.TextTransparency = 0
        nameLbl.TextTransparency = 0
        distLbl.TextTransparency = 0
    end)

    return bb
end

-- ============ TRACER ============
local function makeTracer(parent, egg, color)
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
    beam.Width1 = 0.04
    beam.FaceCamera = true
    beam.LightEmission = 0.8
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.8),
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

                local bb
                if M.style == "Bracket" then
                    bb = makeBracketBB(parent, egg, tier, color)
                else
                    bb = makePanelBB(parent, egg, tier, color)
                end

                local tracerFolder, a0, a1
                if M.showTracer then
                    tracerFolder, a0, a1 = makeTracer(parent, egg, color)
                end

                cache[egg] = {
                    hl = hl, bb = bb, tier = tier, color = color,
                    tracer = tracerFolder, att0 = a0, att1 = a1,
                }
            else
                local c = cache[egg]
                if hrp then
                    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
                    if base then
                        local d = (base.Position - hrp.Position).Magnitude
                        -- update distance di panel/bracket
                        local panel = c.bb:FindFirstChild("Panel")
                        local distLbl
                        local distFill
                        if panel then
                            distLbl = panel:FindFirstChild("DistLbl")
                            local distBg = panel:FindFirstChild("DistBg")
                            if distBg then distFill = distBg:FindFirstChild("DistFill") end
                        else
                            distLbl = c.bb:FindFirstChild("DistLbl")
                        end
                        if distLbl then
                            distLbl.Text = string.format("%d studs", math.floor(d))
                        end
                        if distFill then
                            local ratio = math.clamp(1 - (d / 2000), 0.05, 1)
                            distFill.Size = UDim2.new(ratio, 0, 1, 0)
                        end
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

function M.setStyle(style)
    M.style = style
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
