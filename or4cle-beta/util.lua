local U = {}

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
        Parent = parent
    })
end

function U.stroke(parent, color, thickness)
    return U.new("UIStroke", {
        Color = color, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

return U
