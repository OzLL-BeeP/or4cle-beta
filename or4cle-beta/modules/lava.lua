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
