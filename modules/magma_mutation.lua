local LP = game.Players.LocalPlayer
local function getRanch()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner")
            if owner and owner.Value == LP then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok then return cf end
            end
        end
    end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.CFrame or CFrame.new(0, 40313, 900)
end

-- OR4CLE magma_mutation.lua
-- Drop egg ke lava di summit crater buat roll Magma Mutation
local M = {}
local LP = game:GetService("Players").LocalPlayer

M.CraterCF = CFrame.new(-5102.8, 41405.6, -3489.1)
-- Ranch auto-detected via getRanch()

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
            if t:find("drop") or t:find("volcano") or t:find("lava") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    local d = (parent.Position - M.CraterCF.Position).Magnitude
                    if d < 100 then return o end
                end
            end
        end
    end
    return nil
end

function M.attempt()
    tp(M.CraterCF)
    task.wait(1)
    local p = findDropPrompt()
    if not p then return false, "Prompt drop gak ketemu" end
    if fireproximityprompt then
        fireproximityprompt(p)
    else
        p:InputHoldBegin()
        task.wait(p.HoldDuration + 0.05)
        p:InputHoldEnd()
    end
    task.wait(3)
    tp(getRanch())
    return true, "Attempt terkirim"
end

return M
