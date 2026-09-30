local M = {}
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

M.enabled = false
M.speed = 32
M.defaultSpeed = 16
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
        local target = M.speed
        if M.smooth then
            M.current = M.current + (target - M.current) * 0.15
            hum.WalkSpeed = M.current
        else
            hum.WalkSpeed = target
        end
    else
        if M.smooth then
            M.current = M.current + (M.defaultSpeed - M.current) * 0.15
            if math.abs(M.current - M.defaultSpeed) < 0.5 then
                M.current = M.defaultSpeed
                hum.WalkSpeed = M.defaultSpeed
                return
            end
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
    if M.conn then M.conn:Disconnect(); M.conn = nil end
end

function M.toggle(on)
    M.enabled = on
    if on then M.start() end
end

function M.setSpeed(v) M.speed = v end

M.start()
return M
