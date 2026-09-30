local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config)
    local window = U.new("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(config.WinW, config.WinH),
        Position = UDim2.new(0.5, -config.WinW/2, 0.5, -config.WinH/2),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgDark)),
        BorderSizePixel = 0,
        Visible = false,
        Parent = parent,
    })
    U.corner(window, 12)
    U.stroke(window, Color3.fromRGB(unpack(config.AccentB)), 1.5)

    local topBar = U.new("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        Parent = window,
    })
    U.corner(topBar, 12)
    U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        Parent = topBar,
    })

    U.new("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1,
        Text = "OR4CLE  •  Ride A Pet",
        TextColor3 = Color3.fromRGB(unpack(config.Text)),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })

    local closeBtn = U.new("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -36, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgElem)),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(unpack(config.TextDim)),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        Parent = topBar,
    })
    U.corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        window.Visible = false
    end)

    return window, topBar
end
