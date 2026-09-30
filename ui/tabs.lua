local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(sidebar, config, tabNames, onSwitch)
    local buttons = {}
    local refs = {}
    local active

    local function show(name)
        active = name
        for n, b in pairs(buttons) do
            local r = refs[b]
            if r and r.text then
                if n == name then
                    r.text.TextColor3 = Color3.fromRGB(139, 92, 246)
                    if r.underline then
                        r.underline.BackgroundTransparency = 0
                        r.underline.Size = UDim2.new(1, -16, 0, 2)
                    end
                else
                    r.text.TextColor3 = Color3.fromRGB(158, 158, 184)
                    if r.underline then
                        r.underline.BackgroundTransparency = 1
                        r.underline.Size = UDim2.new(0, 0, 0, 2)
                    end
                end
            end
        end
        if onSwitch then onSwitch(name) end
    end

    for i, tabName in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. tabName
        btn.Size = UDim2.new(1, -20, 0, 36)
        btn.Position = UDim2.fromOffset(10, 14 + (i-1) * 44)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = sidebar

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TabLabel"
        textLabel.Size = UDim2.new(1, -16, 1, 0)
        textLabel.Position = UDim2.fromOffset(8, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = string.upper(tabName)
        textLabel.TextColor3 = Color3.fromRGB(158, 158, 184)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = btn

        local underline = Instance.new("Frame")
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 0, 0, 2)
        underline.Position = UDim2.new(0, 8, 1, -6)
        underline.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        underline.BackgroundTransparency = 1
        underline.BorderSizePixel = 0
        underline.Parent = btn

        local uc = Instance.new("UICorner")
        uc.CornerRadius = UDim.new(0, 1)
        uc.Parent = underline

        refs[btn] = { text = textLabel, underline = underline }

        btn.MouseEnter:Connect(function()
            if active ~= tabName then
                textLabel.TextColor3 = Color3.fromRGB(242, 242, 248)
            end
        end)
        btn.MouseLeave:Connect(function()
            if active ~= tabName then
                textLabel.TextColor3 = Color3.fromRGB(158, 158, 184)
            end
        end)
        btn.MouseButton1Click:Connect(function() show(tabName) end)

        buttons[tabName] = btn
    end

    task.defer(function()
        local first = buttons[tabNames[1]]
        if first and refs[first] then
            refs[first].text.TextColor3 = Color3.fromRGB(139, 92, 246)
            refs[first].underline.BackgroundTransparency = 0
            refs[first].underline.Size = UDim2.new(1, -16, 0, 2)
        end
    end)

    return buttons, show, refs
end
