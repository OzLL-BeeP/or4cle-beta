-- OR4CLE entry point (GitHub-compatible)
local BASE = "https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/"

local function loadModule(path)
    local code = game:HttpGet(BASE .. path)
    return loadstring(code)()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local config   = loadModule("config.lua")
local U        = loadModule("util.lua")
local makeRoot = loadModule("root.lua")
local makeBubble = loadModule("ui/bubble.lua")
local makeWindow = loadModule("ui/window.lua")
local makeSidebar = loadModule("ui/sidebar.lua")
local makeContent = loadModule("ui/content.lua")
local makeTabs = loadModule("ui/tabs.lua")
local makeToggle = loadModule("ui/components/toggle.lua")
local makeButton = loadModule("ui/components/button.lua")
local makeSection = loadModule("ui/components/section.lua")

local esp = loadModule("modules/esp.lua")
local teleport = loadModule("modules/teleport.lua")
local lava = loadModule("modules/lava.lua")
local magma = loadModule("modules/magma_mutation.lua")

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

-- Visuals
local vTab = getTab("Visuals")
makeSection(vTab, config, 10, "Egg ESP")
makeToggle(vTab, config, 40, "Enable Egg ESP", false, function(v)
    espEnabled = v
    if not v then esp.clear() end
end)

-- Farm
local fTab = getTab("Farm")
makeSection(fTab, config, 10, "Teleport")
makeButton(fTab, config, 40, "TP to Nearest Egg", function()
    teleport.tpNearest()
end)
makeButton(fTab, config, 80, "Grab Volcanic Egg", function()
    local ok, msg = lava.grab()
    print("[OR4CLE]", ok, msg)
end)
makeButton(fTab, config, 120, "Attempt Magma Mutation", function()
    local ok, msg = magma.attempt()
    print("[OR4CLE]", ok, msg)
end)

-- Settings
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

print("[OR4CLE] Loaded")
