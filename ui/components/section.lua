local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, title)
    local holder = U.new("Frame", {
        Name = "Section",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local label = U.sectionTitle(holder, {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(0, 0),
        Text = title,
        TextColor3 = U.rgb3(config.TextDim),
    })

    local line = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.fromOffset(0, 22),
        BackgroundColor3 = U.rgb3(config.BorderSubtle),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = holder,
    })

    return holder, label
end
