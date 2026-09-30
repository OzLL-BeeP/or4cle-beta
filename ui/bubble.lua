local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    local bubble = U.new("ImageButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ClipsDescendants = false,
        Parent = parent,
    })
    U.corner(bubble, config.BubbleSize)

    local glow = U.new("Frame", {
        Name = "Glow",
        Size = UDim2.fromOffset(config.BubbleSize + 14, config.BubbleSize + 14),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = U.rgb3(config.AccentA),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = -1,
        Parent = bubble,
    })
    U.corner(glow, config.BubbleSize + 14)

    local stroke = U.stroke(bubble, U.rgb3(config.AccentA), 2)
    U.gradientMulti(stroke, {
        U.rgb3(config.AccentA),
        U.rgb3(config.AccentB),
        U.rgb3(config.AccentA),
    }, 45)

    local inner = U.new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Parent = bubble,
    })
    U.corner(inner, config.BubbleSize)
    U.gradient(inner, U.rgb3(config.AccentA), U.rgb3(config.AccentB), 45)

    U.new("ImageLabel", {
        Size = UDim2.fromScale(0.72, 0.72),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        Parent = bubble,
    })

    task.spawn(function()
        local t = 0
        while bubble.Parent do
            t = t + 0.03
            glow.BackgroundTransparency = 0.78 + math.sin(t * 2) * 0.08
            task.wait(0.03)
        end
    end)

    bubble.MouseEnter:Connect(function()
        U.tween(bubble, { Size = UDim2.fromOffset(config.BubbleSize + 6, config.BubbleSize + 6) }, 0.2, "spring")
    end)
    bubble.MouseLeave:Connect(function()
        U.tween(bubble, { Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize) }, 0.2, "inout")
    end)

    if onClick then bubble.MouseButton1Click:Connect(onClick) end
    return bubble
end
