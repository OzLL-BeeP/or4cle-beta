local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(sidebar, config, tabNames, onSwitch)
    local buttons = {}
    local active

    local function show(name)
        active = name
        for n, b in pairs(buttons) do
            if b.TextLabel then
                if n == name then
                    U.tween(b.TextLabel, { TextColor3 = U.rgb3(config.AccentA) }, 0.15, "inout")
                    if b.Underline then
                        U.tween(b.Underline, {
                            BackgroundTransparency = 0,
                            Size = UDim2.new(1, -16, 0, 2),
                        }, 0.15, "inout")
                    end
                else
                    U.tween(b.TextLabel, { TextColor3 = U.rgb3(config.TextDim) }, 0.15, "inout")
                    if b.Underline then
                        U.tween(b.Underline, {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 0, 0, 2),
                        }, 0.15, "inout")
                    end
                end
            end
        end
        if onSwitch then onSwitch(name) end
    end

    for i, tabName in ipairs(tabNames) do
        local btn = U.new("TextButton", {
            Size = UDim2.new(1, -20, 0, 36),
            Position = UDim2.fromOffset(10, 14 + (i-1) * 44),
            BackgroundColor3 = U.rgb3(config.BgPanel),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = sidebar,
        })
        U.corner(btn, 6)

        local textLabel = U.label(btn, {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            Text = string.upper(tabName),
            TextColor3 = U.rgb3(config.TextDim),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
        })
        btn.TextLabel = textLabel

        local underline = U.new("Frame", {
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 8, 1, -6),
            BackgroundColor3 = U.rgb3(config.AccentA),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = btn,
        })
        U.corner(underline, 1)
        btn.Underline = underline

        btn.MouseEnter:Connect(function()
            if active ~= tabName and btn.TextLabel then
                U.tween(btn.TextLabel, { TextColor3 = U.rgb3(config.Text) }, 0.12, "inout")
            end
        end)
        btn.MouseLeave:Connect(function()
            if active ~= tabName and btn.TextLabel then
                U.tween(btn.TextLabel, { TextColor3 = U.rgb3(config.TextDim) }, 0.12, "inout")
            end
        end)
        btn.MouseButton1Click:Connect(function() show(tabName) end)

        buttons[tabName] = btn
    end

    task.defer(function()
        local first = buttons[tabNames[1]]
        if first and first.TextLabel then
            first.TextLabel.TextColor3 = U.rgb3(config.AccentA)
            if first.Underline then
                first.Underline.BackgroundTransparency = 0
                first.Underline.Size = UDim2.new(1, -16, 0, 2)
            end
        end
    end)

    return buttons, show
end
