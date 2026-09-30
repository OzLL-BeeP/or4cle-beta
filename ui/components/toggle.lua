local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, default, callback)
    local row = U.new("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.fromOffset(10, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    U.new("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(unpack(config.Text)),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local state = default or false
    local btn = U.new("TextButton", {
        Size = UDim2.fromOffset(40, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = state and Color3.fromRGB(unpack(config.AccentA))
                                 or Color3.fromRGB(unpack(config.BgElem)),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = row,
    })
    U.corner(btn, 10)
    local knob = U.new("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = btn,
    })
    U.corner(knob, 8)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(unpack(config.AccentA))
                                    or Color3.fromRGB(unpack(config.BgElem))
        knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2)
        if callback then callback(state) end
    end)
    return row
end
