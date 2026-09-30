local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config)
    local content = U.new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -120, 1, -44),
        Position = UDim2.fromOffset(120, 44),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgDark)),
        BorderSizePixel = 0,
        Parent = parent,
    })
    return content
end
