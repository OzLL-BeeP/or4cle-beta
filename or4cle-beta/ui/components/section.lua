local U = require(script.Parent.Parent.Parent.util)

return function(parent, config, y, title)
    local lbl = U.new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.fromOffset(10, y),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(unpack(config.AccentB)),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent,
    })
    return lbl
end
