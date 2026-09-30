local M = {}
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

M.enabled = false
M.conn = nil
M.idleConn = nil
M.lastMove = 0

-- cegah idle event
local function blockIdle()
    if LP then
        pcall(function()
            if M.idleConn then M.idleConn:Disconnect() end
        end)
    end
end

-- simulasi gerakan halus (biar gak dianggap idle)
local function nudge()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- vibrate ringan pakai JumpPower toggle (gak gerak visual)
    -- atau ubah WalkSpeed sejenak
    local orig = hum.WalkSpeed
    hum.WalkSpeed = orig + 0.1
    task.wait(0.05)
    hum.WalkSpeed = orig
end

function M.start()
    if M.conn then return end
    M.conn = task.spawn(function()
        while M.enabled do
            task.wait(30)
            pcall(nudge)
        end
    end)
    -- disable idle event
    pcall(function()
        LP.Idled:Connect(function() end)
    end)
end

function M.stop()
    if M.conn then
        pcall(function() task.cancel(M.conn) end)
        M.conn = nil
    end
end

function M.toggle(on)
    M.enabled = on
    if on then M.start() else M.stop() end
end

return M
