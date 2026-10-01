-- OR4CLE auto_farm.lua v6 — timer-aware + magma + volcanic via door
local M = {}
local LP = game:GetService("Players").LocalPlayer

M.enabled = false
M.mode = "Teleport"
M.minTier = "Common"
M.returnToBase = true
M.loopDelay = 1.0
M.magmaAuto = false
M.magmaMode = "Teleport"
M.idleSpeed = 250
M.volcanicMode = true

M.stats = { farmed = 0, delivered = 0, magma = 0, volcanic = 0, startedAt = 0 }
M._origWalkSpeed = 16

local magma, idleFly, esp

local TIER_ORDER = { Common=1, Rare=2, Epic=3, Legend=4, Mythic=5, Divine=6, Ethereal=7 }

-- ============ WAYPOINTS VOLCANO ============
local WAYPOINTS = {
    Outside = CFrame.new(-4940, 41284, -3680),
    Door    = CFrame.new(-4967, 41282, -3657),
    Inside  = CFrame.new(-5300, 40930, -3580),
}

-- ============ HELPERS ============
local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function hum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function tp(cf)
    local h = hrp()
    if h then h.CFrame = cf end
end

local function tierOf(name)
    local n = name:lower()
    if n:find("volcanic") or n:find("cherub") or n:find("solaris") or n:find("blackhole") or n:find("black hole") then return "Ethereal" end
    if n:find("bloom") or n:find("galaxy") or n:find("aurora") then return "Divine" end
    if n:find("tidal") or n:find("soul") or n:find("sinister") or n:find("flaming")
    or n:find("dominus") or n:find("asteroid") or n:find("skull") or n:find("crystal")
    or n:find("diamond") then return "Mythic" end
    if n:find("golden") or n:find("glass") then return "Legend" end
    if n:find("ice") or n:find("slime") or n:find("flower") or n:find("mushroom") then return "Epic" end
    if n:find("leaf") or n:find("stone") or n:find("easter") or n:find("cracked") then return "Rare" end
    if n:find("brown") or n:find("white") then return "Common" end
    return "Unknown"
end

local function passFilter(tier)
    return (TIER_ORDER[tier] or 0) >= (TIER_ORDER[M.minTier] or 0)
end

-- ============ BASE POS ============
local function getBasePos()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local data = plot:FindFirstChild("Data")
            local owner = data and data:FindFirstChild("Owner")
            if owner and owner.Value and owner.Value == LP then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok then return cf.Position end
                local eggs = plot:FindFirstChild("Eggs")
                if eggs then
                    local base = eggs:FindFirstChildWhichIsA("BasePart")
                    if base then return base.Position end
                end
                local nests = plot:FindFirstChild("Nests")
                if nests then
                    local nest = nests:GetChildren()[1]
                    if nest then
                        local base = nest:FindFirstChildWhichIsA("BasePart")
                        if base then return base.Position end
                    end
                end
            end
        end
    end
    return nil
end

-- ============ FIND EGG ============
local function findBestEgg()
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then return nil end
    local h = hrp()
    local best, bestRank, bestDist = nil, -1, math.huge
    for _, egg in ipairs(re:GetChildren()) do
        local tier = tierOf(egg.Name)
        if passFilter(tier) then
            local rank = TIER_ORDER[tier] or 0
            local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
            if base then
                local d = h and (base.Position - h.Position).Magnitude or 0
                if rank > bestRank or (rank == bestRank and d < bestDist) then
                    best, bestRank, bestDist = egg, rank, d
                end
            end
        end
    end
    return best
end

-- ============ WALK (MoveTo) ============
local function walkTo(targetPos, timeout)
    local h = hum()
    if not h then return false end
    h:MoveTo(targetPos)
    local t = tick()
    while tick() - t < (timeout or 5) do
        local r = hrp()
        if not r then break end
        if (r.Position - targetPos).Magnitude < 6 then
            h:MoveTo(r.Position)
            return true
        end
        task.wait(0.1)
    end
    return false
end

-- ============ VOLCANO ENTER/EXIT ============
local function enterVolcano()
    -- save walk speed asli
    local h = hum()
    if h then
        M._origWalkSpeed = h.WalkSpeed
        h.WalkSpeed = 100  -- boost biar cepet
    end

    -- 1. TP ke luar pintu
    tp(WAYPOINTS.Outside)
    task.wait(0.4)

    -- 2. noclip on (biar gak nyangkut)
    if idleFly and idleFly.setNoclip then idleFly.setNoclip(true) end

    -- 3. walk ke pintu (server deteksi masuk)
    walkTo(WAYPOINTS.Door.Position, 4)
    task.wait(0.3)

    -- 4. walk ke dalam lair
    walkTo(WAYPOINTS.Inside.Position, 6)
    task.wait(0.3)

    return true
end

local function exitVolcano()
    -- 1. walk balik ke pintu (dari dalam)
    walkTo(WAYPOINTS.Door.Position, 5)
    task.wait(0.3)

    -- 2. walk ke luar
    walkTo(WAYPOINTS.Outside.Position, 4)
    task.wait(0.3)

    -- 3. TP lebih jauh keluar
    tp(WAYPOINTS.Outside + Vector3.new(0, 0, -50))
    task.wait(0.3)

    -- 4. balikin walk speed
    local h = hum()
    if h then h.WalkSpeed = M._origWalkSpeed end

    -- 5. noclip off
    if idleFly and idleFly.setNoclip then idleFly.setNoclip(false) end
