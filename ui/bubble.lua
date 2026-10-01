local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    local size = config.BubbleSize or 50
    local posX = config.BubbleX or 80
    local posY = config.BubbleY or 200

    -- container
    local container = Instance.new("Frame")
    container.Name = "BubbleContainer"
    container.Size = UDim2.fromOffset(size + 30, size + 30)
    container.Position = UDim2.fromOffset(posX - 15, posY - 15)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 5
    container.Parent = parent

    -- outer glow (pulse)
    local glow1 = Instance.new("Frame")
    glow1.Name = "GlowOuter"
    glow1.Size = UDim2.fromOffset(size + 20, size + 20)
    glow1.Position = UDim2.fromScale(0.5, 0.5)
    glow1.AnchorPoint = Vector2.new(0.5, 0.5)
    glow1.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    glow1.BackgroundTransparency = 0.88
    glow1.BorderSizePixel = 0
    glow1.ZIndex = 4
    glow1.Parent = container
    local gc1 = Instance.new("UICorner")
    gc1.CornerRadius = UDim.new(1, 0)
    gc1.Parent = glow1

    -- inner glow
    local glow2 = Instance.new("Frame")
    glow2.Name = "GlowInner"
    glow2.Size = UDim2.fromOffset(size + 10, size + 10)
    glow2.Position = UDim2.fromScale(0.5, 0.5)
    glow2.AnchorPoint = Vector2.new(0.5, 0.5)
    glow2.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    glow2.BackgroundTransparency = 0.9
    glow2.BorderSizePixel = 0
    glow2.ZIndex = 5
    glow2.Parent = container
    local gc2 = Instance.new("UICorner")
    gc2.CornerRadius = UDim.new(1, 0)
    gc2.Parent = glow2

    -- main bubble (hitbox)
    local bubble = Instance.new("TextButton")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.fromOffset(size, size)
    bubble.Position = UDim2.fromScale(0.5, 0.5)
    bubble.AnchorPoint = Vector2.new(0.5, 0.5)
    bubble.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    bubble.BackgroundTransparency = 0.05
    bubble.BorderSizePixel = 0
    bubble.Text = ""
    bubble.AutoButtonColor = false
    bubble.Active = true
    bubble.ClipsDescendants = true
    bubble.ZIndex = 8
    bubble.Parent = container
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bubble

    -- gradient border (2 lapis)
    local stroke1 = Instance.new("UIStroke")
    stroke1.Color = Color3.fromRGB(139, 92, 246)
    stroke1.Thickness = 2.5
    stroke1.Transparency = 0
    stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke1.Parent = bubble
    local sg1 = Instance.new("UIGradient")
    sg1.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(59, 130, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246)),
    })
    sg1.Rotation = 45
    sg1.Parent = stroke1

    -- glass highlight (di atas kiri)
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Size = UDim2.new(0.6, 0, 0.35, 0)
    highlight.Position = UDim2.fromScale(0.15, 0.08)
    highlight.BackgroundColor3 = Color3.new(1, 1, 1)
    highlight.BackgroundTransparency = 0.85
    highlight.BorderSizePixel = 0
    highlight.ZIndex = 9
    highlight.Parent = bubble
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(1, 0)
    hc.Parent = highlight

    -- logo
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.fromScale(0.72, 0.72)
    logo.Position = UDim2.fromScale(0.5, 0.5)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = config.LogoId
    logo.ZIndex = 10
    logo.Parent = bubble

    -- pulse animation
    task.spawn(function()
        local t = 0
        while bubble.Parent do
            t = t + 0.03
            local pulse = math.sin(t * 1.5) * 0.5 + 0.5
            glow1.BackgroundTransparency = 0.82 + pulse * 0.1
            glow2.BackgroundTransparency = 0.88 + pulse * 0.06
            task.wait(0.03)
        end
    end)

    -- drag state
    local dragging = false
    local dragged = false
    local dragStart, startPos
    local hovered = false

    local function setScale(s)
        local newSize = size * s
        bubble.Size = UDim2.fromOffset(newSize, newSize)
        glow1.Size = UDim2.fromOffset(newSize + 20, newSize + 20)
        glow2.Size = UDim2.fromOffset(newSize + 10, newSize + 10)
    end

    bubble.MouseEnter:Connect(function()
        hovered = true
        if not dragging then
            U.tween(bubble, {
                BackgroundColor3 = Color3.fromRGB(20, 20, 34),
            }, 0.15, "inout")
            -- smooth scale
            task.spawn(function()
                for i = 1, 5 do
                    setScale(1 + i * 0.008)
                    task.wait(0.02)
                end
            end)
        end
    end)
    bubble.MouseLeave:Connect(function()
        hovered = false
        if not dragging then
            U.tween(bubble, {
                BackgroundColor3 = Color3.fromRGB(10, 10, 20),
            }, 0.15, "inout")
            task.spawn(function()
                for i = 5, 1, -1 do
                    setScale(1 + i * 0.008)
                    task.wait(0.02)
                end
                setScale(1)
            end)
        end
    end)

    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragged = false
            dragStart = input.Position
            startPos = container.Position
        end
    end)
    bubble.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then dragged = true end
            container.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    bubble.MouseButton1Click:Connect(function()
        if not dragged and onClick then onClick() end
    end)

    return container
end
