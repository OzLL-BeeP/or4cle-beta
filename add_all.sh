#!/data/data/com.termux/files/usr/bin/bash
set -e

# ============ config.lua ============
cat > config.lua << 'EOF'
return {
    AccentA = {59, 130, 246},
    AccentB = {139, 92, 246},
    BgDark  = {12, 12, 20},
    BgPanel = {20, 20, 32},
    BgElem  = {28, 28, 44},
    Text    = {235, 235, 245},
    TextDim = {140, 140, 165},
    LogoId  = "rbxassetid://114651091062453",
    BubbleSize = 56,
    BubbleX = 80,
    BubbleY = 200,
    WinW = 500,
    WinH = 360,
}
EOF

# ============ util.lua ============
cat > util.lua << 'EOF'
local U = {}

function U.new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

function U.corner(parent, radius)
    return U.new("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

function U.gradient(parent, a, b, rotation)
    return U.new("UIGradient", {
        Color = ColorSequence.new(a, b),
        Rotation = rotation or 0,
        Parent = parent
    })
end

function U.stroke(parent, color, thickness)
    return U.new("UIStroke", {
        Color = color, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

return U
EOF

# ============ root.lua ============
cat > root.lua << 'EOF'
local CoreGui = game:GetService("CoreGui")

return function()
    if CoreGui:FindFirstChild("OR4CLE") then
        CoreGui.OR4CLE:Destroy()
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    return gui
end
EOF

# ============ ui/bubble.lua ============
cat > ui/bubble.lua << 'EOF'
local U = require(script.Parent.Parent.util)

return function(parent, config, onClick)
    local bubble = U.new("ImageButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(config.BubbleSize, config.BubbleSize),
        Position = UDim2.fromOffset(config.BubbleX, config.BubbleY),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = parent,
    })
    U.corner(bubble, config.BubbleSize)
    U.stroke(bubble, Color3.fromRGB(unpack(config.AccentB)), 2)

    local inner = U.new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Parent = bubble,
    })
    U.corner(inner, config.BubbleSize)
    U.gradient(inner,
        Color3.fromRGB(unpack(config.AccentA)),
        Color3.fromRGB(unpack(config.AccentB)), 45)

    U.new("ImageLabel", {
        Size = UDim2.fromScale(0.65, 0.65),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.LogoId,
        Parent = bubble,
    })

    if onClick then
        bubble.MouseButton1Click:Connect(onClick)
    end
    return bubble
end
EOF

# ============ ui/window.lua ============
cat > ui/window.lua << 'EOF'
local U = require(script.Parent.Parent.util)

return function(parent, config)
    local window = U.new("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(config.WinW, config.WinH),
        Position = UDim2.new(0.5, -config.WinW/2, 0.5, -config.WinH/2),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgDark)),
        BorderSizePixel = 0,
        Visible = false,
        Parent = parent,
    })
    U.corner(window, 12)
    U.stroke(window, Color3.fromRGB(unpack(config.AccentB)), 1.5)

    local topBar = U.new("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        Parent = window,
    })
    U.corner(topBar, 12)
    U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
        BorderSizePixel = 0,
        Parent = topBar,
    })

    U.new("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1,
        Text = "OR4CLE  •  Ride A Pet",
        TextColor3 = Color3.fromRGB(unpack(config.Text)),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })

    local closeBtn = U.new("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -36, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(unpack(config.BgElem)),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(unpack(config.TextDim)),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        Parent = topBar,
    })
    U.corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        window.Visible = false
    end)

    return window, topBar
end
EOF

# ============ ui/sidebar.lua ============
cat > ui/sidebar.lua << 'EOF'
local U = require(script.Parent.Parent.util)

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
EOF

# ============ ui/content.lua ============
cat > ui/content.lua << 'EOF'
local U = require(script.Parent.Parent.util)

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
EOF

# ============ ui/tabs.lua ============
cat > ui/tabs.lua << 'EOF'
local U = require(script.Parent.Parent.util)

return function(sidebar, config, tabNames, onSwitch)
    local buttons = {}
    local active
    local function show(name)
        active = name
        for n, b in pairs(buttons) do
            if n == name then
                b.BackgroundColor3 = Color3.fromRGB(unpack(config.AccentA))
                b.TextColor3 = Color3.fromRGB(unpack(config.Text))
            else
                b.BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel))
                b.TextColor3 = Color3.fromRGB(unpack(config.TextDim))
            end
        end
        if onSwitch then onSwitch(name) end
    end
    for i, tabName in ipairs(tabNames) do
        local btn = U.new("TextButton", {
            Size = UDim2.new(1, -16, 0, 32),
            Position = UDim2.fromOffset(8, 8 + (i-1) * 38),
            BackgroundColor3 = Color3.fromRGB(unpack(config.BgPanel)),
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = Color3.fromRGB(unpack(config.TextDim)),
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = sidebar,
        })
        U.corner(btn, 6)
        btn.MouseButton1Click:Connect(function() show(tabName) end)
        buttons[tabName] = btn
    end
    show(tabNames[1])
    return buttons, show
