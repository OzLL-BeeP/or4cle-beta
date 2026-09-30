local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    local size = config.BubbleSize or 44

    -- container (hitbox)
    local bubble = U.new("TextButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = parent,
    })
    U.corner(bubble, size / 2)   -- radius = setengah ukuran = bulat sempurna

    -- glow
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

    -- logo di dalam bubble (di-clip bulat)
    U.new("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
        Parent = bubble,
    })

    -- border ungu (stroke di bubble)
    local stroke = U.stroke(bubble, Color3.fromRGB(124, 58, 237), 2)
    U.gradient(stroke,
        Color3.fromRGB(37, 99, 235),
        Color3.fromRGB(124, 58, 237),
        45)

    -- pulse glow
    task.spawn(function()
        local t = 0
        while bubble.Parent do
            t = t + 0.03
            glow.BackgroundTransparency = 0.78 + math.sin(t * 2) * 0.08
            task.wait(0.03)
        end
    end)

    bubble.MouseEnter:Connect(function()
        U.tween(bubble, { Size = UDim2.fromOffset(size + 4, size + 4) }, 0.2, "spring")
    end)
    bubble.MouseLeave:Connect(function()
        U.tween(bubble, { Size = UDim2.fromOffset(size, size) }, 0.2, "inout")
    end)

    if onClick then bubble.MouseButton1Click:Connect(onClick) end
    return bubble
end
