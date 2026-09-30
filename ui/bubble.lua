local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, onClick)
    local size = config.BubbleSize or 52
    local posX = config.BubbleX or 80
    local posY = config.BubbleY or 200
    local radius = size * 0.35   -- 35% dari ukuran, sudut soft

    -- glow
    local glow = U.new("Frame", {
        Name = "BubbleGlow",
        Size = UDim2.fromOffset(size + 12, size + 12),
        Position = UDim2.fromOffset(posX - 6, posY - 6),
        BackgroundColor3 = Color3.fromRGB(124, 58, 237),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = parent,
    })
    U.corner(glow, radius + 6)

    -- logo kotak soft-corner
    local logo = U.new("ImageLabel", {
        Name = "BubbleLogo",
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromOffset(posX, posY),
        BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BorderSizePixel = 0,
        Image = config.LogoId,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 2,
        Parent = parent,
    })
    U.corner(logo, radius)

    -- bubble hitbox
    local bubble = U.new("TextButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromOffset(posX, posY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        ZIndex = 5,
        Parent = parent,
    })
    U.corner(bubble, radius)

    -- ring border ungu
    local ring = U.new("Frame", {
        Name = "BubbleRing",
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromOffset(posX, posY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = parent,
    })
    U.corner(ring, radius)
    local ringStroke = U.stroke(ring, Color3.fromRGB(124, 58, 237), 3)
    U.gradient(ringStroke,
        Color3.fromRGB(37, 99, 235),
        Color3.fromRGB(124, 58, 237),
        45)

    -- sync posisi
    local syncing = false
    local function syncAll()
        if syncing then return end
        syncing = true
        local p = bubble.Position
        logo.Position = p
        ring.Position = p
        glow.Position = UDim2.new(p.X.Scale, p.X.Offset - 6, p.Y.Scale, p.Y.Offset - 6)
        syncing = false
    end
    bubble:GetPropertyChangedSignal("Position"):Connect(syncAll)

    -- hover: ubah ukuran + radius
    local function setSize(s)
        local r = s * 0.35
        bubble.Size = UDim2.fromOffset(s, s)
        logo.Size = UDim2.fromOffset(s, s)
        ring.Size = UDim2.fromOffset(s, s)
        glow.Size = UDim2.fromOffset(s + 12, s + 12)
        U.corner(bubble, r)
        U.corner(logo, r)
        U.corner(ring, r)
        U.corner(glow, r + 6)
    end

    -- pulse glow
    task.spawn(function()
        local t = 0
        while bubble.Parent do
            t = t + 0.03
            glow.BackgroundTransparency = 0.78 + math.sin(t * 2) * 0.08
            task.wait(0.03)
        end
    end)

    local dragging, dragged = false, false
    local hovered = false
    bubble.MouseEnter:Connect(function()
        hovered = true
        if not dragging then setSize(size + 4) end
    end)
    bubble.MouseLeave:Connect(function()
        hovered = false
        if not dragging then setSize(size) end
    end)

    local dragStart, startPos
    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragged = false
            dragStart = input.Position
            startPos = bubble.Position
            setSize(size)
        end
    end)
    bubble.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if hovered then setSize(size + 4) end
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then dragged = true end
            bubble.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    bubble.MouseButton1Click:Connect(function()
        if not dragged and onClick then onClick() end
    end)

    bubble.Destroying:Connect(function()
        if logo then logo:Destroy() end
        if ring then ring:Destroy() end
        if glow then glow:Destroy() end
    end)

    return bubble, { logo = logo, ring = ring, glow = glow }
end
