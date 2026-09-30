local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    -- container transparan (cuma buat hitbox & border)
    local bubble = U.new("ImageButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ClipsDescendants = false,
        Parent = parent,
    })
    U.corner(bubble, config.BubbleSize)

    -- outer glow ungu (pulse)
    local glow = U.new("Frame", {
        Name = "Glow",
        Size = UDim2.fromOffset(config.BubbleSize + 16, config.BubbleSize + 16),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(124, 58, 237),
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = -1,
        Parent = bubble,
    })
    U.corner(glow, config.BubbleSize + 16)

    -- logo bulat (di-crop pakai UICorner)
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
    U.corner(logoFrame, config.BubbleSize)   -- bikin bulat sempurna

    -- logo full di dalam frame bulat
    U.new("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0,
        ScaleType = Enum.ScaleType.Crop,
        Parent = logoFrame,
    })

    -- border ungu di luar
    local stroke = U.stroke(bubble, Color3.fromRGB(124, 58, 237), 2.5)
    U.gradient(stroke,
        Color3.fromRGB(37, 99, 235),   -- biru
        Color3.fromRGB(124, 58, 237),  -- ungu
        45)

    -- pulse glow animation
    task.spawn(function()
        local t = 0
        while bubble.Parent do
            t = t + 0.03
            glow.BackgroundTransparency = 0.72 + math.sin(t * 2) * 0.10
            task.wait(0.03)
        end
    end)

    -- hover scale
    bubble.MouseEnter:Connect(function()
        U.tween(bubble, {
            Size = UDim2.fromOffset(config.BubbleSize + 6, config.BubbleSize + 6)
        }, 0.2, "spring")
    end)
    bubble.MouseLeave:Connect(function()
        U.tween(bubble, {
            Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize)
        }, 0.2, "inout")
    end)

    if onClick then bubble.MouseButton1Click:Connect(onClick) end
    return bubble
end
