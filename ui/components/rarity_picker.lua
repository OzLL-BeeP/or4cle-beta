local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

local TIERS = {"Common", "Rare", "Epic", "Legend", "Mythic", "Divine", "Ethereal"}
local TIER_COLOR = {
    Common   = Color3.fromRGB(180, 180, 180),
    Rare     = Color3.fromRGB(80, 160, 255),
    Epic     = Color3.fromRGB(180, 100, 255),
    Legend   = Color3.fromRGB(255, 150, 50),
    Mythic   = Color3.fromRGB(255, 80, 80),
    Divine   = Color3.fromRGB(255, 215, 0),
    Ethereal = Color3.fromRGB(255, 100, 255),
}

return function(parent, config, y, defaultTier, callback)
    local current = defaultTier or "Common"

    -- === TOMBOL UTAMA (kayak button biasa) ===
    local btn = Instance.new("TextButton")
    btn.Name = "RarityBtn"
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.fromOffset(0, y)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    btn.Parent = parent

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn

    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(42, 42, 63)
    bs.Thickness = 1
    bs.Parent = btn

    local label = Instance.new("TextLabel")
    label.Name = "PickerLabel"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.fromOffset(14, 0)
    label.BackgroundTransparency = 1
    label.Text = "Min Tier: " .. current
    label.TextColor3 = Color3.fromRGB(242, 242, 248)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    -- panah chevron
    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.fromOffset(20, 36)
    chevron.Position = UDim2.new(1, -30, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text = "v"
    chevron.TextColor3 = Color3.fromRGB(158, 158, 184)
    chevron.Font = Enum.Font.GothamBold
    chevron.TextSize = 12
    chevron.Parent = btn

    -- === DROPDOWN (muncul dari bawah tombol) ===
    local dropH = #TIERS * 34 + 8

    local drop = Instance.new("Frame")
    drop.Name = "RarityDropdown"
    drop.Size = UDim2.new(1, 0, 0, 0)   -- start 0, animasi ke dropH
    drop.Position = UDim2.fromOffset(0, 40)
    drop.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    drop.BorderSizePixel = 0
    drop.ClipsDescendants = true
    drop.Visible = false
    drop.ZIndex = 10
    drop.Parent = btn

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 8)
    dc.Parent = drop

    local ds = Instance.new("UIStroke")
    ds.Color = Color3.fromRGB(80, 160, 255)   -- cyan
    ds.Thickness = 1.5
    ds.Parent = drop

    -- scroll internal
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -8)
    scroll.Position = UDim2.fromOffset(4, 4)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 160, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #TIERS * 34 + 4)
    scroll.ZIndex = 11
    scroll.Parent = drop

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 0)
    layout.Parent = scroll

    local refs = {}

    local function updateActive()
        for _, r in ipairs(refs) do
            if r.tier == current then
                r.btn.TextColor3 = Color3.fromRGB(80, 200, 255)   -- cyan
                r.line.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
                r.line.BackgroundTransparency = 0
                r.btn.Font = Enum.Font.GothamBold
            else
                r.btn.TextColor3 = Color3.fromRGB(158, 158, 184)
                r.line.BackgroundColor3 = Color3.fromRGB(42, 42, 63)
                r.line.BackgroundTransparency = 0.5
                r.btn.Font = Enum.Font.GothamMedium
            end
        end
        label.Text = "Min Tier: " .. current
    end

    for i, tier in ipairs(TIERS) do
        -- row
        local row = Instance.new("Frame")
        row.Name = "Row_" .. tier
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.ZIndex = 11
        row.Parent = scroll

        local tbtn = Instance.new("TextButton")
        tbtn.Name = "TierBtn"
        tbtn.Size = UDim2.new(1, 0, 1, 0)
        tbtn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
        tbtn.BackgroundTransparency = 1
        tbtn.BorderSizePixel = 0
        tbtn.Text = tier
        tbtn.TextColor3 = Color3.fromRGB(158, 158, 184)
        tbtn.Font = Enum.Font.GothamMedium
        tbtn.TextSize = 13
        tbtn.TextXAlignment = Enum.TextXAlignment.Left
        tbtn.AutoButtonColor = false
        tbtn.ZIndex = 12
        tbtn.Parent = row
        local tpad = Instance.new("UIPadding")
        tpad.PaddingLeft = UDim.new(0, 12)
        tpad.Parent = tbtn

        -- garis pemisah bawah
        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Size = UDim2.new(1, -12, 0, 1)
        line.Position = UDim2.new(0, 6, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(42, 42, 63)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.ZIndex = 12
        line.Parent = row

        -- dot warna tier
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.Size = UDim2.fromOffset(8, 8)
        dot.Position = UDim2.new(1, -20, 0.5, -4)
        dot.BackgroundColor3 = TIER_COLOR[tier]
        dot.BorderSizePixel = 0
        dot.ZIndex = 12
        dot.Parent = row
        local dcorner = Instance.new("UICorner")
        dcorner.CornerRadius = UDim.new(1, 0)
        dcorner.Parent = dot

        tbtn.MouseEnter:Connect(function()
            if current ~= tier then
                tbtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                tbtn.BackgroundTransparency = 0.3
            end
        end)
        tbtn.MouseLeave:Connect(function()
            tbtn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
            tbtn.BackgroundTransparency = 1
        end)
        tbtn.MouseButton1Click:Connect(function()
            current = tier
            updateActive()
            if callback then callback(tier) end
            -- close dropdown
            U.tween(drop, { Size = UDim2.new(1, 0, 0, 0) }, 0.15, "inout")
            task.wait(0.16)
            drop.Visible = false
        end)

        table.insert(refs, { tier = tier, btn = tbtn, line = line, dot = dot })
    end

    updateActive()

    -- toggle dropdown
    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            drop.Visible = true
            U.tween(drop, { Size = UDim2.new(1, 0, 0, dropH) }, 0.22, "out")
            chevron.Text = "^"
            chevron.TextColor3 = Color3.fromRGB(80, 200, 255)
        else
            U.tween(drop, { Size = UDim2.new(1, 0, 0, 0) }, 0.18, "inout")
            chevron.Text = "v"
            chevron.TextColor3 = Color3.fromRGB(158, 158, 184)
            task.wait(0.2)
            if not open then drop.Visible = false end
        end
    end)

    return btn, label, drop
end
