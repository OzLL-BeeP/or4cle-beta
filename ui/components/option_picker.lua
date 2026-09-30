local U = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/util.lua"))()

-- opts: { label, options, colors, default }
return function(parent, config, y, opts, callback)
    local options = opts.options or {"A", "B", "C"}
    local colors  = opts.colors or {}
    local current = opts.default or options[1]
    local prefix  = opts.label or ""

    local ROW_H = 32
    local totalH = #options * ROW_H + 8

    -- === TOMBOL ===
    local btn = Instance.new("TextButton")
    btn.Name = "Picker"
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
    label.Text = prefix .. current
    label.TextColor3 = Color3.fromRGB(242, 242, 248)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.fromOffset(20, 36)
    chevron.Position = UDim2.new(1, -30, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text = "v"
    chevron.TextColor3 = Color3.fromRGB(158, 158, 184)
    chevron.Font = Enum.Font.GothamBold
    chevron.TextSize = 12
    chevron.Parent = btn

    -- === DROPDOWN — parent ke parent (di atas window, bukan di dalam btn) ===
    -- Kita parent ke parent dari btn biar bisa ke luar batas tab
    local dropParent = parent.Parent or parent

    -- konversi posisi btn ke drop parent
    local function calcDropPos()
        local btnAbs = btn.AbsolutePosition
        local parentAbs = dropParent.AbsolutePosition
        return UDim2.fromOffset(btnAbs.X - parentAbs.X, btnAbs.Y - parentAbs.Y + 40)
    end

    local drop = Instance.new("Frame")
    drop.Name = "PickerDropdown"
    drop.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)
    drop.Position = calcDropPos()
    drop.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    drop.BackgroundTransparency = 1
    drop.BorderSizePixel = 0
    drop.ClipsDescendants = true
    drop.Visible = false
    drop.ZIndex = 50
    drop.Parent = dropParent

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 8)
    dc.Parent = drop

    local ds = Instance.new("UIStroke")
    ds.Color = Color3.fromRGB(80, 160, 255)
    ds.Thickness = 1.5
    ds.Transparency = 1
    ds.Parent = drop

    -- container untuk row
    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, 0, 0, totalH)
    inner.Position = UDim2.fromOffset(0, 4)
    inner.BackgroundTransparency = 1
    inner.ZIndex = 51
    inner.Parent = drop

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 0)
    layout.Parent = inner

    local refs = {}

    local function updateActive()
        for _, r in ipairs(refs) do
            if r.value == current then
                r.btn.TextColor3 = Color3.fromRGB(80, 200, 255)
                r.line.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
                r.line.BackgroundTransparency = 0.2
                r.btn.Font = Enum.Font.GothamBold
                r.dot.BackgroundTransparency = 0
            else
                r.btn.TextColor3 = Color3.fromRGB(158, 158, 184)
                r.line.BackgroundColor3 = Color3.fromRGB(42, 42, 63)
                r.line.BackgroundTransparency = 0.5
                r.btn.Font = Enum.Font.GothamMedium
                r.dot.BackgroundTransparency = 0.3
            end
        end
        label.Text = prefix .. current
    end

    for i, opt in ipairs(options) do
        local row = Instance.new("Frame")
        row.Name = "Row_" .. tostring(opt)
        row.Size = UDim2.new(1, 0, 0, ROW_H)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.ZIndex = 52
        row.Parent = inner

        local tbtn = Instance.new("TextButton")
        tbtn.Name = "OptBtn"
        tbtn.Size = UDim2.new(1, 0, 1, 0)
        tbtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
        tbtn.BackgroundTransparency = 1
        tbtn.BorderSizePixel = 0
        tbtn.Text = tostring(opt)
        tbtn.TextColor3 = Color3.fromRGB(158, 158, 184)
        tbtn.Font = Enum.Font.GothamMedium
        tbtn.TextSize = 13
        tbtn.TextXAlignment = Enum.TextXAlignment.Left
        tbtn.AutoButtonColor = false
        tbtn.ZIndex = 53
        tbtn.Parent = row
        local tpad = Instance.new("UIPadding")
        tpad.PaddingLeft = UDim.new(0, 14)
        tpad.Parent = tbtn

        -- garis pemisah bawah
        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(42, 42, 63)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.ZIndex = 53
        line.Parent = row

        -- dot warna tier
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.Size = UDim2.fromOffset(8, 8)
        dot.Position = UDim2.new(1, -22, 0.5, -4)
        dot.BackgroundColor3 = colors[opt] or Color3.fromRGB(120, 120, 120)
        dot.BackgroundTransparency = 0.3
        dot.BorderSizePixel = 0
        dot.ZIndex = 53
        dot.Parent = row
        local dc2 = Instance.new("UICorner")
        dc2.CornerRadius = UDim.new(1, 0)
        dc2.Parent = dot

        tbtn.MouseEnter:Connect(function()
            if current ~= opt then
                tbtn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
                tbtn.BackgroundTransparency = 0.2
            end
        end)
        tbtn.MouseLeave:Connect(function()
            tbtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
            tbtn.BackgroundTransparency = 1
        end)
        tbtn.MouseButton1Click:Connect(function()
            current = opt
            updateActive()
            if callback then callback(opt) end
            -- close
            drop.Visible = false
            chevron.Text = "v"
            chevron.TextColor3 = Color3.fromRGB(158, 158, 184)
            bs.Color = Color3.fromRGB(42, 42, 63)
        end)

        table.insert(refs, { value = opt, btn = tbtn, line = line, dot = dot })
    end

    updateActive()

    -- === TOGGLE ===
    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            -- update posisi (kalau window di-drag)
            drop.Position = calcDropPos()
            drop.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)
            drop.Visible = true

            -- fade in
            U.tween(drop, { BackgroundTransparency = 0.05 }, 0.18, "inout")
            U.tween(ds, { Transparency = 0 }, 0.18, "inout")
            U.tween(drop, { Size = UDim2.new(0, btn.AbsoluteSize.X, 0, totalH + 8) }, 0.22, "out")

            chevron.Text = "^"
            chevron.TextColor3 = Color3.fromRGB(80, 200, 255)
            bs.Color = Color3.fromRGB(80, 160, 255)
        else
            U.tween(drop, { BackgroundTransparency = 1 }, 0.15, "inout")
            U.tween(ds, { Transparency = 1 }, 0.15, "inout")
            U.tween(drop, { Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0) }, 0.18, "inout")

            chevron.Text = "v"
            chevron.TextColor3 = Color3.fromRGB(158, 158, 184)
            bs.Color = Color3.fromRGB(42, 42, 63)

            task.delay(0.2, function()
                if not open then drop.Visible = false end
            end)
        end
    end)

    -- update posisi dropdown kalau window di-drag
    if dropParent:FindFirstChildOfClass("UIScale") == nil then
        -- nggak perlu UIScale, cukup listen ke perubahan AbsolutePosition
    end
    task.spawn(function()
        local lastPos = Vector2.new()
        while btn.Parent do
            local pos = btn.AbsolutePosition
            if pos.X ~= lastPos.X or pos.Y ~= lastPos.Y then
                lastPos = pos
                if open then
                    drop.Position = calcDropPos()
                end
            end
            task.wait(0.05)
        end
    end)

    -- cleanup
    btn.Destroying:Connect(function()
        if drop then drop:Destroy() end
    end)

    return btn, label, drop
end
