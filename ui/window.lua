local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config)
    local window = U.new("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(config.WinW, config.WinH),
        Position = UDim2.new(0.5, -config.WinW / 2, 0.5, -config.WinH / 2),
        BackgroundColor3 = U.rgb3(config.BgWindow),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = parent,
    })
    U.corner(window, config.RadiusWindow)

    -- outer glow
    local outerGlow = U.new("Frame", {
        Name = "OuterGlow",
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = U.rgb3(config.AccentA),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = -1,
        Parent = window,
    })
    U.corner(outerGlow, config.RadiusWindow + 4)

    -- border
    local stroke = U.stroke(window, U.rgb3(config.AccentA), 1.5)
    U.gradientMulti(stroke, {
        U.rgb3(config.AccentA),
        U.rgb3(config.AccentB),
        U.rgb3(config.AccentA),
    }, 45)

    -- top bar
    local topBar = U.new("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, config.TopBarH),
        BackgroundColor3 = U.rgb3(config.BgPanel),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = window,
    })
    U.corner(topBar, config.RadiusWindow)

    -- fix bottom corner
    local topBarFix = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = U.rgb3(config.BgPanel),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = topBar,
    })

    -- accent line
    local accent = U.new("Frame", {
        Name = "Accent",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = topBar,
    })
    U.gradientMulti(accent, {
        U.rgb3(config.AccentA),
        U.rgb3(config.AccentB),
    }, 0)

    -- logo
    U.new("ImageLabel", {
        Name = "Logo",
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.fromOffset(16, 11),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        Parent = topBar,
    })

    -- title
    U.title(topBar, {
        Size = UDim2.new(0, 140, 0, 18),
        Position = UDim2.fromOffset(56, 10),
        Text = config.ProductName,
        TextSize = config.FontTitle,
    })

    -- subtitle
    U.subtitle(topBar, {
        Size = UDim2.new(0, 200, 0, 14),
        Position = UDim2.fromOffset(56, 28),
        Text = config.ProductSub .. "  •  " .. config.Version,
        TextColor3 = U.rgb3(config.AccentB),
        Font = Enum.Font.GothamBold,
        TextSize = config.FontTiny,
    })

    -- search box
    local searchBox = U.new("Frame", {
        Name = "SearchBox",
        Size = UDim2.fromOffset(150, 30),
        Position = UDim2.new(1, -260, 0.5, -15),
        BackgroundColor3 = U.rgb3(config.BgElem),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    U.corner(searchBox, 8)
    U.stroke(searchBox, U.rgb3(config.BorderSubtle), 1)

    U.label(searchBox, {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(10, 5),
        Text = "⌕",
        TextColor3 = U.rgb3(config.TextMuted),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local searchInput = U.new("TextBox", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(32, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "cari...",
        PlaceholderColor3 = U.rgb3(config.TextMuted),
        TextColor3 = U.rgb3(config.TextPrimary),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = searchBox,
    })

    -- fps counter
    local fpsBox = U.new("Frame", {
        Name = "FPSBox",
        Size = UDim2.fromOffset(44, 30),
        Position = UDim2.new(1, -104, 0.5, -15),
        BackgroundColor3 = U.rgb3(config.BgElem),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    U.corner(fpsBox, 8)
    U.stroke(fpsBox, U.rgb3(config.BorderSubtle), 1)

    local fpsLabel = U.value(fpsBox, {
        Size = UDim2.fromScale(1, 1),
        Text = "60",
        TextXAlignment = Enum.TextXAlignment.Center,
        Font = Enum.Font.Code,
        TextSize = 12,
    })

    task.spawn(function()
        local frames, last = 0, tick()
        game:GetService("RunService").RenderStepped:Connect(function()
            frames = frames + 1
            if tick() - last >= 1 then
                fpsLabel.Text = tostring(frames)
                fpsLabel.TextColor3 = frames > 50 and U.rgb3(config.Success)
                    or frames > 30 and U.rgb3(config.Warning)
                    or U.rgb3(config.Error)
                frames = 0
                last = tick()
            end
        end)
    end)

    -- close button
    local closeBtn = U.new("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.fromOffset(32, 32),
        Position = UDim2.new(1, -44, 0.5, -16),
        BackgroundColor3 = U.rgb3(config.BgElem),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = U.rgb3(config.TextSecondary),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        AutoButtonColor = false,
        Parent = topBar,
    })
    U.corner(closeBtn, 8)

    closeBtn.MouseEnter:Connect(function()
        U.tween(closeBtn, {
            BackgroundColor3 = U.rgb3(config.Error),
            TextColor3 = Color3.new(1, 1, 1),
        }, 0.15, "inout")
    end)
    closeBtn.MouseLeave:Connect(function()
        U.tween(closeBtn, {
            BackgroundColor3 = U.rgb3(config.BgElem),
            TextColor3 = U.rgb3(config.TextSecondary),
        }, 0.15, "inout")
    end)
    closeBtn.MouseButton1Click:Connect(function()
        window.Visible = false
    end)

    return window, topBar, searchInput
end
