-- OR4CLE idle_fly.lua
-- Gerak cepat ke target pakai BodyVelocity + noclip sementara.
-- Dipakai Auto Farm buat balapan sama timer 20 detik.

local M = {}
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

M.speed = 250           -- studs/detik
M.maxDuration = 8       -- detik max (safety)
M.noclipOnFly = true    -- tembus dinding waktu terbang

local function getChar()
    return LP.Character
end

local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- enable noclip sementara
local function setNoclip(on)
    if not M.noclipOnFly then return end
    local c = getChar()
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not on and true or false
        end
    end
end

-- fly ke posisi target
-- return: true kalau sampe, false kalau timeout/gagal
function M.flyTo(targetPos, overrideSpeed)
    local hrp = getHRP()
    local hum = getHum()
    if not hrp or not hum then return false end

    local speed = overrideSpeed or M.speed

    -- hitung jarak & estimasi waktu
    local dist = (targetPos - hrp.Position).Magnitude
    local estTime = dist / speed
    if estTime > M.maxDuration then
        -- perbesar speed biar sampe dalam maxDuration
        speed = dist / M.maxDuration
    end

    -- stop humanoid movement biar gak tabrakan
    hum:MoveTo(hrp.Position)
    hum.PlatformStand = true

    setNoclip(true)

    -- BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 15000
    bv.Parent = hrp

    -- BodyGyro biar karakter gak muter
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 5000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local startTime = tick()
    local success = false

    while tick() - startTime < M.maxDuration do
        if not hrp.Parent then break end
        local curPos = hrp.Position
        local delta = targetPos - curPos
        local d = delta.Magnitude
        if d < 4 then
            success = true
            break
        end
        -- set velocity arah target
        bv.Velocity = delta.Unit * speed
        bg.CFrame = CFrame.new(curPos, targetPos)
        RunService.Heartbeat:Wait()
    end

    bv:Destroy()
    bg:Destroy()

    hum.PlatformStand = false
    setNoclip(false)

    return success
end

-- versi dengan timeout custom
function M.flyToTimed(targetPos, maxTime)
    local hrp = getHRP()
    if not hrp then return false end
    local dist = (targetPos - hrp.Position).Magnitude
    local speed = dist / maxTime
    if speed < 50 then speed = 50 end
    if speed > 500 then speed = 500 end
    return M.flyTo(targetPos, speed)
end

function M.setSpeed(v) M.speed = math.clamp(v, 50, 500) end
function M.setMaxDuration(v) M.maxDuration = math.clamp(v, 2, 15) end
function M.setNoclip(on) M.noclipOnFly = on end

return M
