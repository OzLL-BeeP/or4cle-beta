local U = require(script.Parent.Parent.util)

return function(sidebar, config, tabNames, onSwitch)
    local buttons = {}
    local active
    local function show(name)
        active = name
        for n, b in pairs(buttons) do
            if n == name then
                b.BackgroundColor3 = Color3.fromRGB(unpack(config.AccentA))
                b.TextColor3 = Color3.fromRGB(unpack(config.Text))
            else
                b.BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel))
                b.TextColor3 = Color3.fromRGB(unpack(config.TextDim))
            end
        end
        if onSwitch then onSwitch(name) end
    end
    for i, tabName in ipairs(tabNames) do
        local btn = U.new("TextButton", {
            Size = UDim2.new(1, -16, 0, 32),
            Position = UDim2.fromOffset(8, 8 + (i-1) * 38),
            BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = Color3.fromRGB(unpack(config.TextDim)),
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = sidebar,
        })
        U.corner(btn, 6)
        btn.MouseButton1Click:Connect(function() show(tabName) end)
        buttons[tabName] = btn
    end
    show(tabNames[1])
    return buttons, show
end
