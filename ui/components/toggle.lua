local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, label, default, callback)
    local row = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.fromOffset(0, y),
        BackgroundColor3 = U.rgb3(config.BgCard),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent,
    })
    U.corner(row, config.RadiusButton)

    U.label(row, {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        Text = label,
        TextSize = config.FontLabel,
    })

    local state = default or false
    local statusLbl = U.label(row, {
        Size = UDim2.fromOffset(50, 1),
        Position = UDim2.new(1, -100, 0, 0),
        Text = state and "ON" or "OFF",
        TextColor3 = state and U.rgb3(config.AccentA) or U.rgb3(config.TextMuted),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local track = U.new("Frame", {
        Size = UDim2.fromOffset(38, 20),
        Position = UDim2.new(1, -52, 0.5, -10),
        BackgroundColor3 = state and U.rgb3(config.AccentA) or U.rgb3(config.BgElem),
        BorderSizePixel = 0,
        Parent = row,
    })
    U.corner(track, 10)

    local knob = U.new("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = track,
    })
    U.corner(knob, 7)

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            U.tween(track, {
                BackgroundColor3 = state and U.rgb3(config.AccentA) or U.rgb3(config.BgElem),
            }, 0.18, "inout")
            U.tween(knob, {
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3),
            }, 0.22, "spring")
            U.tween(statusLbl, {
                TextColor3 = state and U.rgb3(config.AccentA) or U.rgb3(config.TextMuted),
            }, 0.15, "inout")
            statusLbl.Text = state and "ON" or "OFF"
            if callback then callback(state) end
        end
    end)
    row.MouseEnter:Connect(function()
        U.tween(row, { BackgroundTransparency = 0 }, 0.12, "inout")
    end)
    row.MouseLeave:Connect(function()
        U.tween(row, { BackgroundTransparency = 0.3 }, 0.12, "inout")
    end)
    return row
end