end
EOF

# ============ ui/components/toggle.lua ============
cat > ui/components/toggle.lua << 'EOF'
local U = require(script.Parent.Parent.Parent.util)

return function(parent, config, y, label, default, callback)
    local row = U.new("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.fromOffset(10, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    U.new("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(unpack(config.Text)),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local state = default or false
    local btn = U.new("TextButton", {
        Size = UDim2.fromOffset(40, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = state and Color3.fromRGB(unpack(config.AccentA))
                                 or Color3.fromRGB(unpack(config.BgElem)),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = row,
    })
    U.corner(btn, 10)
    local knob = U.new("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = btn,
    })
    U.corner(knob, 8)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(unpack(config.AccentA))
                                    or Color3.fromRGB(unpack(config.BgElem))
        knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2)
        if callback then callback(state) end
    end)
    return row
end
EOF

# ============ ui/components/button.lua ============
cat > ui/components/button.lua << 'EOF'
local U = require(script.Parent.Parent.Parent.util)

return function(parent, config, y, label, callback)
    local btn = U.new("TextButton", {
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.fromOffset(10, y),
        BackgroundColor3 = Color3.fromRGB(unpack(config.AccentA)),
        BorderSizePixel = 0,
        Text = label,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = parent,
    })
    U.corner(btn, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
EOF

# ============ ui/components/section.lua ============
cat > ui/components/section.lua << 'EOF'
local U = require(script.Parent.Parent.Parent.util)

return function(parent, config, y, title)
    local lbl = U.new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.fromOffset(10, y),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(unpack(config.AccentB)),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent,
    })
    return lbl
end
EOF

# ============ ui/components/slider.lua, checkbox.lua, dropdown.lua ============
cat > ui/components/slider.lua << 'EOF'
-- TODO: implement slider
return function() end
EOF

cat > ui/components/checkbox.lua << 'EOF'
-- TODO: implement checkbox
return function() end
EOF

cat > ui/components/dropdown.lua << 'EOF'
-- TODO: implement dropdown
return function() end
EOF

# ============ modules/esp.lua ============
cat > modules/esp.lua << 'EOF'
local M = {}
local cache = {}

local TIER_COLOR = {
    Ethereal = Color3.fromRGB(255, 100, 255),
    Divine   = Color3.fromRGB(255, 215, 0),
    Mythic   = Color3.fromRGB(255, 80, 80),
    Legend   = Color3.fromRGB(255, 150, 50),
    Epic     = Color3.fromRGB(180, 100, 255),
    Rare     = Color3.fromRGB(80, 160, 255),
    Common   = Color3.fromRGB(180, 180, 180),
    Unknown  = Color3.fromRGB(120, 120, 120),
}

function M.tierOf(name)
    local n = name:lower()
    if n:find("volcanic") or n:find("cherub") or n:find("solaris") or n:find("blackhole") then return "Ethereal" end
    if n:find("bloom") or n:find("galaxy") or n:find("aurora") then return "Divine" end
    if n:find("tidal") or n:find("soul") or n:find("sinister") or n:find("flaming") or n:find("dominus")
    or n:find("asteroid") or n:find("skull") or n:find("crystal") or n:find("diamond") then return "Mythic" end
    if n:find("golden") or n:find("glass") then return "Legend" end
    if n:find("ice") or n:find("slime") or n:find("flower") or n:find("mushroom") then return "Epic" end
    if n:find("leaf") or n:find("stone") or n:find("easter") or n:find("cracked") then return "Rare" end
    if n:find("brown") or n:find("white") then return "Common" end
    return "Unknown"
end

function M.scan(parent)
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return end
    for _, egg in ipairs(re:GetChildren()) do
        if not cache[egg] or not cache[egg].Parent then
            local tier = M.tierOf(egg.Name)
            local hl = Instance.new("Highlight")
            hl.FillColor = TIER_COLOR[tier]
            hl.OutlineColor = TIER_COLOR[tier]
            hl.FillTransparency = 0.5
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = egg
            hl.Parent = parent
            cache[egg] = hl
        end
    end
end

function M.clear()
    for egg, hl in pairs(cache) do
        if hl then hl:Destroy() end
    end
    cache = {}
end

return M
EOF

# ============ modules/teleport.lua ============
cat > modules/teleport.lua << 'EOF'
local M = {}
local LP = game:GetService("Players").LocalPlayer

function M.tp(cf)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

function M.nearestEgg()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, minD = nil, math.huge
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return nil end
    for _, egg in ipairs(re:GetChildren()) do
        local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
        if base then
            local d = (base.Position - hrp.Position).Magnitude
            if d < minD then closest, minD = base, d end
        end
    end
    return closest
end

