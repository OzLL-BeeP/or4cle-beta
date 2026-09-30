local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()
local Players = game:GetService("Players")

return function(parent, config)
    local sidebar = U.new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -52),
        Position = UDim2.fromOffset(0, 52),
        BackgroundColor3 = U.rgb3(config.BgPanel),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent,
    })

    -- user info di bawah
    local userBox = U.new("Frame", {
        Name = "UserBox",
        Size = UDim2.new(1, -16, 0, 52),
        Position = UDim2.new(0, 8, 1, -60),
        BackgroundColor3 = U.rgb3(config.BgCard),
        BorderSizePixel = 0,
        Parent = sidebar,
    })
    U.corner(userBox, 10)
    U.stroke(userBox, U.rgb3(config.BorderSubtle), 1)

    local lp = Players.LocalPlayer

    local avatar = U.new("ImageLabel", {
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.fromOffset(8, 8),
        BackgroundColor3 = U.rgb3(config.BgElem),
        BorderSizePixel = 0,
        Image = "",
        Parent = userBox,
    })
    U.corner(avatar, 8)

    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(
                lp.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and url then avatar.Image = url end
    end)

    U.label(userBox, {
        Size = UDim2.new(1, -52, 0, 16),
        Position = UDim2.fromOffset(50, 10),
        Text = lp.DisplayName or lp.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    U.label(userBox, {
        Size = UDim2.new(1, -52, 0, 14),
        Position = UDim2.fromOffset(50, 28),
        Text = "@" .. lp.Name,
        TextColor3 = U.rgb3(config.TextMuted),
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local dot = U.new("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(1, -14, 0, 12),
        BackgroundColor3 = U.rgb3(config.Success),
        BorderSizePixel = 0,
        Parent = userBox,
    })
    U.corner(dot, 4)

    return sidebar
end
