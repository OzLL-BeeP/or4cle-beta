local M = {}
local LP = game:GetService("Players").LocalPlayer

M.CraterCF = CFrame.new(-5102.8, 41405.6, -3489.1)
M.mode = "Teleport"   -- "Teleport" | "Idle"

local idleFly

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function moveTo(targetPos, maxTime)
    if M.mode == "Idle" and idleFly then
        return idleFly.flyToTimed(targetPos, maxTime or 5)
    else
        tp(CFrame.new(targetPos))
        task.wait(0.2)
        return true
    end
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

function M.dropAndRetrieve()
    -- 1. gerak ke crater
    moveTo(M.CraterCF.Position, 5)
    task.wait(0.5)

    -- 2. cari prompt drop
    local p = findDropPrompt()
    if not p then
        return false, "Drop prompt gak ketemu"
    end

    -- 3. fire prompt
    firePrompt(p)
    task.wait(0.5)

    -- 4. tunggu roll server
    task.wait(3.5)

    -- 5. cek egg balik ke karakter
    local char = LP.Character
    local hasEgg = false
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj.Name:lower():find("egg") then
                hasEgg = true
                break
            end
        end
    end
    if not hasEgg then
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, obj in ipairs(bp:GetChildren()) do
                if obj.Name:lower():find("egg") then
                    hasEgg = true
                    break
                end
            end
        end
    end

    return true, hasEgg and "Egg returned" or "Egg dropped"
end

function M.setMode(m) M.mode = m end
function M.inject(deps) idleFly = deps.idleFly end

return M
