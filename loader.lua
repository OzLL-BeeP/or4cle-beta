-- OR4CLE v3 entry
local BASE = "https://raw.githubusercontent.com/OzLL-BeeP/or4cle-beta/main/"

local function loadModule(path)
    return loadstring(game:HttpGet(BASE .. path))()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local config      = loadModule("config.lua")
local U           = loadModule("util.lua")
local makeRoot    = loadModule("root.lua")
local makeBubble  = loadModule("ui/bubble.lua")
local makeWindow  = loadModule("ui/window.lua")
local makeSidebar = loadModule("ui/sidebar.lua")
local makeContent = loadModule("ui/content.lua")
local makeTabs    = loadModule("ui/tabs.lua")
local makeToggle  = loadModule("ui/components/toggle.lua")
local makeButton  = loadModule("ui/components/button.lua")
local makeSection = loadModule("ui/components/section.lua")

local esp        = loadModule("modules/esp.lua")
local teleport   = loadModule("modules/teleport.lua")
local lava       = loadModule("modules/lava.lua")
local magma      = loadModule("modules/magma_mutation.lua")
local fps        = loadModule("modules/fps_boost.lua")
local autoTp     = loadModule("modules/auto_tp_egg.lua")
local speed      = loadModule("modules/speed_hack.lua")
local antiAfk    = loadModule("modules/anti_afk.lua")
local hop        = loadModule("modules/server_hop.lua")

local gui = makeRoot()
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = gui

local window, topBar, searchInput = makeWindow(gui, config)
local sidebar = makeSidebar(window, config)
local content, scroll = makeContent(window, config)

local espEnabled = false
local tabContents = {}

local function getTab(name)
    if tabContents[name] then return tabContents[name] end
    local holder = U.new("Frame", {
        Name = "Tab_" .. name,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 2,
        Parent = scroll,
    })
    tabContents[name] = holder
    return holder
end

local function refreshTabs(activeName)
    for n, f in pairs(tabContents) do
        f.Visible = (n == activeName)
    end
end

local tabNames = {"Visuals", "Farm", "Utility", "Settings"}
for _, n in ipairs(tabNames) do getTab(n) end

local _, showTab = makeTabs(sidebar, config, tabNames, refreshTabs)

task.defer(function()
    task.wait(0.2)
    refreshTabs("Visuals")
end)

-- VISUALS
local vTab = getTab("Visuals")
makeSection(vTab, config, 0, "EGG ESP")
makeToggle(vTab, config, 40, "Enable Egg ESP", false, function(v)
    espEnabled = v
    if not v then esp.clear() end
end)

makeSection(vTab, config, 92, "MIN RARITY")
local tierList = {"Common","Rare","Epic","Legend","Mythic","Divine","Ethereal"}
local tierIdx = 1
local tierBtn, tierBtnText

local function cycleTier()
    tierIdx = tierIdx + 1
    if tierIdx > #tierList then tierIdx = 1 end
    esp.setMinTier(tierList[tierIdx])
    if tierBtnText then
        tierBtnText.Text = "Min Tier: " .. tierList[tierIdx]
    end
end

tierBtn, tierBtnText = makeButton(vTab, config, 132, "Min Tier: Common", cycleTier)

-- FARM
local fTab = getTab("Farm")
makeSection(fTab, config, 0, "TELEPORT")
makeButton(fTab, config, 40, "TP to Nearest Egg", function()
    teleport.tpNearest()
end)

makeSection(fTab, config, 92, "AUTO TP TIER DIVINE+")
makeToggle(fTab, config, 132, "Enable Auto TP Egg", false, function(v)
    autoTp.toggle(v)
end)

makeSection(fTab, config, 184, "VOLCANIC")
makeButton(fTab, config, 224, "Grab Volcanic Egg", function()
    local ok, msg = lava.grab()
    print("[OR4CLE]", ok, msg)
end)
makeButton(fTab, config, 268, "Attempt Magma Mutation", function()
    local ok, msg = magma.attempt()
    print("[OR4CLE]", ok, msg)
end)

-- UTILITY
local uTab = getTab("Utility")
makeSection(uTab, config, 0, "MOVEMENT")
makeToggle(uTab, config, 40, "Speed Hack", false, function(v)
    speed.toggle(v)
end)

makeSection(uTab, config, 92, "AFK PROTECTION")
makeToggle(uTab, config, 132, "Anti AFK", false, function(v)
    antiAfk.toggle(v)
end)

makeSection(uTab, config, 184, "SERVER HOP")
local hopModes = {5, 10, 15, 20, 25, 30, 40, 50}
local hopIdx = 2
local hopBtn, hopBtnText

local function applyHop()
    hop.setInterval(hopModes[hopIdx])
    if hopBtnText then
        hopBtnText.Text = "Interval: " .. hopModes[hopIdx] .. " menit"
    end
end

makeToggle(uTab, config, 224, "Auto Server Hop", false, function(v)
    if v then applyHop() end
    hop.toggle(v)
end)

hopBtn, hopBtnText = makeButton(uTab, config, 268, "Interval: 10 menit", function()
    hopIdx = hopIdx + 1
    if hopIdx > #hopModes then hopIdx = 1 end
    applyHop()
    if hop.enabled then hop.stop(); hop.start() end
end)

makeButton(uTab, config, 312, "Hop Now", function()
    hop.hop()
end)

-- SETTINGS
local sTab = getTab("Settings")
makeSection(sTab, config, 0, "PERFORMANCE")
makeToggle(sTab, config, 40, "FPS Boost", false, function(v)
    fps.toggle(v)
end)

makeSection(sTab, config, 92, "INFO")
makeButton(sTab, config, 132, "Unload OR4CLE", function()
    gui:Destroy()
    fps.disable()
    speed.toggle(false)
    antiAfk.toggle(false)
    hop.toggle(false)
    autoTp.toggle(false)
end)

-- BUBBLE
local bubble = makeBubble(gui, config, function()
    if not window.Visible then
        window.Visible = true
        U.tween(window, { BackgroundTransparency = 0.05 }, 0.25, "out")
    else
        U.tween(window, { BackgroundTransparency = 1 }, 0.15, "inout")
        task.wait(0.15)
        window.Visible = false
        window.BackgroundTransparency = 0.05
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

game:GetService("RunService").Heartbeat:Connect(function()
    if espEnabled then esp.scan(espFolder) end
end)

print("[OR4CLE] v3 loaded")
