local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    local size = config.BubbleSize or 44

    local bubble = U.new("TextButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = false,
        Parent = parent,
    })

    -- LOGO kotak + sudut bulat dikit
    local logoFrame = U.new("Frame", {
        Name = "LogoFrame",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = bubble,
    })
    U.corner(logoFrame, 8)

    U.new("ImageLabel", {
        Size = UDim2.fromScale(1.1, 1.1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
        Parent = logoFrame,
    })

    -- RING UNGU di atas logo
    local ring = U.new("Frame", {
        Name = "Ring",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = bubble,
    })
    U.corner(ring, size / 2)

    local ringStroke = U.stroke(ring, Color3.fromRGB(124, 58, 237), 2.5)
    U.gradient(ringStroke,
        Color3.fromRGB(37, 99, 235),
        Color3.fromRGB(124, 58, 237),
        45)

    -- glow belakang
    local glow = U.new("Frame", {
        Name = "Glow",
        Size = UDim2.fromOffset(size + 12, size + 12),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(124, 58, 237),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = bubble,
    })
    U.corner(glow, (size + 12) / 2)

    -- state
    local dragging = false
    local dragStart, startPos
    local hovered = false
    local pulseT = 0

    -- pulse loop
    task.spawn(function()
        while bubble.Parent do
            pulseT = pulseT + 0.03
            glow.BackgroundTransparency = 0.78 + math.sin(pulseT * 2) * 0.08
            task.wait(0.03)
        end
    end)

    -- hover: scale cuma kalau GAK dragging
    bubble.MouseEnter:Connect(function()
        hovered = true
        if not dragging then
            U.tween(bubble, { Size = UDim2.fromOffset(size + 4, size + 4) }, 0.15, "inout")
        end
    end)
    bubble.MouseLeave:Connect(function()
        hovered = false
        if not dragging then
            U.tween(bubble, { Size = UDim2.fromOffset(size, size) }, 0.15, "inout")
        end
    end)

    -- drag
    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = bubble.Position
            -- balikin ke ukuran normal pas drag
            U.tween(bubble, { Size = UDim2.fromOffset(size, size) }, 0.1, "inout")
        end
    end)
    bubble.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            -- balik ke hover state
            if hovered then
                U.tween(bubble, { Size = UDim2.fromOffset(size + 4, size + 4) }, 0.15, "inout")
            end
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            bubble.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    if onClick then
        bubble.MouseButton1Click:Connect(function()
            if not dragging then onClick() end
        end)
    end
    return bubble
end
