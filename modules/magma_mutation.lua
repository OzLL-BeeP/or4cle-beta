local M = {}
local LP = game:GetService("Players").LocalPlayer

M.CraterCF = CFrame.new(-5102.8, 41405.6, -3489.1)
M.mode = "Teleport"

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

local function findPickupPrompt()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") and o.ActionText:lower():find("pick") then
            local parent = o.Parent
            if parent and parent:IsA("BasePart") then
                local d = (parent.Position - M.CraterCF.Position).Magnitude
                if d < 200 then return o end
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

local function hasEgg()
    local c = LP.Character
    if not c then return false end
    for _, o in ipairs(c:GetDescendants()) do
        if o.Name:lower():find("egg") then return true end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, o in ipairs(bp:GetChildren()) do
            if o.Name:lower():find("egg") then return true end
        end
    end
    return false
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

    -- 3. fire drop prompt
    firePrompt(p)
    task.wait(0.3)

    -- 4. tunggu egg "keluar" dari tangan (drop animasi)
    local startWait = tick()
    while hasEgg() and tick() - startWait < 2 do
        task.wait(0.1)
    end

    -- 5. tunggu hasil roll dari server
    -- (server roll ~3-4 detik, terus egg balik ke tangan)
    task.wait(4)

    -- 6. cek egg udah balik ke tangan
    local eggBack = hasEgg()

    -- 7. kalau belum balik, coba pickup ulang
    if not eggBack then
        local pickupP = findPickupPrompt()
        if pickupP then
            firePrompt(pickupP)
            task.wait(0.8)
            eggBack = hasEgg()
        end
    end

    -- 8. kalau masih belum dapet, tunggu lagi
    if not eggBack then
        task.wait(2)
        eggBack = hasEgg()
    end

    -- 9. diam di crater 1 detik (jangan langsung gerak)
    task.wait(1)

    if eggBack then
        return true, "Egg retrieved (mutated or not)"
    else
        return true, "Egg dropped, belum balik"
    end
end

function M.setMode(m) M.mode = m end
function M.inject(deps) idleFly = deps.idleFly end

return M
