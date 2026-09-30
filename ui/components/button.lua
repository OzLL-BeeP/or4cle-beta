local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, callback)
    local btn = U.new("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.fromOffset(0, y),
        BackgroundColor3 = U.rgb3(config.BgCard),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = parent,
    })
    U.corner(btn, config.RadiusButton)
    U.stroke(btn, U.rgb3(config.BorderSubtle), 1)

    U.label(btn, {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        Text = label,
        TextSize = config.FontLabel,
    })

    U.label(btn, {
        Size = UDim2.fromOffset(20, 1),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "→",
        TextColor3 = U.rgb3(config.TextMuted),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    btn.MouseEnter:Connect(function()
        U.tween(btn, {
            BackgroundColor3 = U.rgb3(config.BgElem),
            BackgroundTransparency = 0,
        }, 0.12, "inout")
    end)
    btn.MouseLeave:Connect(function()
        U.tween(btn, {
            BackgroundColor3 = U.rgb3(config.BgCard),
            BackgroundTransparency = 0.3,
        }, 0.12, "inout")
    end)
    U.ripple(btn, U.rgb3(config.AccentA))
    btn.MouseButton1Click:Connect(callback)
    return btn
end
