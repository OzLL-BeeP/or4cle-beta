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
