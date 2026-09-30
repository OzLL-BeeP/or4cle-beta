local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.fromOffset(0, y)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(42, 42, 63)
    s.Thickness = 1
    s.Parent = btn

    -- TEXT LABEL MANUAL
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ButtonLabel"
    textLabel.Size = UDim2.new(1, -40, 1, 0)
    textLabel.Position = UDim2.fromOffset(14, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tostring(label)
    textLabel.TextColor3 = Color3.fromRGB(242, 242, 248)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn

    -- arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(20, 36)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "->"
    arrow.TextColor3 = Color3.fromRGB(92, 92, 120)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 54)
        btn.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
        btn.BackgroundTransparency = 0.3
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn, textLabel
end
