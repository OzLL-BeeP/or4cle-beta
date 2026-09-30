-- OR4CLE v5 Util
local TweenService = game:GetService("TweenService")

local U = {}

-- ============ INSTANCE ============
function U.new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

function U.corner(parent, radius)
    return U.new("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

function U.gradient(parent, a, b, rotation)
    return U.new("UIGradient", {
        Color = ColorSequence.new(a, b),
        Rotation = rotation or 0,
        Parent = parent,
    })
end

function U.gradientMulti(parent, colors, rotation)
    local seq = {}
    local n = #colors
    for i, c in ipairs(colors) do
        table.insert(seq, ColorSequenceKeypoint.new((i-1)/(n-1), c))
    end
    return U.new("UIGradient", {
        Color = ColorSequence.new(seq),
        Rotation = rotation or 0,
        Parent = parent,
    })
end

function U.stroke(parent, color, thickness)
    return U.new("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

function U.pad(parent, t, r, b, l)
    return U.new("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingRight  = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        Parent = parent,
    })
end

-- ============ COLOR ============
function U.rgb(t, alpha)
    return Color3.fromRGB(t[1], t[2], t[3]), (t[4] or alpha or 0)
end

function U.rgb3(t)
    return Color3.fromRGB(t[1], t[2], t[3])
end

-- ============ ANIMASI ============
local EASING = {
    out    = Enum.EasingStyle.Quint,
    inout  = Enum.EasingStyle.Sine,
    spring = Enum.EasingStyle.Back,
    linear = Enum.EasingStyle.Linear,
}

function U.tween(obj, props, time, easing)
    local info = TweenInfo.new(
        time or 0.2,
        EASING[easing or "out"] or Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function U.hover(btn, enterProps, leaveProps)
    local orig = {}
    for k in pairs(enterProps) do orig[k] = btn[k] end
    btn.MouseEnter:Connect(function()
        U.tween(btn, enterProps, 0.12, "inout")
    end)
    btn.MouseLeave:Connect(function()
        U.tween(btn, leaveProps or orig, 0.12, "inout")
    end)
end

function U.ripple(btn, color)
    btn.MouseButton1Down:Connect(function()
        local r = U.new("Frame", {
            Size = UDim2.fromScale(0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = color or Color3.new(1, 1, 1),
            BackgroundTransparency = 0.75,
            BorderSizePixel = 0,
            ZIndex = (btn.ZIndex or 1) + 1,
            Parent = btn,
        })
        U.corner(r, 999)
        local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
        U.tween(r, {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
        }, 0.55, "out")
        task.delay(0.6, function() if r then r:Destroy() end end)
    end)
end

-- ============ TEXT HELPERS ============
function U.title(parent, props)
    local d = {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(242, 242, 248),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.subtitle(parent, props)
    local d = {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(158, 158, 184),
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.label(parent, props)
    local d = {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(242, 242, 248),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.sectionTitle(parent, props)
    local d = {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(158, 158, 184),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.value(parent, props)
    local d = {
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(96, 165, 250),
        Font = Enum.Font.Code,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.tag(parent, props)
    local d = {
        BackgroundColor3 = Color3.fromRGB(35, 35, 54),
        BorderSizePixel = 0,
        TextColor3 = Color3.fromRGB(158, 158, 184),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do d[k] = v end
    return U.new("TextLabel", d)
end

function U.divider(parent, color)
    return U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = color or Color3.fromRGB(42, 42, 63),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent,
    })
end

-- ============ FORMAT ============
function U.fmt(n)
    if type(n) ~= "number" then return tostring(n) end
    if n >= 1e12 then return string.format("%.2fT", n/1e12) end
    if n >= 1e9 then return string.format("%.2fB", n/1e9) end
    if n >= 1e6 then return string.format("%.2fM", n/1e6) end
    if n >= 1e3 then return string.format("%.1fK", n/1e3) end
    return tostring(math.floor(n))
end

function U.uptime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = math.floor(sec % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- ============ RARITY (untuk dipakai di mana aja) ============
U.TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }
U.TIER_COLORS = {
    Common   = Color3.fromRGB(180, 180, 180),
    Rare     = Color3.fromRGB(80, 160, 255),
    Epic     = Color3.fromRGB(180, 100, 255),
    Legend   = Color3.fromRGB(255, 150, 50),
    Mythic   = Color3.fromRGB(255, 80, 80),
    Divine   = Color3.fromRGB(255, 215, 0),
    Ethereal = Color3.fromRGB(255, 100, 255),
    Unknown  = Color3.fromRGB(120, 120, 120),
}
U.TIER_LIST = {"Common","Rare","Epic","Legend","Mythic","Divine","Ethereal"}

function U.tierOf(name)
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

return U
