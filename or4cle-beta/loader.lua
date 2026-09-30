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