end

-- ============ PROMPTS ============
local function findPickupPrompt(egg)
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.ActionText:lower():find("pick") then
            return d
        end
    end
    for _, d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") then return d end
    end
end

local function findDropPromptAt(basePos)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") then
            local t = (o.ActionText .. " " .. o.ObjectText):lower()
            if t:find("drop") or t:find("place") or t:find("nest") then
                local parent = o.Parent
                if parent and parent:IsA("BasePart") then
                    if (parent.Position - basePos).Magnitude < 80 then return o end
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

-- ============ HAS EGG ============
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

-- ============ MOVE ============
local function moveTo(targetPos, maxTime)
    if M.mode == "Idle" and idleFly then
        return idleFly.flyToTimed(targetPos, maxTime or 6)
    else
        tp(CFrame.new(targetPos))
        task.wait(0.2)
        return true
    end
end

-- ============ LOOP ============
local thread
local function loop()
    M.stats.startedAt = tick()
    while M.enabled do
        -- GUARD: kalau masih bawa egg, ke base dulu
        if hasEgg() then
            if M.returnToBase then
                local basePos = getBasePos()
                if basePos then
                    moveTo(basePos, 8)
                    task.wait(0.3)
                    local dropP = findDropPromptAt(basePos)
                    if dropP then
                        firePrompt(dropP)
                        task.wait(0.8)
                    else
                        task.wait(1.5)
                    end
                    M.stats.delivered = M.stats.delivered + 1
                end
            end
            task.wait(M.loopDelay)
        else
            local egg = findBestEgg()
            if egg then
                local base = egg:FindFirstChild("EggBase") or egg:FindFirstChildWhichIsA("BasePart")
                if base then
                    local eggPos = base.Position
                    local inVolcano = eggPos.Y > 40900

                    -- 1. masuk volcano lewat pintu
                    if inVolcano and M.volcanicMode then
                        enterVolcano()
                    end

                    -- 2. gerak ke egg
                    moveTo(eggPos + Vector3.new(0, 2, 0), 5)
                    task.wait(0.2)

                    -- 3. pickup
                    local prompt = findPickupPrompt(egg)
                    if prompt then
                        firePrompt(prompt)
                        task.wait(0.4)

                        if hasEgg() then
                            M.stats.farmed = M.stats.farmed + 1
                            if inVolcano then M.stats.volcanic = M.stats.volcanic + 1 end

                            -- 4. keluar volcano LEWAT PINTU (server validasi)
                            if inVolcano and M.volcanicMode then
                                exitVolcano()
                                task.wait(0.3)
                            end

                            -- 5. MAGMA MODE
                            if M.magmaAuto and magma and magma.dropAndRetrieve then
                                if magma.setMode then magma.setMode(M.magmaMode) end
                                local okDrop = magma.dropAndRetrieve()
                                if okDrop then M.stats.magma = M.stats.magma + 1 end
                                task.wait(1)
                                local retry = 0
                                while not hasEgg() and retry < 5 do
                                    task.wait(0.5)
                                    retry = retry + 1
                                end
                            end

                            -- 6. bawa ke base
                            if M.returnToBase then
                                local basePos = getBasePos()
                                if basePos then
                                    moveTo(basePos, 8)
                                    task.wait(0.3)
                                    local dropP = findDropPromptAt(basePos)
                                    if dropP then
                                        firePrompt(dropP)
                                        task.wait(0.8)
                                    else
                                        task.wait(1.5)
                                    end
                                    M.stats.delivered = M.stats.delivered + 1
                                end
                            end
                        end
                    end
                end
            end
            task.wait(M.loopDelay)
        end
    end
end

-- ============ PUBLIC API ============
function M.start()
    if thread then return end
    M.enabled = true
    thread = task.spawn(loop)
end

function M.stop()
    M.enabled = false
    thread = nil
    if idleFly and idleFly.setNoclip then idleFly.setNoclip(false) end
    -- restore walk speed
    local h = hum()
    if h then h.WalkSpeed = M._origWalkSpeed end
end

function M.toggle(on)
    if on then M.start() else M.stop() end
end

function M.setMode(m) M.mode = m end
function M.setMinTier(t) M.minTier = t end
function M.setReturn(on) M.returnToBase = on end
function M.setDelay(d) M.loopDelay = d end
function M.setMagma(on) M.magmaAuto = on end
function M.setMagmaMode(m)
    M.magmaMode = m
    if magma and magma.setMode then magma.setMode(m) end
end
function M.setVolcanicMode(on) M.volcanicMode = on end
function M.setIdleSpeed(s)
    M.idleSpeed = s
    if idleFly then idleFly.setSpeed(s) end
end

function M.inject(deps)
    magma = deps.magma
    idleFly = deps.idleFly
    esp = deps.esp
    if magma and magma.inject then
        magma.inject({idleFly = idleFly})
    end
end

function M.findBestEggPublic() return findBestEgg() end
function M.hasEgg() return hasEgg() end

return M
