local M = {}
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

M.enabled = false
M.speed = 32          -- WalkSpeed target
M.defaultSpeed = 16   -- WalkSpeed default Roblox
M.smooth = true
M.current = 16
M.conn = nil

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function step()
    local hum = getHum()
    if not hum then return end

    if M.enabled then
        if M.smooth then
            M.current = M.current + (M.speed - M.current) * 0.2
            hum.WalkSpeed = M.current
        else
            hum.WalkSpeed = M.speed
        end
    else
        if M.smooth then
            if math.abs(M.current - M.defaultSpeed) < 0.5 then
                M.current = M.defaultSpeed
                hum.WalkSpeed = M.defaultSpeed
                return
            end
            M.current = M.current + (M.defaultSpeed - M.current) * 0.2
            hum.WalkSpeed = M.current
        else
            hum.WalkSpeed = M.defaultSpeed
        end
    end
end

function M.start()
    if M.conn then return end
    M.conn = RunService.Heartbeat:Connect(step)
end

function M.stop()
    if M.conn then
        M.conn:Disconnect()
        M.conn = nil
    end
end

function M.toggle(on)
    M.enabled = on
    if on then M.start() end
end

function M.setSpeed(v)
    M.speed = math.clamp(v, 16, 200)
end

function M.getSpeed()
    local hum = getHum()
    return hum and hum.WalkSpeed or M.current
end

M.start()
return M
