local M = {}
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local originals = {}
local active = false

local function saveProp(obj, prop)
    if originals[obj] == nil then originals[obj] = {} end
    if originals[obj][prop] == nil then
        originals[obj][prop] = obj[prop]
    end
end

function M.enable()
    if active then return end
    active = true

    -- Lighting
    saveProp(Lighting, "GlobalShadows"); Lighting.GlobalShadows = false
    saveProp(Lighting, "FogEnd"); Lighting.FogEnd = 1e6
    saveProp(Lighting, "Brightness"); Lighting.Brightness = 2
    saveProp(Lighting, "EnvironmentDiffuseScale"); Lighting.EnvironmentDiffuseScale = 0
    saveProp(Lighting, "EnvironmentSpecularScale"); Lighting.EnvironmentSpecularScale = 0
    saveProp(Lighting, "Ambient"); Lighting.Ambient = Color3.fromRGB(140, 140, 140)
    saveProp(Lighting, "OutdoorAmbient"); Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
    saveProp(Lighting, "ClockTime"); Lighting.ClockTime = 12

    -- Terrain
    if Terrain then
        saveProp(Terrain, "WaterWaveSize"); Terrain.WaterWaveSize = 0
        saveProp(Terrain, "WaterWaveSpeed"); Terrain.WaterWaveSpeed = 0
        saveProp(Terrain, "WaterReflectance"); Terrain.WaterReflectance = 0
        saveProp(Terrain, "WaterTransparency"); Terrain.WaterTransparency = 1
    end

    -- Post effects (disable)
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") and obj.Enabled then
            saveProp(obj, "Enabled"); obj.Enabled = false
        end
    end

    -- ParticleEmitter & Beam global
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and obj.Enabled then
            saveProp(obj, "Enabled"); obj.Enabled = false
        elseif obj:IsA("Beam") and obj.Enabled then
            saveProp(obj, "Enabled"); obj.Enabled = false
        elseif obj:IsA("Trail") and obj.Enabled then
            saveProp(obj, "Enabled"); obj.Enabled = false
        elseif obj:IsA("Fire") then
            saveProp(obj, "Enabled"); obj.Enabled = false
        elseif obj:IsA("Smoke") then
            saveProp(obj, "Enabled"); obj.Enabled = false
        elseif obj:IsA("Sparkles") then
            saveProp(obj, "Enabled"); obj.Enabled = false
        end
    end
end

function M.disable()
    if not active then return end
    active = false
    for obj, props in pairs(originals) do
        for prop, val in pairs(props) do
            pcall(function() obj[prop] = val end)
        end
    end
    originals = {}
end

function M.toggle(on)
    if on then M.enable() else M.disable() end
end

return M
