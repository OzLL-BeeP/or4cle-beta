local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

return function(parent, config, y, title)
    local holder = Instance.new("Frame")
    holder.Name = "Section"
    holder.Size = UDim2.new(1, 0, 0, 32)
    holder.Position = UDim2.fromOffset(0, y)
    holder.BackgroundTransparency = 1
    holder.Parent = parent

    -- TEXT LABEL MANUAL
    local label = Instance.new("TextLabel")
    label.Name = "SectionLabel"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.fromOffset(0, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(title)
    label.TextColor3 = Color3.fromRGB(158, 158, 184)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    -- divider
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.fromOffset(0, 22)
    line.BackgroundColor3 = Color3.fromRGB(42, 42, 63)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = holder

    return holder, label
end