function M.tpNearest()
    local target = M.nearestEgg()
    if target then
        M.tp(target.CFrame + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

return M
EOF

# ============ modules/lava.lua ============
cat > modules/lava.lua << 'EOF'
local M = {}
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

M.POINTS = {
    Entrance = CFrame.new(-4939.8, 41284.7, -3680.0),
    Validate = CFrame.new(-4966.7, 41282.8, -3656.4),
    EggSpawn = CFrame.new(-5329.4, 40910.2, -3580.9),
    Lair     = CFrame.new(-5336.6, 40925.1, -3557.0),
    Summit   = CFrame.new(-5102.8, 41405.6, -3489.1),
    Ranch    = CFrame.new(0, 40313, 900),
}

local noclip, conn

function M.setNoclip(on)
    noclip = on
    if on and not conn then
        conn = RunService.Stepped:Connect(function()
            if not noclip then return end
            local char = LP.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    elseif not on and conn then
        conn:Disconnect(); conn = nil
    end
end

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function findVolcanic()
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return nil end
    for _, o in ipairs(re:GetChildren()) do
        if o.Name:lower():find("volcanic") then return o end
    end
    return nil
end

local function firePickup(egg)
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            if fireproximityprompt then fireproximityprompt(d) end
            return true
        end
    end
    return false
end

function M.grab()
    tp(M.POINTS.Entrance); task.wait(0.3)
    tp(M.POINTS.Validate); task.wait(0.3)
    M.setNoclip(true)
    tp(M.POINTS.Lair); task.wait(0.5)
    local egg = findVolcanic()
    if not egg then M.setNoclip(false); return false, "Egg belum spawn" end
    local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
    if base then tp(base.CFrame + Vector3.new(0, 3, 0)); task.wait(0.3) end
    if not firePickup(egg) then M.setNoclip(false); return false, "Prompt gak ketemu" end
    task.wait(0.5)
    tp(M.POINTS.Entrance); task.wait(0.2)
    M.setNoclip(false)
    tp(M.POINTS.Ranch)
    return true, "Sukses"
end

return M
EOF

# ============ modules/tracker.lua ============
cat > modules/tracker.lua << 'EOF'
-- TODO: egg tracker list
return {}
EOF

# ============ modules/autofarm.lua ============
cat > modules/autofarm.lua << 'EOF'
-- TODO: autofarm
return {}
EOF

# ============ loader.lua ============
cat > loader.lua << 'EOF'
-- OR4CLE entry point
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local config = require(script.Parent.config)
local U = require(script.Parent.util)
local makeRoot = require(script.Parent.root)
local makeBubble = require(script.Parent.ui.bubble)
local makeWindow = require(script.Parent.ui.window)
local makeSidebar = require(script.Parent.ui.sidebar)
local makeContent = require(script.Parent.ui.content)
local makeTabs = require(script.Parent.ui.tabs)
local makeToggle = require(script.Parent.ui.components.toggle)
local makeButton = require(script.Parent.ui.components.button)
local makeSection = require(script.Parent.ui.components.section)

local esp = require(script.Parent.modules.esp)
local teleport = require(script.Parent.modules.teleport)
local lava = require(script.Parent.modules.lava)

local gui = makeRoot()

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = gui

local window, topBar = makeWindow(gui, config)
local sidebar = makeSidebar(window, config)
local content = makeContent(window, config)

local espEnabled = false
local tabContents = {}
local function getTab(name)
    if tabContents[name] then return tabContents[name] end
    local f = U.new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = content,
    })
    tabContents[name] = f
    return f
end

local tabs = {"Visuals", "Farm", "Settings"}
local _, showTab = makeTabs(sidebar, config, tabs, function(name)
    for n, f in pairs(tabContents) do
        f.Visible = (n == name)
    end
end)

-- Visuals tab
local vTab = getTab("Visuals")
makeSection(vTab, config, 10, "Egg ESP")
makeToggle(vTab, config, 40, "Enable Egg ESP", false, function(v)
    espEnabled = v
    if not v then esp:clear() end
end)

-- Farm tab
local fTab = getTab("Farm")
makeSection(fTab, config, 10, "Teleport")
makeButton(fTab, config, 40, "TP to Nearest Egg", function()
    teleport.tpNearest()
end)
makeButton(fTab, config, 80, "Grab Volcanic Egg", function()
    local ok, msg = lava.grab()
    print(ok, msg)
end)

-- Settings tab
local sTab = getTab("Settings")
makeSection(sTab, config, 10, "Info")
makeButton(sTab, config, 40, "Unload OR4CLE", function()
    gui:Destroy()
end)

-- Bubble
local bubble = makeBubble(gui, config, function()
    window.Visible = not window.Visible
end)

-- drag bubble
local dragging, dragStart, startPos
bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position
    end
end)
bubble.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        bubble.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- drag window
local wDrag, wStart, wPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        wDrag = true
        wStart = input.Position
        wPos = window.Position
    end
end)
topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        wDrag = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if wDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - wStart
        window.Position = UDim2.new(
            wPos.X.Scale, wPos.X.Offset + d.X,
            wPos.Y.Scale, wPos.Y.Offset + d.Y
        )
    end
end)

-- ESP loop
game:GetService("RunService").Heartbeat:Connect(function()
    if espEnabled then esp.scan(espFolder) end
end)

print("OR4CLE loaded")
EOF

# ============ README.md ============
cat > README.md << 'EOF'
# OR4CLE

EOF
