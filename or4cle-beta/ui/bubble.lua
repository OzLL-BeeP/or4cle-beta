local U = require(script.Parent.Parent.util)

return function(parent, config, onClick)
    local bubble = U.new("ImageButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = parent,
    })
    U.corner(bubble, config.BubbleSize)
    U.stroke(bubble, Color3.fromRGB(unpack(config.AccentB)), 2)

    local inner = U.new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Parent = bubble,
    })
    U.corner(inner, config.BubbleSize)
    U.gradient(inner,
        Color3.fromRGB(unpack(config.AccentA)),
        Color3.fromRGB(unpack(config.AccentB)), 45)

    U.new("ImageLabel", {
        Size = UDim2.fromScale(0.65, 0.65),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        Parent = bubble,
    })

    if onClick then
        bubble.MouseButton1Click:Connect(onClick)
    end
    return bubble
end
