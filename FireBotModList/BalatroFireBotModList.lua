--- STEAMODDED HEADER
--- MOD_NAME: FireBot Mod List 
--- MOD_ID: FireBotModList
--- PREFIX: FireBotModList
--- MOD_AUTHOR: [LazyTurtle33]
--- MOD_DESCRIPTION: FireBotModList
--- VERSION: 1.0.0
local server_code = [[
local mods = ...
local socket = require("socket")

local server = assert(socket.bind("127.0.0.1", 8080))
server:settimeout(0)

while true do
    local client = server:accept()
    if client then
        client:settimeout(1)
        local line = client:receive()
        if line and line:find("GET /mods") then
            local body = mods
            local response = "HTTP/1.1 200 OK\r\n" ..
                                "Content-Type: application/json\r\n" ..
                                "Content-Length: " .. #body .. "\r\n\r\n" ..
                                body
            client:send(response)
        else
            client:send("HTTP/1.1 404 Not Found\r\n\r\n")
        end
        client:close()
    end
end
]]

local function get_active_mods()
    local mod_list = ""
    for a, mod in pairs(SMODS.Mods) do
        if mod.can_load then
            mod_list = mod_list .. a .. " , "
        end
    end
    mod_list = mod_list:sub(1,-4)
    return mod_list
end

local server = love.thread.newThread(server_code)
server:start(get_active_mods())