local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

-- opts: { min, max, default, suffix }
return function(parent, config, y, label, opts, callback)
    local minV = opts.min or 16
    local maxV = opts.max or 100
    local suffix = opts.suffix or ""
    local current = opts.default or 16

    -- row container
    local row = Instance.new("Frame")
    row.Name = "SpeedBubble"
    row.Size = UDim2.new(1, 0, 0, 72)
    row.Position = UDim2.fromOffset(0, y)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    -- label kiri
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
    nameLbl.Position = UDim2.fromOffset(14, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextColor3 = Color3.fromRGB(242, 242, 248)
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    -- bubble container di kanan
    local bubbleWrap = Instance.new("Frame")
    bubbleWrap.Name = "BubbleWrap"
    bubbleWrap.Size = UDim2.fromOffset(56, 56)
    bubbleWrap.Position = UDim2.new(1, -70, 0.5, -28)
    bubbleWrap.BackgroundTransparency = 1
    bubbleWrap.Parent = row

    -- bubble bulat
    local bubble = Instance.new("TextButton")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.fromScale(1, 1)
    bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    bubble.BorderSizePixel = 0
    bubble.Text = ""
    bubble.AutoButtonColor = false
    bubble.Active = true
    bubble.Parent = bubbleWrap
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bubble

    -- border gradient
    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(139, 92, 246)
    bs.Thickness = 2
    bs.Parent = bubble
    local bg = Instance.new("UIGradient")
    bg.Color = ColorSequence.new(
        Color3.fromRGB(59, 130, 246),
        Color3.fromRGB(139, 92, 246)
    )
    bg.Rotation = 45
    bg.Parent = bs

    -- progress ring (background)
    local ringBg = Instance.new("Frame")
    ringBg.Name = "RingBg"
    ringBg.Size = UDim2.fromScale(1, 1)
    ringBg.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
    ringBg.BackgroundTransparency = 0.7
    ringBg.BorderSizePixel = 0
    ringBg.ZIndex = 0
    ringBg.Parent = bubble
    local rbc = Instance.new("UICorner")
    rbc.CornerRadius = UDim.new(1, 0)
    rbc.Parent = ringBg

    -- angka
    local valLbl = Instance.new("TextLabel")
    valLbl.Name = "ValueLbl"
    valLbl.Size = UDim2.fromScale(1, 1)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(current)
    valLbl.TextColor3 = Color3.fromRGB(242, 242, 248)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 16
    valLbl.ZIndex = 3
    valLbl.Parent = bubble

    -- suffix kecil
    local suffixLbl = Instance.new("TextLabel")
    suffixLbl.Name = "SuffixLbl"
    suffixLbl.Size = UDim2.new(1, 0, 0, 10)
    suffixLbl.Position = UDim2.new(0, 0, 1, -14)
    suffixLbl.BackgroundTransparency = 1
    suffixLbl.Text = suffix
    suffixLbl.TextColor3 = Color3.fromRGB(158, 158, 184)
    suffixLbl.Font = Enum.Font.GothamMedium
    suffixLbl.TextSize = 8
    suffixLbl.ZIndex = 3
    suffixLbl.Parent = bubble

    local dragging = false

    local function setValue(v)
        v = math.clamp(math.floor(v + 0.5), minV, maxV)
        current = v
        valLbl.Text = tostring(v)
        if callback then callback(v) end
    end

    local function updateFromX(absX)
        local wrapAbs = bubbleWrap.AbsolutePosition.X
        local wrapW = bubbleWrap.AbsoluteSize.X
        local ratio = math.clamp((absX - wrapAbs) / wrapW, 0, 1)
        setValue(minV + ratio * (maxV - minV))
    end

    bubble.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(i.Position.X)
        end
    end)
    bubble.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(i.Position.X)
        end
    end)

    -- hover effect
    bubble.MouseEnter:Connect(function()
        U.tween(bubble, { BackgroundColor3 = Color3.fromRGB(30, 30, 48) }, 0.12, "inout")
    end)
    bubble.MouseLeave:Connect(function()
        U.tween(bubble, { BackgroundColor3 = Color3.fromRGB(20, 20, 32) }, 0.12, "inout")
    end)

    return row, setValue
end
