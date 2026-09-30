local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, callback)
    local btn = U.new("TextButton", {
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.fromOffset(10, y),
        BackgroundColor3 = Color3.fromRGB(unpack(config.AccentA)),
        BorderSizePixel = 0,
        Text = label,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = parent,
    })
    U.corner(btn, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
