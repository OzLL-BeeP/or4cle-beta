local M = {}
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = game:GetService("Players").LocalPlayer

M.enabled = false
M.intervalMin = 10  -- menit
M.mode = "next"     -- "next" = server random, "low" = server low ping

local PLACE_ID = game.PlaceId
local JOBS_API = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"

local function fetchServers()
    local ok, res = pcall(function()
        return game:HttpGet(string.format(JOBS_API, PLACE_ID))
    end)
    if not ok then return {} end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or not data or not data.data then return {} end
    return data.data
end

local function pickServer()
    local servers = fetchServers()
    local valid = {}
    for _, s in ipairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(valid, s)
        end
    end
    if #valid == 0 then return nil end
    if M.mode == "low" then
        table.sort(valid, function(a, b) return (a.ping or 999) < (b.ping or 999) end)
        return valid[1].id
    else
        return valid[math.random(1, #valid)].id
    end
end

function M.hop()
    local jobId = pickServer()
    if not jobId then return false, "No server available" end
    pcall(function()
        TS:TeleportToPlaceInstance(PLACE_ID, jobId, LP)
    end)
    return true, jobId
end

function M.start()
    if M.conn then return end
    M.conn = task.spawn(function()
        while M.enabled do
            local waitSec = M.intervalMin * 60
            for i = 1, waitSec do
                if not M.enabled then return end
                task.wait(1)
            end
            if M.enabled then M.hop() end
        end
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

function M.setInterval(min) M.intervalMin = min end
function M.setMode(m) M.mode = m end

return M
