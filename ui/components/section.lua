local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, title)
    local holder = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    U.sectionTitle(holder, {
        Size = UDim2.new(1, 0, 0, 20),
        Text = title,
        TextColor3 = U.rgb3(config.TextDim),
    })
    local line = U.divider(holder)
    line.Position = UDim2.fromOffset(0, 22)
    return holder
end
