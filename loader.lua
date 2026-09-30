-- OR4CLE v4 entry
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
local makeOptionPicker = loadModule("ui/components/option_picker.lua")

local esp        = loadModule("modules/esp.lua")
local teleport   = loadModule("modules/teleport.lua")
local lava       = loadModule("modules/lava.lua")
local magma      = loadModule("modules/magma_mutation.lua")
local fps        = loadModule("modules/fps_boost.lua")
local autoTp     = loadModule("modules/auto_tp_egg.lua")
local speed      = loadModule("modules/speed_hack.lua")
local antiAfk    = loadModule("modules/anti_afk.lua")
local hop        = loadModule("modules/server_hop.lua")
local autoFarm   = loadModule("modules/auto_farm.lua")
autoFarm.inject({magma = magma, esp = esp})

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

-- ============================================
-- TAB: VISUALS
-- ============================================
local vTab = getTab("Visuals")

makeSection(vTab, config, 0, "EGG ESP")
makeToggle(vTab, config, 40, "Enable Egg ESP", false, function(v)
    espEnabled = v
    if not v then esp.clear() end
end)

makeSection(vTab, config, 92, "ESP SETTINGS")
makeToggle(vTab, config, 132, "Show Distance", true, function(v)
    esp.showDistance = v
end)
makeToggle(vTab, config, 176, "Show Tracer", true, function(v)
    esp.showTracer = v
end)

-- ============================================
-- TAB: FARM
-- ============================================
local fTab = getTab("Farm")

-- RARITY FILTER
makeSection(fTab, config, 0, "RARITY FILTER")

local TIER_COLORS = {
    Common   = Color3.fromRGB(180, 180, 180),
    Rare     = Color3.fromRGB(80, 160, 255),
    Epic     = Color3.fromRGB(180, 100, 255),
    Legend   = Color3.fromRGB(255, 150, 50),
    Mythic   = Color3.fromRGB(255, 80, 80),
    Divine   = Color3.fromRGB(255, 215, 0),
    Ethereal = Color3.fromRGB(255, 100, 255),
}
local tierOptions = {"Common","Rare","Epic","Legend","Mythic","Divine","Ethereal"}

makeOptionPicker(fTab, config, 40, {
    label = "Min Tier: ",
    options = tierOptions,
    colors = TIER_COLORS,
    default = "Common",
}, function(tier)
    esp.setMinTier(tier)
    autoFarm.setMinTier(tier)
end)

-- TELEPORT
makeSection(fTab, config, 92, "TELEPORT")
makeButton(fTab, config, 132, "TP to Nearest Egg", function()
    teleport.tpNearest()
end)
makeButton(fTab, config, 172, "TP to Highest Tier Egg", function()
    local best = autoFarm.findBestEggPublic()
    if best then
        local base = best:FindFirstChild("EggBase") or best:FindFirstChildWhichIsA("BasePart")
        if base then
            local char = Players.LocalPlayer.Character
            local h = char and char:FindFirstChild("HumanoidRootPart")
            if h then h.CFrame = base.CFrame + Vector3.new(0, 3, 0) end
        end
    end
end)

-- AUTO FARM
makeSection(fTab, config, 224, "AUTO FARM")

makeToggle(fTab, config, 264, "Enable Auto Farm", false, function(v)
    autoFarm.toggle(v)
end)

local modeOptions = {"Teleport", "Idle"}
makeOptionPicker(fTab, config, 308, {
    label = "Mode: ",
    options = modeOptions,
    default = "Teleport",
}, function(mode)
    autoFarm.setMode(mode)
end)

makeToggle(fTab, config, 356, "Return to Ranch", true, function(v)
    autoFarm.setReturn(v)
end)

makeToggle(fTab, config, 400, "Auto Magma Mutation", false, function(v)
    autoFarm.setMagma(v)
end)

-- VOLCANIC
makeSection(fTab, config, 452, "VOLCANIC")
makeButton(fTab, config, 492, "Grab Volcanic Egg", function()
    local ok, msg = lava.grab()
    print("[OR4CLE]", ok, msg)
end)
makeButton(fTab, config, 532, "Attempt Magma Mutation", function()
    local ok, msg = magma.attempt()
    print("[OR4CLE]", ok, msg)
end)

-- ============================================
-- TAB: UTILITY
-- ============================================
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

local hopOptions = {"5 menit","10 menit","15 menit","20 menit","25 menit","30 menit","40 menit","50 menit"}
makeOptionPicker(uTab, config, 224, {
    label = "Interval: ",
    options = hopOptions,
    default = "10 menit",
}, function(opt)
    local mins = tonumber(opt:match("%d+")) or 10
    hop.setInterval(mins)
    if hop.enabled then hop.stop(); hop.start() end
end)

makeToggle(uTab, config, 272, "Auto Server Hop", false, function(v)
    hop.toggle(v)
end)

makeButton(uTab, config, 316, "Hop Now", function()
    hop.hop()
end)

-- ============================================
-- TAB: SETTINGS
-- ============================================
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
    autoFarm.stop()
end)

-- ============================================
-- BUBBLE
-- ============================================
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

print("[OR4CLE] v4 loaded")
