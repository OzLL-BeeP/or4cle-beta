local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config)
    local sidebar = U.new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 120, 1, -44),
        Position = UDim2.fromOffset(0, 44),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        Parent = parent,
    })
    return sidebar
end
