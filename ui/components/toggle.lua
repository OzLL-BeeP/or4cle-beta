local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, default, callback)
    local row = Instance.new("Frame")
    row.Name = "Toggle"
    row.Size = UDim2.new(1, 0, 0, 34)
    row.Position = UDim2.fromOffset(0, y)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = row

    -- TEXT LABEL MANUAL
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ToggleLabel"
    textLabel.Size = UDim2.new(1, -110, 1, 0)
    textLabel.Position = UDim2.fromOffset(14, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tostring(label)
    textLabel.TextColor3 = Color3.fromRGB(242, 242, 248)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = row

    -- status
    local state = default or false
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Name = "StatusLabel"
    statusLbl.Size = UDim2.fromOffset(40, 34)
    statusLbl.Position = UDim2.new(1, -100, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = state and "ON" or "OFF"
    statusLbl.TextColor3 = state and Color3.fromRGB(139, 92, 246) or Color3.fromRGB(92, 92, 120)
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextSize = 10
    statusLbl.TextXAlignment = Enum.TextXAlignment.Right
    statusLbl.Parent = row

    -- track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.fromOffset(38, 20)
    track.Position = UDim2.new(1, -52, 0.5, -10)
    track.BackgroundColor3 = state and Color3.fromRGB(139, 92, 246) or Color3.fromRGB(35, 35, 54)
    track.BorderSizePixel = 0
    track.Parent = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = track

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            track.BackgroundColor3 = state and Color3.fromRGB(139, 92, 246) or Color3.fromRGB(35, 35, 54)
            knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3)
            statusLbl.Text = state and "ON" or "OFF"
            statusLbl.TextColor3 = state and Color3.fromRGB(139, 92, 246) or Color3.fromRGB(92, 92, 120)
            if callback then callback(state) end
        end
    end)

    return row, textLabel, statusLbl
end
