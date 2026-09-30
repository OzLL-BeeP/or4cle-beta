local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config)
    local content = U.new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -52),
        Position = UDim2.fromOffset(140, 52),
        BackgroundColor3 = U.rgb3(config.BgWindow),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = parent,
    })
    local scroll = U.new("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = U.rgb3(config.AccentA),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = content,
    })
    U.pad(scroll, 14, 14, 14, 14)
    return content, scroll
end
