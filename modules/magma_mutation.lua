local M = {}
local LP = game:GetService("Players").LocalPlayer

M.CraterCF = CFrame.new(-5102.8, 41405.6, -3489.1)
M.autoEnabled = false

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function findDropPrompt()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") then
            local t = (o.ActionText .. " " .. o.ObjectText):lower()
            if t:find("drop") or t:find("volcano") or t:find("lava") or t:find("dip") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    local d = (parent.Position - M.CraterCF.Position).Magnitude
                    if d < 150 then return o end
                end
            end
        end
    end
    return nil
end

local function firePrompt(p)
    if not p then return false end
    if fireproximityprompt then
        fireproximityprompt(p)
        return true
    end
    p:InputHoldBegin()
    task.wait((p.HoldDuration or 0) + 0.05)
    p:InputHoldEnd()
    return true
end

function M.dropEgg()
    tp(M.CraterCF)
    task.wait(1.2)
    local p = findDropPrompt()
    if not p then return false, "Drop prompt gak ketemu" end
    firePrompt(p)
    task.wait(3.5)
    return true, "Dropped"
end

function M.attempt()
    return M.dropEgg()
end

function M.toggle(on) M.autoEnabled = on end

return M
