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

-- ============ CONFIG ============
M.minTier = "Common"
M.showDistance = true
M.showTracer = true
M.showTierLabel = true
M.showEggName = true
M.style = "Panel"   -- "Panel" | "Bracket" | "Minimal"

-- ============ TIER DETECT ============
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

-- ============ PANEL BUILDER ============
local function makePanelBB(parent, egg, tier, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "OR4CLE_EggPanel"
    bb.Size = UDim2.fromOffset(220, 100)
    bb.StudsOffset = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = egg
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bb.LightInfluence = 0
    bb.Parent = parent

    -- bracket corner (4 sudut)
    local bracketHolder = Instance.new("Frame")
    bracketHolder.Name = "BracketHolder"
    bracketHolder.Size = UDim2.new(1, 20, 1, 20)
    bracketHolder.Position = UDim2.fromScale(0.5, 0.5)
    bracketHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    bracketHolder.BackgroundTransparency = 1
    bracketHolder.Parent = bb

    local bracketSize = 12
    local bracketThick = 2

    local function makeBracket(pos, rotX, rotY)
        local br = Instance.new("Frame")
        br.Name = "Bracket"
        br.Size = UDim2.fromOffset(bracketSize, bracketSize)
        br.Position = pos
        br.BackgroundTransparency = 1
        br.Parent = bracketHolder

        -- horizontal line
        local h = Instance.new("Frame")
        h.Size = UDim2.fromOffset(bracketSize, bracketThick)
        h.Position = UDim2.fromOffset(rotX == -1 and bracketSize - bracketThick or 0, rotY == -1 and bracketSize - bracketThick or 0)
        h.BackgroundColor3 = color
        h.BorderSizePixel = 0
        h.Parent = br

        -- vertical line
        local v = Instance.new("Frame")
        v.Size = UDim2.fromOffset(bracketThick, bracketSize)
        v.Position = UDim2.fromOffset(rotX == -1 and bracketSize - bracketThick or 0, rotY == -1 and bracketSize - bracketThick or 0)
        v.BackgroundColor3 = color
        v.BorderSizePixel = 0
        v.Parent = br
    end

    -- 4 sudut
    makeBracket(UDim2.fromOffset(0, 0), 1, 1)                                 -- top-left
    makeBracket(UDim2.new(1, -bracketSize, 0, 0), -1, 1)                      -- top-right
    makeBracket(UDim2.fromOffset(0, 0), 1, -1)                                -- bottom-left (adjust pos)
    makeBracket(UDim2.new(1, -bracketSize, 1, -bracketSize), -1, -1)          -- bottom-right

    -- fix bottom-left position
    local children = bracketHolder:GetChildren()
    for _, c in ipairs(children) do
        if c:IsA("Frame") and c.Position.Y.Offset > 0 then
            c.Position = UDim2.new(0, 0, 1, -bracketSize)
        end
    end

    -- panel info (di tengah)
    local panel = Instance.new("Frame")
    panel.Name = "InfoPanel"
    panel.Size = UDim2.fromOffset(180, 44)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    panel.BackgroundTransparency = 0.15
    panel.BorderSizePixel = 0
    panel.Parent = bb

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 6)
    pc.Parent = panel

    local ps = Instance.new("UIStroke")
    ps.Color = color
    ps.Thickness = 1.5
    ps.Transparency = 0.2
    ps.Parent = panel

    -- top accent bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, -12, 0, 2)
    topBar.Position = UDim2.fromOffset(6, 6)
    topBar.BackgroundColor3 = color
    topBar.BorderSizePixel = 0
    topBar.Parent = panel
    local tbc = Instance.new("UICorner")
    tbc.CornerRadius = UDim.new(1, 0)
    tbc.Parent = topBar

    -- tier label (kiri atas)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.fromOffset(10, 14)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = panel
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    local tierLbl = Instance.new("TextLabel")
    tierLbl.Name = "TierLbl"
    tierLbl.Size = UDim2.new(1, -30, 0, 12)
    tierLbl.Position = UDim2.fromOffset(22, 11)
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
    nameLbl.Size = UDim2.new(1, -12, 0, 16)
    nameLbl.Position = UDim2.fromOffset(6, 24)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = egg.Name
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = panel

    -- distance (kanan bawah)
    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLbl"
    distLbl.Size = UDim2.new(0.5, -6, 0, 12)
    distLbl.Position = UDim2.new(0.5, 0, 0, 44)
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
    tierLbl.TextTransparency = 1
    nameLbl.TextTransparency = 1
    distLbl.TextTransparency = 1
    task.spawn(function()
        task.wait(0.05)
        panel.BackgroundTransparency = 0.15
        topBar.BackgroundTransparency = 0
        dot.BackgroundTransparency = 0
        tierLbl.TextTransparency = 0
        nameLbl.TextTransparency = 0
        distLbl.TextTransparency = 0
    end)

    return bb
end

-- ============ BRACKET ONLY ============
local function makeBracketBB(parent, egg, tier, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "OR4CLE_EggBracket"
    bb.Size = UDim2.fromOffset(120, 120)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = egg
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bb.LightInfluence = 0
    bb.Parent = parent

    local holder = Instance.new("Frame")
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.Parent = bb

    local bracketSize = 16
    local bracketThick = 2

    local positions = {
        {UDim2.fromOffset(0, 0), 1, 1},
        {UDim2.new(1, -bracketSize, 0, 0), -1, 1},
        {UDim2.new(0, 0, 1, -bracketSize), 1, -1},
        {UDim2.new(1, -bracketSize, 1, -bracketSize), -1, -1},
    }

    for _, p in ipairs(positions) do
        local pos, px, py = p[1], p[2], p[3]
        local br = Instance.new("Frame")
        br.Size = UDim2.fromOffset(bracketSize, bracketSize)
        br.Position = pos
        br.BackgroundTransparency = 1
        br.Parent = holder

        local h = Instance.new("Frame")
        h.Size = UDim2.fromOffset(bracketSize, bracketThick)
        h.Position = UDim2.fromOffset(px == -1 and 0 or 0, py == -1 and bracketSize - bracketThick or 0)
        h.BackgroundColor3 = color
        h.BorderSizePixel = 0
        h.Parent = br

        local v = Instance.new("Frame")
        v.Size = UDim2.fromOffset(bracketThick, bracketSize)
        v.Position = UDim2.fromOffset(px == -1 and bracketSize - bracketThick or 0, 0)
        v.BackgroundColor3 = color
        v.BorderSizePixel = 0
        v.Parent = br
    end

    -- tier label kecil di atas bracket
    local tierLbl = Instance.new("TextLabel")
    tierLbl.Size = UDim2.new(1, 0, 0, 14)
    tierLbl.Position = UDim2.new(0, 0, 0, -18)
    tierLbl.BackgroundTransparency = 1
    tierLbl.Text = tier:upper()
    tierLbl.TextColor3 = color
    tierLbl.Font = Enum.Font.GothamBold
    tierLbl.TextSize = 10
    tierLbl.TextStrokeTransparency = 0.3
    tierLbl.Parent = bb

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
                        local panel = c.bb:FindFirstChild("InfoPanel")
                        if panel then
                            local distLbl = panel:FindFirstChild("DistLbl")
                            if distLbl then
                                distLbl.Text = string.format("%d studs", math.floor(d))
                            end
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
