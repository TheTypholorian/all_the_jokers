LOVELY_INTEGRITY = '143543f2f25a928dc044704a52af4965c2c689982dffe46b1390bd9032d98b57'

--- STEAMODDED CORE
--- MODULE STACKTRACE
-- NOTE: This is a modifed version of https://github.com/ignacio/StackTracePlus/blob/master/src/StackTracePlus.lua
-- Licensed under the MIT License. See https://github.com/ignacio/StackTracePlus/blob/master/LICENSE
-- The MIT License
-- Copyright (c) 2010 Ignacio Burgueño
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- tables
function loadStackTracePlus()
    local _G = _G
    local string, io, debug, coroutine = string, io, debug, coroutine

    -- functions
    local tostring, print, require = tostring, print, require
    local next, assert = next, assert
    local pcall, type, pairs, ipairs = pcall, type, pairs, ipairs
    local error = error

    assert(debug, "Internal: Debug table must be available at this point")

    local io_open = io.open
    local string_gmatch = string.gmatch
    local string_sub = string.sub
    local table_concat = table.concat

    local _M = {
        max_tb_output_len = 140 -- controls the maximum length of the 'stringified' table before cutting with ' (more...)'
    }

    -- this tables should be weak so the elements in them won't become uncollectable
    local m_known_tables = {
        [_G] = "_G (global table)"
    }
    local function add_known_module(name, desc)
        local ok, mod = pcall(require, name)
        if ok then
            m_known_tables[mod] = desc
        end
    end

    add_known_module("string", "string module")
    add_known_module("io", "io module")
    add_known_module("os", "os module")
    add_known_module("table", "table module")
    add_known_module("math", "math module")
    add_known_module("package", "package module")
    add_known_module("debug", "debug module")
    add_known_module("coroutine", "coroutine module")

    -- lua5.2
    add_known_module("bit32", "bit32 module")
    -- luajit
    add_known_module("bit", "bit module")
    add_known_module("jit", "jit module")
    -- lua5.3
    if _VERSION >= "Lua 5.3" then
        add_known_module("utf8", "utf8 module")
    end

    local m_user_known_tables = {}

    local m_known_functions = {}
    for _, name in ipairs { -- Lua 5.2, 5.1
    "assert", "collectgarbage", "dofile", "error", "getmetatable", "ipairs", "load", "loadfile", "next", "pairs",
    "pcall", "print", "rawequal", "rawget", "rawlen", "rawset", "require", "select", "setmetatable", "tonumber",
    "tostring", "type", "xpcall", -- Lua 5.1
    "gcinfo", "getfenv", "loadstring", "module", "newproxy", "setfenv", "unpack" -- TODO: add table.* etc functions
    } do
        if _G[name] then
            m_known_functions[_G[name]] = name
        end
    end

    local m_user_known_functions = {}

    local function safe_tostring(value)
        local ok, err = pcall(tostring, value)
        if ok then
            return err
        else
            return ("<failed to get printable value>: '%s'"):format(err)
        end
    end

    -- Private:
    -- Parses a line, looking for possible function definitions (in a very naïve way)
    -- Returns '(anonymous)' if no function name was found in the line
    local function ParseLine(line)
        assert(type(line) == "string", ("Internal: line \"%s\" is type \"%s\", should be a string"):format(tostring(line), type(line)))
        -- print(line)
        local match = line:match("^%s*function%s+(%w+)")
        if match then
            -- print("+++++++++++++function", match)
            return match
        end
        match = line:match("^%s*local%s+function%s+(%w+)")
        if match then
            -- print("++++++++++++local", match)
            return match
        end
        match = line:match("^%s*local%s+(%w+)%s+=%s+function")
        if match then
            -- print("++++++++++++local func", match)
            return match
        end
        match = line:match("%s*function%s*%(") -- this is an anonymous function
        if match then
            -- print("+++++++++++++function2", match)
            return "(anonymous)"
        end
        return "(anonymous)"
    end

    -- Private:
    -- Tries to guess a function's name when the debug info structure does not have it.
    -- It parses either the file or the string where the function is defined.
    -- Returns '?' if the line where the function is defined is not found
    local function GuessFunctionName(info)
        -- print("guessing function name")
        if type(info.source) == "string" and info.source:sub(1, 1) == "@" then
            local file, err = io_open(info.source:sub(2), "r")
            if not file then
                print("file not found: " .. tostring(err)) -- whoops!
                return "?"
            end
            local line
            for _ = 1, info.linedefined do
                line = file:read("*l")
            end
            if not line then
                print("line not found") -- whoops!
                return "?"
            end
            return ParseLine(line)
        elseif type(info.source) == "string" and info.source:sub(1, 6) == "=[love" then
            return "(LÖVE Function)"
        else
            local line
            local lineNumber = 0
            for l in string_gmatch(info.source, "([^\n]+)\n-") do
                lineNumber = lineNumber + 1
                if lineNumber == info.linedefined then
                    line = l
                    break
                end
            end
            if not line then
                print("line not found") -- whoops!
                return "?"
            end
            return ParseLine(line)
        end
    end

    ---
    -- Dumper instances are used to analyze stacks and collect its information.
    --
    local Dumper = {}

    Dumper.new = function(thread)
        local t = {
            lines = {}
        }
        for k, v in pairs(Dumper) do
            t[k] = v
        end

        t.dumping_same_thread = (thread == coroutine.running())

        -- if a thread was supplied, bind it to debug.info and debug.get
        -- we also need to skip this additional level we are introducing in the callstack (only if we are running
        -- in the same thread we're inspecting)
        if type(thread) == "thread" then
            t.getinfo = function(level, what)
                if t.dumping_same_thread and type(level) == "number" then
                    level = level + 1
                end
                return debug.getinfo(thread, level, what)
            end
            t.getlocal = function(level, loc)
                if t.dumping_same_thread then
                    level = level + 1
                end
                return debug.getlocal(thread, level, loc)
            end
        else
            t.getinfo = debug.getinfo
            t.getlocal = debug.getlocal
        end

        return t
    end

    -- helpers for collecting strings to be used when assembling the final trace
    function Dumper:add(text)
        self.lines[#self.lines + 1] = text
    end
    function Dumper:add_f(fmt, ...)
        self:add(fmt:format(...))
    end
    function Dumper:concat_lines()
        return table_concat(self.lines)
    end

    ---
    -- Private:
    -- Iterates over the local variables of a given function.
    --
    -- @param level The stack level where the function is.
    --
    function Dumper:DumpLocals(level)
        local prefix = "\t "
        local i = 1

        if self.dumping_same_thread then
            level = level + 1
        end

        local name, value = self.getlocal(level, i)
        if not name then
            return
        end
        self:add("\tLocal variables:\r\n")
        while name do
            if type(value) == "number" then
                self:add_f("%s%s = number: %g\r\n", prefix, name, value)
            elseif type(value) == "boolean" then
                self:add_f("%s%s = boolean: %s\r\n", prefix, name, tostring(value))
            elseif type(value) == "string" then
                self:add_f("%s%s = string: %q\r\n", prefix, name, value)
            elseif type(value) == "userdata" then
                self:add_f("%s%s = %s\r\n", prefix, name, safe_tostring(value))
            elseif type(value) == "nil" then
                self:add_f("%s%s = nil\r\n", prefix, name)
            elseif type(value) == "table" then
                if m_known_tables[value] then
                    self:add_f("%s%s = %s\r\n", prefix, name, m_known_tables[value])
                elseif m_user_known_tables[value] then
                    self:add_f("%s%s = %s\r\n", prefix, name, m_user_known_tables[value])
                else
                    local txt = "{"
                    for k, v in pairs(value) do
                        txt = txt .. safe_tostring(k) .. ":" .. safe_tostring(v)
                        if #txt > _M.max_tb_output_len then
                            txt = txt .. " (more...)"
                            break
                        end
                        if next(value, k) then
                            txt = txt .. ", "
                        end
                    end
                    self:add_f("%s%s = %s  %s\r\n", prefix, name, safe_tostring(value), txt .. "}")
                end
            elseif type(value) == "function" then
                local info = self.getinfo(value, "nS")
                local fun_name = info.name or m_known_functions[value] or m_user_known_functions[value]
                if info.what == "C" then
                    self:add_f("%s%s = C %s\r\n", prefix, name,
                        (fun_name and ("function: " .. fun_name) or tostring(value)))
                else
                    local source = info.short_src
                    if source:sub(2, 7) == "string" then
                        source = source:sub(9) -- uno más, por el espacio que viene (string "Baragent.Main", por ejemplo)
                    end
                    -- for k,v in pairs(info) do print(k,v) end
                    fun_name = fun_name or GuessFunctionName(info)
                    self:add_f("%s%s = Lua function '%s' (defined at line %d of chunk %s)\r\n", prefix, name, fun_name,
                        info.linedefined, source)
                end
            elseif type(value) == "thread" then
                self:add_f("%sthread %q = %s\r\n", prefix, name, tostring(value))
            end
            i = i + 1
            name, value = self.getlocal(level, i)
        end
    end

    ---
    -- Public:
    -- Collects a detailed stack trace, dumping locals, resolving function names when they're not available, etc.
    -- This function is suitable to be used as an error handler with pcall or xpcall
    --
    -- @param thread An optional thread whose stack is to be inspected (defaul is the current thread)
    -- @param message An optional error string or object.
    -- @param level An optional number telling at which level to start the traceback (default is 1)
    --
    -- Returns a string with the stack trace and a string with the original error.
    --
    function _M.stacktrace(thread, message, level)
        if type(thread) ~= "thread" then
            -- shift parameters left
            thread, message, level = nil, thread, message
        end

        thread = thread or coroutine.running()

        level = level or 1

        local dumper = Dumper.new(thread)

        local original_error

        if type(message) == "table" then
            dumper:add("an error object {\r\n")
            local first = true
            for k, v in pairs(message) do
                if first then
                    dumper:add("  ")
                    first = false
                else
                    dumper:add(",\r\n  ")
                end
                dumper:add(safe_tostring(k))
                dumper:add(": ")
                dumper:add(safe_tostring(v))
            end
            dumper:add("\r\n}")
            original_error = dumper:concat_lines()
        elseif type(message) == "string" then
            dumper:add(message)
            original_error = message
        end

        dumper:add("\r\n")
        dumper:add [[
Stack Traceback
===============
]]
        -- print(error_message)

        local level_to_show = level
        if dumper.dumping_same_thread then
            level = level + 1
        end

        local info = dumper.getinfo(level, "nSlf")
        while info do
            if info.what == "main" then
                if string_sub(info.source, 1, 1) == "@" then
                    dumper:add_f("(%d) main chunk of file '%s' at line %d\r\n", level_to_show,
                        string_sub(info.source, 2), info.currentline)
                elseif info.source and info.source:sub(1, 1) == "=" then
                    local str = info.source:sub(3, -2)
                    local props = {}
                    -- Split by space
                    for v in string.gmatch(str, "[^%s]+") do
                        table.insert(props, v)
                    end
                    local source = table.remove(props, 1)
                    if source == "love" then
                        dumper:add_f("(%d) main chunk of LÖVE file '%s' at line %d\r\n", level_to_show,
                            table.concat(props, " "):sub(2, -2), info.currentline)
                    elseif source == "SMODS" then
                        local modID = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        if modID == '_' then
                            dumper:add_f("(%d) main chunk of Steamodded file '%s' at line %d\r\n", level_to_show,
                                fileName:sub(2, -2), info.currentline)
                        else
                            dumper:add_f("(%d) main chunk of file '%s' at line %d (from mod with id %s)\r\n",
                                level_to_show, fileName:sub(2, -2), info.currentline, modID)
                        end
                    elseif source == "lovely" then
                        local module = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        dumper:add_f("(%d) main chunk of file '%s' at line %d (from lovely module %s)\r\n",
                            level_to_show, fileName:sub(2, -2), info.currentline, module)
                    else
                        dumper:add_f("(%d) main chunk of %s at line %d\r\n", level_to_show, info.source,
                            info.currentline)
                    end
                else
                    dumper:add_f("(%d) main chunk of %s at line %d\r\n", level_to_show, info.source, info.currentline)
                end
            elseif info.what == "C" then
                -- print(info.namewhat, info.name)
                -- for k,v in pairs(info) do print(k,v, type(v)) end
                local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name or
                                          tostring(info.func)
                dumper:add_f("(%d) %s C function '%s'\r\n", level_to_show, info.namewhat, function_name)
                -- dumper:add_f("%s%s = C %s\r\n", prefix, name, (m_known_functions[value] and ("function: " .. m_known_functions[value]) or tostring(value)))
            elseif info.what == "tail" then
                -- print("tail")
                -- for k,v in pairs(info) do print(k,v, type(v)) end--print(info.namewhat, info.name)
                dumper:add_f("(%d) tail call\r\n", level_to_show)
                dumper:DumpLocals(level)
            elseif info.what == "Lua" then
                local source = info.short_src
                local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name
                if source:sub(2, 7) == "string" then
                    source = source:sub(9)
                end
                local was_guessed = false
                if not function_name or function_name == "?" then
                    -- for k,v in pairs(info) do print(k,v, type(v)) end
                    function_name = GuessFunctionName(info)
                    was_guessed = true
                end
                -- test if we have a file name
                local function_type = (info.namewhat == "") and "function" or info.namewhat
                if info.source and info.source:sub(1, 1) == "@" then
                    dumper:add_f("(%d) Lua %s '%s' at file '%s:%d'%s\r\n", level_to_show, function_type, function_name,
                        info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
                elseif info.source and info.source:sub(1, 1) == '#' then
                    dumper:add_f("(%d) Lua %s '%s' at template '%s:%d'%s\r\n", level_to_show, function_type,
                        function_name, info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
                elseif info.source and info.source:sub(1, 1) == "=" then
                    local str = info.source:sub(3, -2)
                    local props = {}
                    -- Split by space
                    for v in string.gmatch(str, "[^%s]+") do
                        table.insert(props, v)
                    end
                    local source = table.remove(props, 1)
                    if source == "love" then
                        dumper:add_f("(%d) LÖVE %s at file '%s:%d'%s\r\n", level_to_show, function_type,
                            table.concat(props, " "):sub(2, -2), info.currentline, was_guessed and " (best guess)" or "")
                    elseif source == "SMODS" then
                        local modID = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        if modID == '_' then
                            dumper:add_f("(%d) Lua %s '%s' at Steamodded file '%s:%d' %s\r\n", level_to_show,
                                function_type, function_name, fileName:sub(2, -2), info.currentline,
                                was_guessed and " (best guess)" or "")
                        else
                            dumper:add_f("(%d) Lua %s '%s' at file '%s:%d' (from mod with id %s)%s\r\n", level_to_show,
                                function_type, function_name, fileName:sub(2, -2), info.currentline, modID,
                                was_guessed and " (best guess)" or "")
                        end
                    elseif source == "lovely" then
                        local module = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        dumper:add_f("(%d) Lua %s '%s' at file '%s:%d' (from lovely module %s)%s\r\n", level_to_show,
                            function_type, function_name, fileName:sub(2, -2), info.currentline, module,
                            was_guessed and " (best guess)" or "")
                    else
                        dumper:add_f("(%d) Lua %s '%s' at line %d of chunk '%s'\r\n", level_to_show, function_type,
                            function_name, info.currentline, source)
                    end
                else
                    dumper:add_f("(%d) Lua %s '%s' at line %d of chunk '%s'\r\n", level_to_show, function_type,
                        function_name, info.currentline, source)
                end
                dumper:DumpLocals(level)
            else
                dumper:add_f("(%d) unknown frame %s\r\n", level_to_show, info.what)
            end

            level = level + 1
            level_to_show = level_to_show + 1
            info = dumper.getinfo(level, "nSlf")
        end

        return dumper:concat_lines(), original_error
    end

    --
    -- Adds a table to the list of known tables
    function _M.add_known_table(tab, description)
        if m_known_tables[tab] then
            error("Cannot override an already known table")
        end
        m_user_known_tables[tab] = description
    end

    --
    -- Adds a function to the list of known functions
    function _M.add_known_function(fun, description)
        if m_known_functions[fun] then
            error("Cannot override an already known function")
        end
        m_user_known_functions[fun] = description
    end

    return _M
end

-- Note: The below code is not from the original StackTracePlus.lua
local stackTraceAlreadyInjected = false

function getDebugInfoForCrash()
    local version = VERSION
    if not version or type(version) ~= "string" then
        local versionFile = love.filesystem.read("version.jkr")
        if versionFile then
            version = versionFile:match("[^\n]*") .. " (best guess)"
        else
            version = "???"
        end
    end
    local modded_version = MODDED_VERSION
    if not modded_version or type(modded_version) ~= "string" then
        local moddedSuccess, reqVersion = pcall(require, "SMODS.version")
        if moddedSuccess and type(reqVersion) == "string" then
            modded_version = reqVersion
        else
            modded_version = "???"
        end
    end

    local info = "Additional Context:\nBalatro Version: " .. version .. "\nModded Version: " ..
                     (modded_version)
    local major, minor, revision, codename = love.getVersion()
    info = info .. string.format("\nLÖVE Version: %d.%d.%d", major, minor, revision)
    local lovely_success, lovely = pcall(require, "lovely")
    if lovely_success then
        info = info .. "\nLovely Version: " .. lovely.version
    end
	info = info .. "\nPlatform: " .. (love.system.getOS() or "???")
    if SMODS and SMODS.Mods then
        local mod_strings = ""
        local lovely_strings = ""
        local i = 1
        local lovely_i = 1
        for _, v in pairs(SMODS.Mods) do
            if (v.can_load and (not v.meta_mod or v.lovely_only)) or (v.lovely and not v.can_load and not v.disabled) then
                if v.lovely_only or (v.lovely and not v.can_load) then
                    lovely_strings = lovely_strings .. "\n    " .. lovely_i .. ": " .. v.name
                    lovely_i = lovely_i + 1
                    if not v.can_load then
                        lovely_strings = lovely_strings .. "\n        Has Steamodded mod that failed to load."
                        if #v.load_issues.dependencies > 0 then
                            lovely_strings = lovely_strings .. "\n        Missing Dependencies:"
                            for k, v in ipairs(v.load_issues.dependencies) do
                                lovely_strings = lovely_strings .. "\n            " .. k .. ". " .. v
                            end
                        end
                        if #v.load_issues.conflicts > 0 then
                            lovely_strings = lovely_strings .. "\n        Conflicts:"
                            for k, v in ipairs(v.load_issues.conflicts) do
                                lovely_strings = lovely_strings .. "\n            " .. k .. ". " .. v
                            end
                        end
                        if v.load_issues.outdated then
                            lovely_strings = lovely_strings .. "\n        Outdated Mod."
                        end
                        if v.load_issues.main_file_not_found then
                            lovely_strings = lovely_strings .. "\n        Main file not found. (" .. v.main_file ..")"
                        end
                    end
                else
                    mod_strings = mod_strings .. "\n    " .. i .. ": " .. v.name .. " by " ..
                                      table.concat(v.author, ", ") .. " [ID: " .. v.id ..
                                      (v.priority ~= 0 and (", Priority: " .. v.priority) or "") ..
                                      (v.version and v.version ~= '0.0.0' and (", Version: " .. v.version) or "") ..
                                      (v.lovely and (", Uses Lovely") or "") .. "]"
                    i = i + 1
                    local debugInfo = v.debug_info
                    if debugInfo then
                        if type(debugInfo) == "string" then
                            if #debugInfo ~= 0 then
                                mod_strings = mod_strings .. "\n        " .. debugInfo
                            end
                        elseif type(debugInfo) == "table" then
                            for kk, vv in pairs(debugInfo) do
                                if type(vv) ~= 'nil' then
                                    vv = tostring(vv)
                                end
                                if #vv ~= 0 then
                                    mod_strings = mod_strings .. "\n        " .. kk .. ": " .. vv
                                end
                            end
                        end
                    end
                end
            end
        end
        info = info .. "\nSteamodded Mods:" .. mod_strings .. "\nLovely Mods:" .. lovely_strings
    end
    return info
end

function injectStackTrace()
    if (stackTraceAlreadyInjected) then
        return
    end
    stackTraceAlreadyInjected = true
    local STP = loadStackTracePlus()
    local utf8 = require("utf8")

    -- Modifed from https://love2d.org/wiki/love.errorhandler
    function love.errorhandler(msg)
        msg = tostring(msg)

        if not sendErrorMessage then
            function sendErrorMessage(msg)
                print(msg)
            end
        end
        if not sendInfoMessage then
            function sendInfoMessage(msg)
                print(msg)
            end
        end

        sendErrorMessage("Oops! The game crashed\n" .. STP.stacktrace(msg), 'StackTrace')

        if not love.window or not love.graphics or not love.event then
            return
        end

        if not love.graphics.isCreated() or not love.window.isOpen() then
            local success, status = pcall(love.window.setMode, 800, 600)
            if not success or not status then
                return
            end
        end

        -- Reset state.
        if love.mouse then
            love.mouse.setVisible(true)
            love.mouse.setGrabbed(false)
            love.mouse.setRelativeMode(false)
            if love.mouse.isCursorSupported() then
                love.mouse.setCursor()
            end
        end
        if love.joystick then
            -- Stop all joystick vibrations.
            for i, v in ipairs(love.joystick.getJoysticks()) do
                v:setVibration()
            end
        end
        if love.audio then
            love.audio.stop()
        end

        love.graphics.reset()
        local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

        local background = {0, 0, 1}
        if G and G.C and G.C.BLACK then
            background = G.C.BLACK
        end
        love.graphics.clear(background)
        love.graphics.origin()

        local trace = STP.stacktrace("", 3)

        local sanitizedmsg = {}
        for char in msg:gmatch(utf8.charpattern) do
            table.insert(sanitizedmsg, char)
        end
        sanitizedmsg = table.concat(sanitizedmsg)

        local err = {}

        table.insert(err, "Oops! The game crashed:")
        if sanitizedmsg:find("Syntax error: game.lua:4: '=' expected near 'Game'") then
            table.insert(err,
                'Duplicate installation of Steamodded detected! Please clean your installation: Steam Library > Balatro > Properties > Installed Files > Verify integrity of game files.')
        elseif sanitizedmsg:find("Syntax error: game.lua:%d+: duplicate label 'continue'") then
            table.insert(err,
                'Duplicate installation of Steamodded detected! Please remove the duplicate steamodded/smods folder in your mods folder.')
        else
            table.insert(err, sanitizedmsg)
        end
        if #sanitizedmsg ~= #msg then
            table.insert(err, "Invalid UTF-8 string in error message.")
        end

        if V and SMODS and SMODS.save_game and V(SMODS.save_game or '0.0.0') ~= V(SMODS.version or '0.0.0') then
            table.insert(err, 'This crash may be caused by continuing a run that was started on a previous version of Steamodded. Try creating a new run.')
        end

        if V and V(MODDED_VERSION or '0.0.0') ~= V(RELEASE_VERSION or '0.0.0') then
            table.insert(err, '\n\nDevelopment version of Steamodded detected! If you are not actively developing a mod, please try using the latest release instead.\n\n')
        end

        if not V then
            table.insert(err, '\nA bad lovely patch has resulted in this crash.\n')
        end

        local success, msg = pcall(getDebugInfoForCrash)
        if success and msg then
            table.insert(err, '\n' .. msg)
            sendInfoMessage(msg, 'StackTrace')
        else
            table.insert(err, "\n" .. "Failed to get additional context :/")
            sendErrorMessage("Failed to get additional context :/\n" .. msg, 'StackTrace')
        end

        for l in trace:gmatch("(.-)\n") do
            table.insert(err, l)
        end

        local p = table.concat(err, "\n")

        p = p:gsub("\t", "")
        p = p:gsub("%[string \"(.-)\"%]", "%1")

        local scrollOffset = 0
        local endHeight = 0
        love.keyboard.setKeyRepeat(true)

        local function scrollDown(amt)
            if amt == nil then
                amt = 18
            end
            scrollOffset = scrollOffset + amt
            if scrollOffset > endHeight then
                scrollOffset = endHeight
            end
        end

        local function scrollUp(amt)
            if amt == nil then
                amt = 18
            end
            scrollOffset = scrollOffset - amt
            if scrollOffset < 0 then
                scrollOffset = 0
            end
        end

        local pos = 70
        local arrowSize = 20

        local function calcEndHeight()
            local font = love.graphics.getFont()
            local rw, lines = font:getWrap(p, love.graphics.getWidth() - pos * 2)
            local lineHeight = font:getHeight()
            local atBottom = scrollOffset == endHeight and scrollOffset ~= 0
            endHeight = #lines * lineHeight - love.graphics.getHeight() + pos * 2
            if (endHeight < 0) then
                endHeight = 0
            end
            if scrollOffset > endHeight or atBottom then
                scrollOffset = endHeight
            end
        end

        local function draw()
            if not love.graphics.isActive() then
                return
            end
            love.graphics.clear(background)
            calcEndHeight()
            love.graphics.printf(p, pos, pos - scrollOffset, love.graphics.getWidth() - pos * 2)
            if scrollOffset ~= endHeight then
                love.graphics.polygon("fill", love.graphics.getWidth() - (pos / 2),
                    love.graphics.getHeight() - arrowSize, love.graphics.getWidth() - (pos / 2) + arrowSize,
                    love.graphics.getHeight() - (arrowSize * 2), love.graphics.getWidth() - (pos / 2) - arrowSize,
                    love.graphics.getHeight() - (arrowSize * 2))
            end
            if scrollOffset ~= 0 then
                love.graphics.polygon("fill", love.graphics.getWidth() - (pos / 2), arrowSize,
                    love.graphics.getWidth() - (pos / 2) + arrowSize, arrowSize * 2,
                    love.graphics.getWidth() - (pos / 2) - arrowSize, arrowSize * 2)
            end
            love.graphics.present()
        end

        local fullErrorText = p
        local function copyToClipboard()
            if not love.system then
                return
            end
            love.system.setClipboardText(fullErrorText)
            p = p .. "\nCopied to clipboard!"
        end

        p = p .. "\n\nPress ESC to exit\nPress R to restart the game"
        if love.system then
            p = p .. "\nPress Ctrl+C or tap to copy this error"
        end

        if G then
            -- Kill threads (makes restarting possible)
            if G.SOUND_MANAGER and G.SOUND_MANAGER.channel then
                G.SOUND_MANAGER.channel:push({
                    type = 'kill'
                })
            end
            if G.SAVE_MANAGER and G.SAVE_MANAGER.channel then
                G.SAVE_MANAGER.channel:push({
                    type = 'kill'
                })
            end
            if G.HTTP_MANAGER and G.HTTP_MANAGER.channel then
                G.HTTP_MANAGER.channel:push({
                    type = 'kill'
                })
            end
        end

        return function()
            love.event.pump()

            for e, a, b, c in love.event.poll() do
                if e == "quit" then
                    return 1
                elseif e == "keypressed" and a == "escape" then
                    return 1
                elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                    copyToClipboard()
                elseif e == "keypressed" and a == "r" then
                    SMODS.restart_game()
                elseif e == "keypressed" and a == "down" then
                    scrollDown()
                elseif e == "keypressed" and a == "up" then
                    scrollUp()
                elseif e == "keypressed" and a == "pagedown" then
                    scrollDown(love.graphics.getHeight())
                elseif e == "keypressed" and a == "pageup" then
                    scrollUp(love.graphics.getHeight())
                elseif e == "keypressed" and a == "home" then
                    scrollOffset = 0
                elseif e == "keypressed" and a == "end" then
                    scrollOffset = endHeight
                elseif e == "wheelmoved" then
                    scrollUp(b * 20)
                elseif e == "gamepadpressed" and b == "dpdown" then
                    scrollDown()
                elseif e == "gamepadpressed" and b == "dpup" then
                    scrollUp()
                elseif e == "gamepadpressed" and b == "a" then
                    return "restart"
                elseif e == "gamepadpressed" and b == "x" then
                    copyToClipboard()
                elseif e == "gamepadpressed" and (b == "b" or b == "back" or b == "start") then
                    return 1
                elseif e == "touchpressed" then
                    local name = love.window.getTitle()
                    if #name == 0 or name == "Untitled" then
                        name = "Game"
                    end
                    local buttons = {"OK", "Cancel", "Restart"}
                    if love.system then
                        buttons[4] = "Copy to clipboard"
                    end
                    local pressed = love.window.showMessageBox("Quit " .. name .. "?", "", buttons)
                    if pressed == 1 then
                        return 1
                    elseif pressed == 3 then
                        return "restart"
                    elseif pressed == 4 then
                        copyToClipboard()
                    end
                end
            end

            draw()

            if love.timer then
                love.timer.sleep(0.1)
            end
        end

    end
end

injectStackTrace()

-- ----------------------------------------------
-- --------MOD CORE API STACKTRACE END-----------

if (love.system.getOS() == 'OS X' ) and (jit.arch == 'arm64' or jit.arch == 'arm') then jit.off() end
do
    local logger = require("debugplus.logger")
    logger.registerLogHandler()
end
require "engine/object"
require "bit"
require "engine/string_packer"
require "engine/controller"
require "back"
require "tag"
require "engine/event"
require "engine/node"
require "engine/moveable"
require "engine/sprite"
require "engine/animatedsprite"
require "functions/misc_functions"
require "game"
require "globals"
require "engine/ui"
require "functions/UI_definitions"
require "functions/state_events"
require "functions/common_events"
require "functions/button_callbacks"
require "functions/misc_functions"
require "functions/test_functions"
require "card"
require "cardarea"
require "blind"
require "card_character"
require "engine/particles"
require "engine/text"
require "challenges"

math.randomseed( G.SEED )

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
	local dt_smooth = 1/100
	local run_time = 0

	-- Main loop time.
	return function()
		run_time = love.timer.getTime()
		-- Process events.
		if love.event and G and G.CONTROLLER then
			love.event.pump()
			local _n,_a,_b,_c,_d,_e,_f,touched
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				if name == 'touchpressed' then
					touched = true
				elseif name == 'mousepressed' then 
					_n,_a,_b,_c,_d,_e,_f = name,a,b,c,d,e,f
				else
					love.handlers[name](a,b,c,d,e,f)
				end
			end
			if _n then 
				love.handlers['mousepressed'](_a,_b,_c,touched)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
		dt_smooth = math.min(0.8*dt_smooth + 0.2*dt, 0.1)
		-- Call update and draw
		if love.update then love.update(dt_smooth) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			if love.draw then love.draw() end
			love.graphics.present()
		end

		run_time = math.min(love.timer.getTime() - run_time, 0.1)
		G.FPS_CAP = G.FPS_CAP or 500
		if run_time < 1./G.FPS_CAP then love.timer.sleep(1./G.FPS_CAP - run_time) end
	end
end

Cryptid = {}
Cryptid.aliases = {}
Cryptid.pointerblist = {}
Cryptid.pointerblistrarity = {}
Cryptid.mod_gameset_whitelist = {}
Cryptid.ascension_numbers = {}

Cryptid.pin_debuff = {}
Cryptid.circus_rarities = {
	--format {base_mult = ..., loc_key = ..., rarity=..., order=...}
}

function cry_format(...)
	return ...
end

-- These ones are deprecated, they do not do anything and are just here to prevent crashes
Cryptid.memepack = {}
Cryptid.food = {}
Cryptid.M_jokers = {}
Cryptid.Megavouchers = {}
Kino = {}
Kino.jokers = {}
function love.load() 
	G:start_up()
	--Steam integration
	local os = love.system.getOS()
	if os == 'OS X' or os == 'Windows' or os == 'Linux' then
		local st = nil
		--To control when steam communication happens, make sure to send updates to steam as little as possible
		local cwd = NFS.getWorkingDirectory()
		NFS.setWorkingDirectory(love.filesystem.getSourceBaseDirectory())
		if os == 'OS X' or os == 'Linux' then
			local dir = love.filesystem.getSourceBaseDirectory()
			local old_cpath = package.cpath
			package.cpath = package.cpath .. ';' .. dir .. '/?.so'
			local success, _st = pcall(require, 'luasteam')
			if success then st = _st else sendWarnMessage(_st, "LuaSteam"); st = {} end
			package.cpath = old_cpath
		else
			local success, _st = pcall(require, 'luasteam')
			if success then st = _st else sendWarnMessage(_st, "LuaSteam"); st = {} end
		end

		st.send_control = {
			last_sent_time = -200,
			last_sent_stage = -1,
			force = false,
		}
		if not (st.init and st:init()) then
			st = nil
		end
		NFS.setWorkingDirectory(cwd)
		--Set up the render window and the stage for the splash screen, then enter the gameloop with :update
		G.STEAM = st
	else
	end

	--Set the mouse to invisible immediately, this visibility is handled in the G.CONTROLLER
	love.mouse.setVisible(false)
end

function love.quit()
	--Steam integration
	if G.SOUND_MANAGER then G.SOUND_MANAGER.channel:push({type = 'stop'}) end
	if G.STEAM then G.STEAM:shutdown() end
end

function love.update( dt )
Supf_UpdateEverything()
	--Perf monitoring checkpoint
    timer_checkpoint(nil, 'update', true)
    G:update(dt)
end

function love.draw()
	--Perf monitoring checkpoint
    timer_checkpoint(nil, 'draw', true)
	G:draw()
	do
	    local console = require("debugplus.console")
	    console.doConsoleRender()
	    timer_checkpoint('DebugPlus Console', 'draw')
	end
end

function love.keypressed(key)
if Handy.controller.process_key(key, false) then return end
	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadpressed(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_press(key)
	end
end

function love.keyreleased(key)
if Handy.controller.process_key(key, true) then return end
	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadreleased(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_release(key)
	end
end

function love.gamepadpressed(joystick, button)
	button = G.button_mapping[button] or button
	G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

function love.mousepressed(x, y, button, touch)
if Handy.controller.process_mouse(button, false, touch) then return end
    G.CONTROLLER:set_HID_flags(touch and 'touch' or 'mouse')
    if button == 1 then 
		G.CONTROLLER:queue_L_cursor_press(x, y)
	end
	if button == 2 then
		G.CONTROLLER:queue_R_cursor_press(x, y)
	end
end


function love.mousereleased(x, y, button)
if Handy.controller.process_mouse(button, true) then return end
    if button == 1 then G.CONTROLLER:L_cursor_release(x, y) end
end

function love.mousemoved(x, y, dx, dy, istouch)
	G.CONTROLLER.last_touch_time = G.CONTROLLER.last_touch_time or -1
	if next(love.touch.getTouches()) ~= nil then
		G.CONTROLLER.last_touch_time = G.TIMERS.UPTIME
	end
    G.CONTROLLER:set_HID_flags(G.CONTROLLER.last_touch_time > G.TIMERS.UPTIME - 0.2 and 'touch' or 'mouse')
end

function love.joystickaxis( joystick, axis, value )
    if math.abs(value) > 0.2 and joystick:isGamepad() then
		G.CONTROLLER:set_gamepad(joystick)
        G.CONTROLLER:set_HID_flags('axis')
    end
end

if false then
	if G.F_NO_ERROR_HAND then return end
	msg = tostring(msg)

	if G.SETTINGS.crashreports and _RELEASE_MODE and G.F_CRASH_REPORTS then 
		local http_thread = love.thread.newThread([[
			local https = require('https')
			CHANNEL = love.thread.getChannel("http_channel")

			while true do
				--Monitor the channel for any new requests
				local request = CHANNEL:demand()
				if request then
					https.request(request)
				end
			end
		]])
		local http_channel = love.thread.getChannel('http_channel')
		http_thread:start()
		local httpencode = function(str)
			local char_to_hex = function(c)
				return string.format("%%%02X", string.byte(c))
			end
			str = str:gsub("\n", "\r\n"):gsub("([^%w _%%%-%.~])", char_to_hex):gsub(" ", "+")
			return str
		end
		

		local error = msg
		local file = string.sub(msg, 0,  string.find(msg, ':'))
		local function_line = string.sub(msg, string.len(file)+1)
		function_line = string.sub(function_line, 0, string.find(function_line, ':')-1)
		file = string.sub(file, 0, string.len(file)-1)
		local trace = debug.traceback()
		local boot_found, func_found = false, false
		for l in string.gmatch(trace, "(.-)\n") do
			if string.match(l, "boot.lua") then
				boot_found = true
			elseif boot_found and not func_found then
				func_found = true
				trace = ''
				function_line = string.sub(l, string.find(l, 'in function')+12)..' line:'..function_line
			end

			if boot_found and func_found then 
				trace = trace..l..'\n'
			end
		end

		http_channel:push('https://958ha8ong3.execute-api.us-east-2.amazonaws.com/?error='..httpencode(error)..'&file='..httpencode(file)..'&function_line='..httpencode(function_line)..'&trace='..httpencode(trace)..'&version='..(G.VERSION))
	end

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

	love.graphics.clear(G.C.BLACK)
	love.graphics.origin()


	local p = 'Oops! Something went wrong:\n'..msg..'\n\n'..(not _RELEASE_MODE and debug.traceback() or G.SETTINGS.crashreports and
		'Since you are opted in to sending crash reports, LocalThunk HQ was sent some useful info about what happened.\nDon\'t worry! There is no identifying or personal information. If you would like\nto opt out, change the \'Crash Report\' setting to Off' or
		'Crash Reports are set to Off. If you would like to send crash reports, please opt in in the Game settings.\nThese crash reports help us avoid issues like this in the future')

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.push()
		love.graphics.clear(G.C.BLACK)
		love.graphics.setColor(1., 1., 1., 1.)
		love.graphics.printf(p, font, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.pop()
		love.graphics.present()

	end

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "escape" then
				return
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end

function love.resize(w, h)
	if w/h < 1 then --Dont allow the screen to be too square, since pop in occurs above and below screen
		h = w/1
	end

	--When the window is resized, this code resizes the Canvas, then places the 'room' or gamearea into the middle without streching it
	if w/h < G.window_prev.orig_ratio then
		G.TILESCALE = G.window_prev.orig_scale*w/G.window_prev.w
	else
		G.TILESCALE = G.window_prev.orig_scale*h/G.window_prev.h
	end

	if G.ROOM then
		G.ROOM.T.w = G.TILE_W
		G.ROOM.T.h = G.TILE_H
		G.ROOM_ATTACH.T.w = G.TILE_W
		G.ROOM_ATTACH.T.h = G.TILE_H		

		if w/h < G.window_prev.orig_ratio then
			G.ROOM.T.x = G.ROOM_PADDING_W
			G.ROOM.T.y = (h/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.h+G.ROOM_PADDING_H))/2 + G.ROOM_PADDING_H/2
		else
			G.ROOM.T.y = G.ROOM_PADDING_H
			G.ROOM.T.x = (w/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.w+G.ROOM_PADDING_W))/2 + G.ROOM_PADDING_W/2
		end

		G.ROOM_ORIG = {
            x = G.ROOM.T.x,
            y = G.ROOM.T.y,
            r = G.ROOM.T.r
        }
		SUPF.WINDOW_PAD = {x = G.ROOM_ORIG.x, y = G.ROOM_ORIG.y}

		if G.buttons then G.buttons:recalculate() end
		if G.HUD then G.HUD:recalculate() end
	end

	G.WINDOWTRANS = {
		x = 0, y = 0,
		w = G.TILE_W+2*G.ROOM_PADDING_W, 
		h = G.TILE_H+2*G.ROOM_PADDING_H,
		real_window_w = w,
		real_window_h = h
	}

	G.CANV_SCALE = 1

	if love.system.getOS() == 'Windows' and false then --implement later if needed
		local render_w, render_h = love.window.getDesktopDimensions(G.SETTINGS.WINDOW.selcted_display)
		local unscaled_dims = love.window.getFullscreenModes(G.SETTINGS.WINDOW.selcted_display)[1]

		local DPI_scale = math.floor((0.5*unscaled_dims.width/render_w + 0.5*unscaled_dims.height/render_h)*500 + 0.5)/500

		if DPI_scale > 1.1 then
			G.CANV_SCALE = 1.5

			G.AA_CANVAS = love.graphics.newCanvas(G.WINDOWTRANS.real_window_w*G.CANV_SCALE, G.WINDOWTRANS.real_window_h*G.CANV_SCALE, {type = '2d', readable = true})
			G.AA_CANVAS:setFilter('linear', 'linear')
		else
			G.AA_CANVAS = nil
		end
	end

	G.CANVAS = love.graphics.newCanvas(w*G.CANV_SCALE, h*G.CANV_SCALE, {type = '2d', readable = true})
	G.CANVAS:setFilter('linear', 'linear')
end 

--- STEAMODDED CORE
--- MODULE CORE

SMODS = {}
MODDED_VERSION = require'SMODS.version'
RELEASE_VERSION = require'SMODS.release'
SMODS.id = 'Steamodded'
SMODS.version = MODDED_VERSION:gsub('%-STEAMODDED', '')
SMODS.can_load = true
SMODS.meta_mod = true
SMODS.config_file = 'config.lua'

-- Include lovely and nativefs modules
local nativefs = require "nativefs"
local lovely = require "lovely"
local json = require "json"

local lovely_mod_dir = lovely.mod_dir:gsub("/$", "")
NFS = nativefs
-- make lovely_mod_dir an absolute path.
-- respects symlink/.. combos
NFS.setWorkingDirectory(lovely_mod_dir)
lovely_mod_dir = NFS.getWorkingDirectory()
-- make sure NFS behaves the same as love.filesystem
NFS.setWorkingDirectory(love.filesystem.getSaveDirectory())

JSON = json

local function set_mods_dir()
    local love_dirs = {
        love.filesystem.getSaveDirectory(),
        love.filesystem.getSourceBaseDirectory()
    }
    for _, love_dir in ipairs(love_dirs) do
        if lovely_mod_dir:sub(1, #love_dir) == love_dir then
            -- relative path from love_dir
            SMODS.MODS_DIR = lovely_mod_dir:sub(#love_dir+2)
            NFS.setWorkingDirectory(love_dir)
            return
        end
    end
    SMODS.MODS_DIR = lovely_mod_dir
end
set_mods_dir()

local function find_self(directory, target_filename, target_line, depth)
    depth = depth or 1
    if depth > 3 then return end
    for _, filename in ipairs(NFS.getDirectoryItems(directory)) do
        local file_path = directory .. "/" .. filename
        local file_type = NFS.getInfo(file_path).type
        if file_type == 'directory' or file_type == 'symlink' then
            local f = find_self(file_path, target_filename, target_line, depth+1)
            if f then return f end
        elseif filename == target_filename then
            local first_line = NFS.read(file_path):match('^(.-)\n')
            if first_line == target_line then
                -- use parent directory
                return directory:match('^(.+/)')
            end
        end
    end
end

SMODS.path = find_self(SMODS.MODS_DIR, 'core.lua', '--- STEAMODDED CORE')

for _, path in ipairs {
    "src/ui.lua",
    "src/index.lua",
    "src/utils.lua",
    "src/overrides.lua",
    "src/game_object.lua",
    "src/logging.lua",
    "src/compat_0_9_8.lua",
    "src/loader.lua",
} do
    assert(load(NFS.read(SMODS.path..path), ('=[SMODS _ "%s"]'):format(path)))()
end

sendInfoMessage("Steamodded v" .. SMODS.version, "SMODS")

to_big = to_big or function(x)
	return x
end

if not Handy then
	Handy = setmetatable({
		version = "1.5.1i",

		last_clicked_area = nil,
		last_clicked_card = nil,

		last_hovered_area = nil,
		last_hovered_card = nil,

		modules = {},

		meta = {
			["1.4.1b_patched_select_blind_and_skip"] = true,
			["1.5.0_update"] = true,
			["1.5.1a_multiplayer_check"] = true,
		},
	}, {})

	function Handy.is_stop_use()
		return G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)
	end

	function Handy.is_in_multiplayer()
		return not not (MP and MP.LOBBY and MP.LOBBY.code)
	end

	function Handy.register_module(key, mod_module)
		Handy.modules[key] = mod_module
	end

	--

	require("handy/utils")
	require("handy/config")
	require("handy/fake_events")
	require("handy/controller")
	require("handy/ui")
	require("handy/presets")

	require("handy/controls/presets_switch")
	require("handy/controls/insta_cash_out")
	require("handy/controls/insta_booster_skip")
	require("handy/controls/deselect_hand")
	require("handy/controls/show_deck_preview")
	require("handy/controls/regular_keybinds")
	require("handy/controls/insta_highlight")
	require("handy/controls/insta_highlight_entire_f_hand")
	require("handy/controls/insta_actions")
	require("handy/controls/move_highlight")
	require("handy/controls/speed_multiplier")
	require("handy/controls/nopeus_interaction")
	require("handy/controls/not_just_yet_interaction")
	require("handy/controls/animation_skip")
	require("handy/controls/scoring_hold")

	require("handy/controls/dangerous_actions")

	require("handy/controls/misc")

	--

	local init_localization_ref = init_localization
	function init_localization(...)
		if not G.localization.__handy_injected then
			local en_loc = require("handy/localization/en-us")
			Handy.utils.table_merge(G.localization, en_loc)
			Handy.UI.cache_config_dictionary_search()
			if G.SETTINGS.language ~= "en-us" then
				local success, current_loc = pcall(function()
					return require("handy/localization/" .. G.SETTINGS.language)
				end)
				-- local missing_keys = Handy.utils.deep_missing_keys(en_loc, current_loc)
				-- for _, missing_key in ipairs(missing_keys) do
				-- 	print("Missing key: " .. missing_key)
				-- end
				if success and current_loc then
					Handy.utils.table_merge(G.localization, current_loc)
					Handy.UI.cache_config_dictionary_search(true)
				end
			end
			G.localization.__handy_injected = true
		end
		return init_localization_ref(...)
	end

	local card_area_emplace_ref = CardArea.emplace
	function CardArea:emplace(...)
		self.cards = self.cards or {}
		return card_area_emplace_ref(self, ...)
	end

	local card_area_align_cards_ref = CardArea.align_cards
	function CardArea:align_cards(...)
		self.children = self.children or {}
		return card_area_align_cards_ref(self, ...)
	end

	local game_start_up_ref = Game.start_up
	function Game:start_up(...)
		local result = game_start_up_ref(self, ...)
		G.CONTROLLER.saved_axis_cursor_speed = G.CONTROLLER.axis_cursor_speed
		G.CONTROLLER.axis_cursor_speed = G.CONTROLLER.saved_axis_cursor_speed * Handy.cc.controller_sensivity.mult
		G.E_MANAGER:add_event(Event({
			no_delete = true,
			blocking = false,
			func = function()
				G.E_MANAGER:add_event(Event({
					no_delete = true,
					blocking = false,
					func = function()
						Handy.speed_multiplier.load_default_value()
						Handy.animation_skip.load_default_value()
						return true
					end,
				}))
				return true
			end,
		}))
		return result
	end

	--

	function Handy.emplace_steamodded()
		if Handy.current_mod then
			return
		end
		Handy.current_mod = (Handy_Preload and Handy_Preload.current_mod) or SMODS.current_mod
		Handy.UI.show_options_button = not Handy.cc.hide_options_button.enabled

		-- Config tabs
		Handy.current_mod.config_tab = function()
			return Handy.UI.get_options_tabs()[1].tab_definition_function
		end
		Handy.current_mod.extra_tabs = function()
			local result = Handy.UI.get_options_tabs()
			table.remove(result, 1)
			return result
		end

		-- NotJustYet
		G.E_MANAGER:add_event(Event({
			func = function()
				G.njy_keybind = nil
				return true
			end,
		}))

		-- Animation skip setup
		local smods_calculate_effect_ref = SMODS.calculate_effect or function() end
		function SMODS.calculate_effect(effect, ...)
			if Handy.animation_skip.should_skip_animation() then
				effect.juice_card = nil
			end
			return smods_calculate_effect_ref(effect, ...)
		end
		if (SMODS.Mods and SMODS.Mods["Talisman"] or {}).can_load then
			local nuGC_ref = nuGC
			function nuGC(time_budget, ...)
				if G.STATE == G.STATES.HAND_PLAYED then
					time_budget = 0.0333
				end
				return nuGC_ref(time_budget, ...)
			end
		end

		if Handy_Preload then
			Handy_Preload = nil
		end
	end

	if Handy_Preload then
		Handy.emplace_steamodded()
	end
end

local lovely = require("lovely")
local nfs = require("nativefs")

Brainstorm = {}

Brainstorm.VERSION = "Brainstorm v2.2.0-alpha"

Brainstorm.SMODS = nil

local saveKeys = { "1", "2", "3", "4", "5" }

Brainstorm.config = {
  enable = true,
  keybind_autoreroll = "r",
  keybinds = {
    options = "t",
    modifier = "lctrl",
    f_reroll = "r",
    a_reroll = "a",
    s_state = "z",
    l_state = "x",
  },
  ar_filters = {
    pack = {},
    pack_id = 1,
    voucher_name = "",
    voucher_id = 1,
    tag_name = "tag_charm",
    tag_id = 2,
    soul_skip = 1,
    inst_observatory = false,
    inst_perkeo = false,
    copy_money = false,
    bean = false,
    burglar = false,
    retcon = false,
    custom_filter_name = "no_filter",
    custom_filter_id = 1
  },
  ar_prefs = {
    spf_id = 3,
    spf_int = 1000,
  },
}

Brainstorm.ar_timer = 0
Brainstorm.ar_frames = 0
Brainstorm.ar_text = nil
Brainstorm.ar_active = false
Brainstorm.AR_INTERVAL = 0.01

-- Cache frequently used functions
local math_abs = math.abs
local string_format = string.format
local string_lower = string.lower

local function findBrainstormDirectory(directory)
  for _, item in ipairs(nfs.getDirectoryItems(directory)) do
    local itemPath = directory .. "/" .. item
    if
      nfs.getInfo(itemPath, "directory")
      and string_lower(item):find("brainstorm")
    then
      return itemPath
    end
  end
  return nil
end

local function fileExists(filePath)
  return nfs.getInfo(filePath) ~= nil
end

function Brainstorm.loadConfig()
  local configPath = Brainstorm.PATH .. "/config.lua"
  if not fileExists(configPath) then
    Brainstorm.writeConfig()
  else
    local configFile, err = nfs.read(configPath)
    if not configFile then
      error("Failed to read config file: " .. (err or "unknown error"))
    end
    Brainstorm.config = STR_UNPACK(configFile) or Brainstorm.config
  end
end

function Brainstorm.writeConfig()
  local configPath = Brainstorm.PATH .. "/config.lua"
  local success, err = nfs.write(configPath, STR_PACK(Brainstorm.config))
  if not success then
    error("Failed to write config file: " .. (err or "unknown error"))
  end
end

function Brainstorm.init()
  Brainstorm.PATH = findBrainstormDirectory(lovely.mod_dir)
  Brainstorm.loadConfig()
  assert(load(nfs.read(Brainstorm.PATH .. "/UI/ui.lua")))()
end

local key_press_update_ref = Controller.key_press_update
function Controller:key_press_update(key, dt)
    local keybinds = Brainstorm.config.keybinds
    key_press_update_ref(self, key, dt)
    for i, k in ipairs(saveKeys) do
        --  SaveState
        if key == k and love.keyboard.isDown(keybinds.s_state) then
            if G.STAGE == G.STAGES.RUN then
                compress_and_save(G.SETTINGS.profile .. "/" .. "saveState" .. k .. ".jkr", G.ARGS.save_run)
                saveManagerAlert("Saved state to slot [" .. k .. "]")
            end
        end
        --  LoadState
        if key == k and love.keyboard.isDown(keybinds.l_state) then
            G:delete_run()
            G.SAVED_GAME = get_compressed(G.SETTINGS.profile .. "/" .. "saveState" .. k .. ".jkr")
            if G.SAVED_GAME ~= nil then
                G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME)
            end
            G:start_run({
                savetext = G.SAVED_GAME,
            })
            saveManagerAlert("Loaded save from slot [" .. k .. "]")
        end
    end
  
    if love.keyboard.isDown(keybinds.modifier) then
        if key == keybinds.f_reroll then
            Brainstorm.reroll()
        elseif key == keybinds.a_reroll then
            Brainstorm.ar_active = not Brainstorm.ar_active
        end
    end
end

function saveManagerAlert(text)
G.E_MANAGER:add_event(Event({
  trigger = "after",
  delay = 0.4,
  func = function()
  attention_text({
    text = text,
    scale = 0.7,
    hold = 3,
    major = G.STAGE == G.STAGES.RUN and G.play or G.title_top,
    backdrop_colour = G.C.SECONDARY_SET.Tarot,
    align = "cm",
    offset = {
      x = 0,
      y = -3.5,
    },
    silent = true,
  })
  G.E_MANAGER:add_event(Event({
    trigger = "after",
    delay = 0.06 * G.SETTINGS.GAMESPEED,
    blockable = false,
    blocking = false,
    func = function()
    play_sound("other1", 0.76, 0.4)
    return true
    end,
  }))
  return true
  end,
}))
end

function Brainstorm.reroll()
  local G = G -- Cache global G for performance
  G.GAME.viewed_back = nil
  G.run_setup_seed = G.GAME.seeded
  G.challenge_tab = G.GAME and G.GAME.challenge and G.GAME.challenge_tab or nil
  G.forced_seed = G.GAME.seeded and G.GAME.pseudorandom.seed or nil

  local seed = G.run_setup_seed and G.setup_seed or G.forced_seed
  local stake = (
    G.GAME.stake
    or G.PROFILES[G.SETTINGS.profile].MEMORY.stake
    or 1
  ) or 1

  G:delete_run()
  G:start_run({ stake = stake, seed = seed, challenge = G.challenge_tab })
end

local update_ref = Game.update
function Game:update(dt)
  update_ref(self, dt)

  if Brainstorm.ar_active then
    Brainstorm.ar_frames = Brainstorm.ar_frames + 1
    Brainstorm.ar_timer = Brainstorm.ar_timer + dt

    if Brainstorm.ar_timer >= Brainstorm.AR_INTERVAL then
      Brainstorm.ar_timer = Brainstorm.ar_timer - Brainstorm.AR_INTERVAL
      if Brainstorm.autoReroll() then
        Brainstorm.ar_active = false
        Brainstorm.ar_frames = 0
        if Brainstorm.ar_text then
          Brainstorm.removeAttentionText(Brainstorm.ar_text)
          Brainstorm.ar_text = nil
        end
      end
    end

    if Brainstorm.ar_frames == 60 and not Brainstorm.ar_text then
      Brainstorm.ar_text = Brainstorm.attentionText({
        scale = 1.4,
        text = "Rerolling...",
        align = "cm",
        offset = { x = 0, y = -3.5 },
        major = G.STAGE == G.STAGES.RUN and G.play or G.title_top,
      })
    end
  end
end

function Brainstorm.autoReroll()
  local seed_found = random_string(
    8,
    G.CONTROLLER.cursor_hover.T.x * 0.33411983
      + G.CONTROLLER.cursor_hover.T.y * 0.874146
      + 0.412311010 * G.CONTROLLER.cursor_hover.time
  )
  local ffi = require("ffi")
  local lovely = require("lovely")
  ffi.cdef([[
	const char* brainstorm(const char* seed, const char* voucher, const char* pack, const char* tag, double souls, bool observatory, bool perkeo, bool copymoney, bool retcon, bool bean, bool burglar, const char* customFilter);
    ]])
  local immolate = ffi.load(Brainstorm.PATH .. "/Immolate.dll")
  local pack
  if #Brainstorm.config.ar_filters.pack > 0 then
    pack = Brainstorm.config.ar_filters.pack[1]:match("^(.*)_")
  else
    pack = {}
  end
  local pack_name = localize({ type = "name_text", set = "Other", key = pack })
  local tag_name = localize({
    type = "name_text",
    set = "Tag",
    key = Brainstorm.config.ar_filters.tag_name,
  })
  local voucher_name = localize({
    type = "name_text",
    set = "Voucher",
    key = Brainstorm.config.ar_filters.voucher_name,
  })
  --local custom_filter_name = localize({
  --    type = "name_text",
  --    set = "Other",
  --    key = Brainstorm.config.ar_filters.custom_filter_name
  --})
  print(pack_name, tag_name, voucher_name)--, custom_filter_name)
  seed_found = ffi.string(
    immolate.brainstorm(
      seed_found,
      voucher_name,
      pack_name,
      tag_name,
      Brainstorm.config.ar_filters.soul_skip,
      Brainstorm.config.ar_filters.inst_observatory,
      Brainstorm.config.ar_filters.inst_perkeo,
      Brainstorm.config.ar_filters.copy_money,
      Brainstorm.config.ar_filters.retcon,
      Brainstorm.config.ar_filters.bean,
      Brainstorm.config.ar_filters.burglar,
      Brainstorm.config.ar_filters.custom_filter_name
    )
  )
  if seed_found then
    _stake = G.GAME.stake
    G:delete_run()
    G:start_run({
      stake = _stake,
      seed = seed_found,
      challenge = G.GAME and G.GAME.challenge and G.GAME.challenge_tab,
    })
    G.GAME.used_filter = true
    G.GAME.filter_info = {
      filter_params = {
        seed_found,
        voucher_name,
        pack_name,
        tag_name,
        Brainstorm.config.ar_filters.soul_skip,
        Brainstorm.config.ar_filters.inst_observatory,
        Brainstorm.config.ar_filters.inst_perkeo,
        Brainstorm.config.ar_filters.copy_money,
        Brainstorm.config.ar_filters.retcon,
        Brainstorm.config.ar_filters.bean,
        Brainstorm.config.ar_filters.burglar,
        custom_filter_name
      },
    }
    G.GAME.seeded = false
  end
  return seed_found
end

local cursr = create_UIBox_round_scores_row
function create_UIBox_round_scores_row(score, text_colour)
  local ret = cursr(score, text_colour)
  ret.nodes[2].nodes[1].config.colour = (score == "seed" and G.GAME.seeded)
      and G.C.RED
    or (score == "seed" and G.GAME.used_filter) and G.C.BLUE
    or G.C.BLACK
  return ret
end

-- TODO: Rework attention text.
function Brainstorm.attentionText(args)
  args = args or {}
  args.text = args.text or "test"
  args.scale = args.scale or 1
  args.colour = copy_table(args.colour or G.C.WHITE)
  args.hold = (args.hold or 0) + 0.1 * G.SPEEDFACTOR
  args.pos = args.pos or { x = 0, y = 0 }
  args.align = args.align or "cm"
  args.emboss = args.emboss or nil

  args.fade = 1

  if args.cover then
    args.cover_colour = copy_table(args.cover_colour or G.C.RED)
    args.cover_colour_l = copy_table(lighten(args.cover_colour, 0.2))
    args.cover_colour_d = copy_table(darken(args.cover_colour, 0.2))
  else
    args.cover_colour = copy_table(G.C.CLEAR)
  end

  args.uibox_config = {
    align = args.align or "cm",
    offset = args.offset or { x = 0, y = 0 },
    major = args.cover or args.major or nil,
  }

  G.E_MANAGER:add_event(Event({
    trigger = "after",
    delay = 0,
    blockable = false,
    blocking = false,
    func = function()
      args.AT = UIBox({
        T = { args.pos.x, args.pos.y, 0, 0 },
        definition = {
          n = G.UIT.ROOT,
          config = {
            align = args.cover_align or "cm",
            minw = (args.cover and args.cover.T.w or 0.001)
              + (args.cover_padding or 0),
            minh = (args.cover and args.cover.T.h or 0.001)
              + (args.cover_padding or 0),
            padding = 0.03,
            r = 0.1,
            emboss = args.emboss,
            colour = args.cover_colour,
          },
          nodes = {
            {
              n = G.UIT.O,
              config = {
                draw_layer = 1,
                object = DynaText({
                  scale = args.scale,
                  string = args.text,
                  maxw = args.maxw,
                  colours = { args.colour },
                  float = true,
                  shadow = true,
                  silent = not args.noisy,
                  args.scale,
                  pop_in = 0,
                  pop_in_rate = 6,
                  rotate = args.rotate or nil,
                }),
              },
            },
          },
        },
        config = args.uibox_config,
      })
      args.AT.attention_text = true

      args.text = args.AT.UIRoot.children[1].config.object
      args.text:pulse(0.5)

      if args.cover then
        Particles(args.pos.x, args.pos.y, 0, 0, {
          timer_type = "TOTAL",
          timer = 0.01,
          pulse_max = 15,
          max = 0,
          scale = 0.3,
          vel_variation = 0.2,
          padding = 0.1,
          fill = true,
          lifespan = 0.5,
          speed = 2.5,
          attach = args.AT.UIRoot,
          colours = {
            args.cover_colour,
            args.cover_colour_l,
            args.cover_colour_d,
          },
        })
      end
      if args.backdrop_colour then
        args.backdrop_colour = copy_table(args.backdrop_colour)
        Particles(args.pos.x, args.pos.y, 0, 0, {
          timer_type = "TOTAL",
          timer = 5,
          scale = 2.4 * (args.backdrop_scale or 1),
          lifespan = 5,
          speed = 0,
          attach = args.AT,
          colours = { args.backdrop_colour },
        })
      end
      return true
    end,
  }))
  return args
end

function Brainstorm.removeAttentionText(args)
  G.E_MANAGER:add_event(Event({
    trigger = "after",
    delay = 0,
    blockable = false,
    blocking = false,
    func = function()
      if not args.start_time then
        args.start_time = G.TIMERS.TOTAL
        if args.text.pop_out then
          args.text:pop_out(2)
        end
      else
        --args.AT:align_to_attach()
        args.fade = math.max(0, 1 - 3 * (G.TIMERS.TOTAL - args.start_time))
        if args.cover_colour then
          args.cover_colour[4] = math.min(args.cover_colour[4], 2 * args.fade)
        end
        if args.cover_colour_l then
          args.cover_colour_l[4] = math.min(args.cover_colour_l[4], args.fade)
        end
        if args.cover_colour_d then
          args.cover_colour_d[4] = math.min(args.cover_colour_d[4], args.fade)
        end
        if args.backdrop_colour then
          args.backdrop_colour[4] = math.min(args.backdrop_colour[4], args.fade)
        end
        args.colour[4] = math.min(args.colour[4], args.fade)
        if args.fade <= 0 then
          args.AT:remove()
          return true
        end
      end
    end,
  }))
end

--- Original: Divvy's Preview for Balatro - Core.lua

if SMODS and SMODS.current_mod then
	SMODS.Atlas({
		key = "modicon",
		path = "icon.png",
		px = 32,
		py = 32,
	})
end

-- The functions responsible for running the simulation at appropriate times;
-- ie. whenever the player modifies card selection or card order.

function FN.PRE.simulate()
   -- Guard against simulating in redundant places:
   if FN.PRE.five_second_coroutine and coroutine.status(FN.PRE.five_second_coroutine) == "suspended" then
      coroutine.resume(FN.PRE.five_second_coroutine)
   end
   if not (G.STATE == G.STATES.SELECTING_HAND or
           G.STATE == G.STATES.DRAW_TO_HAND or
           G.STATE == G.STATES.PLAY_TAROT)
   then return {score = {min = 0, exact = 0, max = 0}, dollars = {min = 0, exact = 0, max = 0}}
   end

   if G.SETTINGS.FN.hide_face_down then
      for _, card in ipairs(G.hand.highlighted) do
         if card.facing == "back" then return nil end
      end
      if #(G.hand.highlighted) ~= 0 then
        for _, joker in ipairs(G.jokers.cards) do
          if joker.facing == "back" then return nil end
        end
      end
   end

   return FN.SIM.run()
end

--
-- SIMULATION UPDATE ADVICE:
--

function FN.PRE.add_update_event(trigger)
   function sim_func()
      FN.PRE.data = FN.PRE.simulate()
      return true
   end
   if FN.PRE.enabled() then
      G.E_MANAGER:add_event(Event({trigger = trigger, func = sim_func}))
   end
end

-- Update simulation after a consumable (eg. Tarot, Planet) is used:
local orig_use = Card.use_consumeable
function Card:use_consumeable(area, copier)
   orig_use(self, area, copier)
   FN.PRE.add_update_event("immediate")
end

-- Update simulation after card selection changed:
local orig_hl = CardArea.parse_highlighted
function CardArea:parse_highlighted()
   orig_hl(self)
   if not FN.PRE.lock_updates and FN.PRE.show_preview then
      FN.PRE.show_preview = false
   end
   FN.PRE.add_update_event("immediate")
end

-- Update simulation after joker sold:
local orig_card_remove = Card.remove_from_area
function Card:remove_from_area()
   orig_card_remove(self)
   if self.config.type == 'joker' then
      FN.PRE.add_update_event("immediate")
   end
end

-- Update simulation after joker reordering:
local orig_update = CardArea.update
function CardArea:update(dt)
   orig_update(self, dt)
   FN.PRE.update_on_card_order_change(self)
end

function FN.PRE.update_on_card_order_change(cardarea)
   if #cardarea.cards == 0 or
      not (G.STATE == G.STATES.SELECTING_HAND or
           G.STATE == G.STATES.DRAW_TO_HAND or
           G.STATE == G.STATES.PLAY_TAROT)
   then return end
   -- Important not to update on G.STATES.HAND_PLAYED, because it would reset the preview text!

   if (G.STATE == G.STATES.HAND_PLAYED) then return end

   local prev_order = nil
   if cardarea.config.type == 'joker' and cardarea.cards[1].ability.set == 'Joker' then
      if cardarea.cards[1].edition and cardarea.cards[1].edition.mp_phantom then
         return
      end
      -- Note that the consumables cardarea also has type 'joker' so must verify by checking first card.
      prev_order = FN.PRE.joker_order
   elseif cardarea.config.type == 'hand' then
      prev_order = FN.PRE.hand_order
   else
      return
   end

   -- Go through stored card IDs and check against current card IDs, in-order.
   -- If any mismatch occurs, toggle flag and update name for next time.
   local should_update = false
   if #cardarea.cards ~= #prev_order then
      prev_order = {}
   end
   for i, c in ipairs(cardarea.cards) do
      if c.sort_id ~= prev_order[i] then
         prev_order[i] = c.sort_id
         should_update = true
      end
   end

   if should_update then
      if cardarea.config.type == 'joker' or cardarea.cards[1].ability.set == 'Joker' then
         FN.PRE.joker_order = prev_order
      elseif cardarea.config.type == 'hand' then
         FN.PRE.hand_order = prev_order
      end
      if FN.PRE.show_preview and not FN.PRE.lock_updates then
         FN.PRE.show_preview = false
      end
      FN.PRE.add_update_event("immediate")
   end
end

--
-- SIMULATION RESET ADVICE:
--

function FN.PRE.add_reset_event(trigger)
   function reset_func()
      FN.PRE.data = {score = {min = 0, exact = 0, max = 0}, dollars = {min = 0, exact = 0, max = 0}}
      return true
   end
   if FN.PRE.enabled() then
      G.E_MANAGER:add_event(Event({trigger = trigger, func = reset_func}))
   end
end

local orig_eval = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
   orig_eval(e)
   FN.PRE.add_reset_event("after")
end

local orig_discard = G.FUNCS.discard_cards_from_highlighted
function G.FUNCS.discard_cards_from_highlighted(e, is_hook_blind)
   orig_discard(e, is_hook_blind)
   if not is_hook_blind then
      FN.PRE.add_reset_event("immediate")
   end
end

--
-- USER INTERFACE ADVICE:
--

-- Add animation to preview text:
function G.FUNCS.fn_pre_score_UI_set(e)
   local new_preview_text = ""
   local should_juice = false
   if FN.PRE.lock_updates then 
      if e.config.id == "fn_pre_l" then
         new_preview_text = " CALCULATING "
         should_juice = true
      end
   else  
      if FN.PRE.data then
         if FN.PRE.show_preview and (FN.PRE.data.score.min ~= FN.PRE.data.score.max) then
            -- Format as 'X - Y' :
            if e.config.id == "fn_pre_l" then
               new_preview_text = FN.PRE.format_number(FN.PRE.data.score.min) .. " - "
               if FN.PRE.is_enough_to_win(FN.PRE.data.score.min) then should_juice = true end
            elseif e.config.id == "fn_pre_r" then
               new_preview_text = FN.PRE.format_number(FN.PRE.data.score.max)
               if FN.PRE.is_enough_to_win(FN.PRE.data.score.max) then should_juice = true end
            end
         else
            -- Format as single number:
            if e.config.id == "fn_pre_l" then
               if true then
                  -- Spaces around number necessary to distinguish Min/Max text from Exact text,
                  -- which is itself necessary to force a HUD update when switching between Min/Max and Exact.
                  if FN.PRE.show_preview then 
                     new_preview_text = " " .. FN.PRE.format_number(FN.PRE.data.score.min) .. " "
                     if FN.PRE.is_enough_to_win(FN.PRE.data.score.min) then should_juice = true end
                  else
                     if FN.PRE.is_enough_to_win(FN.PRE.data.score.min) then 
                        should_juice = true
                        new_preview_text = "  "
                     else
                        if FN.PRE.is_enough_to_win(FN.PRE.data.score.max) then
                           new_preview_text = "  "
                           should_juice = true
                        else
                           new_preview_text = "  "
                        end
                     end
                  end
               end
            else
               new_preview_text = ""
            end
         end
      else
         -- Spaces around number necessary to distinguish Min/Max text from Exact text, same as above ^
         if e.config.id == "fn_pre_l" then
            if true then new_preview_text = " ?????? "
            else new_preview_text = "??????"
            end
         else
            new_preview_text = ""
         end
      end
   end

   if (not FN.PRE.text.score[e.config.id:sub(-1)]) or new_preview_text ~= FN.PRE.text.score[e.config.id:sub(-1)] then
      FN.PRE.text.score[e.config.id:sub(-1)] = new_preview_text
      e.config.object:update_text()
      -- Wobble:
      if not G.TAROT_INTERRUPT_PULSE then
         if should_juice
         then
            G.FUNCS.text_super_juice(e, 5)
            e.config.object.colours = {G.C.MONEY}
         else
            G.FUNCS.text_super_juice(e, 0)
            e.config.object.colours = {G.C.UI.TEXT_LIGHT}
         end
      end
   end
end

function G.FUNCS.fn_pre_dollars_UI_set(e)
   local new_preview_text = ""
   local new_colour = nil
   if FN.PRE.data then
      if true and (FN.PRE.data.dollars.min ~= FN.PRE.data.dollars.max) then
         if e.config.id == "fn_pre_dollars_top" then
            new_preview_text = " " .. FN.PRE.get_sign_str(FN.PRE.data.dollars.max) .. FN.PRE.data.dollars.max
            new_colour = FN.PRE.get_dollar_colour(FN.PRE.data.dollars.max)
         elseif e.config.id == "fn_pre_dollars_bot" then
            new_preview_text = " " .. FN.PRE.get_sign_str(FN.PRE.data.dollars.min) .. FN.PRE.data.dollars.min
            new_colour = FN.PRE.get_dollar_colour(FN.PRE.data.dollars.min)
         end
      else
         if e.config.id == "fn_pre_dollars_top" then
            local _data = (G.SETTINGS.FN.show_min_max) and FN.PRE.data.dollars.min or FN.PRE.data.dollars.exact

            new_preview_text = " " .. FN.PRE.get_sign_str(_data) .. _data
            new_colour = FN.PRE.get_dollar_colour(_data)
         else
            new_preview_text = ""
            new_colour = FN.PRE.get_dollar_colour(0)
         end
      end
   else
      new_preview_text = " +??"
      new_colour = FN.PRE.get_dollar_colour(0)
   end

   if (not FN.PRE.text.dollars[e.config.id:sub(-3)]) or new_preview_text ~= FN.PRE.text.dollars[e.config.id:sub(-3)] then
      FN.PRE.text.dollars[e.config.id:sub(-3)] = new_preview_text
      e.config.object.colours = {new_colour}
      e.config.object:update_text()
      if not G.TAROT_INTERRUPT_PULSE then e.config.object:pulse(0.25) end
   end
end

--- Original: Divvy's Preview for Balatro - Utils.lua
--
-- Utilities for checking states and formatting display.

function FN.PRE.is_enough_to_win(chips)
   if G.GAME.blind and
      (G.STATE == G.STATES.SELECTING_HAND or
       G.STATE == G.STATES.DRAW_TO_HAND or
       G.STATE == G.STATES.PLAY_TAROT)
   then return (G.GAME.chips + chips >= G.GAME.blind.chips)
   else return false
   end
end

function FN.PRE.format_number(num)
   if not num or type(num) ~= 'number' then return num or '' end
   -- Start using e-notation earlier to reduce number length, if showing min and max for preview:
   if true and num >= 1e7 then
      local x = string.format("%.4g",num)
      local fac = math.floor(math.log(tonumber(x), 10))
      return string.format("%.2f",x/(10^fac))..'e'..fac
   end
   return number_format(num) -- Default Balatro function.
end

function FN.PRE.get_dollar_colour(n)
   if n == 0 then return HEX("7e7667")
   elseif n > 0 then return G.C.MONEY
   elseif n < 0 then return G.C.RED
   end
end

function FN.PRE.get_sign_str(n)
   if n >= 0 then return "+"
   else return "" -- Negative numbers already have a sign
   end
end

function FN.PRE.enabled()
   return G.SETTINGS.FN.preview_score or G.SETTINGS.FN.preview_dollars
end

local FP_lovely = require("lovely")
FP_NFS = require("FP_nativefs") ---@module "nativefs"
FP_JSON = require("FP_json") ---@module "json"

FlowerPot = {
    VERSION = "0.8.1",
    GLOBAL = {},
    CONFIG = {
        ["stat_tooltips_enabled"] = true,
        ["voucher_sticker_enabled"] = 1,
    },
    path_to_self = function()
        for k, v in pairs(FP_NFS.getDirectoryItems(FP_lovely.mod_dir)) do
            if FP_NFS.getInfo(FP_lovely.mod_dir.."/"..v.."/Flower Pot.lua") then return FP_lovely.mod_dir.."/"..v.."/" end
        end
    end,
    path_to_stats = function() return love.filesystem.getSaveDirectory().."/Flower Pot - Stat Files/" end,
    save_flowpot_config = function() -- duplicate of SMODS.save_mod_config
        local success = assert(pcall(function()
            FP_NFS.createDirectory(love.filesystem.getSaveDirectory()..'/config')
            local serialized = 'return '..serialize(FlowerPot.CONFIG)
            FP_NFS.write(love.filesystem.getSaveDirectory()..'/config/FlowerPot.jkr', serialized)
        end))
        return success
    end,
    load_flowpot_config = function() -- duplicate of SMODS.load_mod_config
        local s1, config = pcall(function()
            return load(FP_NFS.read(love.filesystem.getSaveDirectory()..'/config/FlowerPot.jkr'), '=[FlowerPot-CONFIG]')()
        end)
        local s2, default_config = pcall(function()
            return load(FP_NFS.read(FlowerPot.path_to_self().."config.lua"), '=[FlowerPot-CONFIG "default"]')()
        end)
        if not s1 or type(config) ~= 'table' then config = {} end
        if not s2 or type(default_config) ~= 'table' then default_config = {} end
        FlowerPot.CONFIG = default_config
        
        local function insert_saved_config(savedCfg, defaultCfg)
            for savedKey, savedVal in pairs(savedCfg) do
                local savedValType = type(savedVal)
                local defaultValType = type(defaultCfg[savedKey])
                if not defaultCfg[savedKey] then
                    defaultCfg[savedKey] = savedVal
                elseif savedValType ~= defaultValType then
                elseif savedValType == "table" and defaultValType == "table" then
                    insert_saved_config(savedVal, defaultCfg[savedKey])
                elseif savedVal ~= defaultCfg[savedKey] then
                    defaultCfg[savedKey] = savedVal
                end
                
            end
        end

        insert_saved_config(config, FlowerPot.CONFIG)
    end
}

if not (SMODS and SMODS.can_load) then FlowerPot.load_flowpot_config() end

for _, path in ipairs {
    "core/api.lua",
    "core/stats.lua",
    "core/ui.lua",
    "core/other.lua",
} do
    assert(load(FP_NFS.read(FlowerPot.path_to_self()..path), ('=[FlowerPot-CORE _ "%s"]'):format(path)), "Flower Pot could not be found. \nPlease ensure that the Flower Pot mod folder is renamed to match the text \"Flower-Pot\".")()
end

local lovely = require("lovely")
local nativefs = require("nativefs")

local info = nativefs.getDirectoryItemsInfo(lovely.mod_dir)
local talisman_path = ""
for i, v in pairs(info) do
  if v.type == "directory" and nativefs.getInfo(lovely.mod_dir .. "/" .. v.name .. "/talisman.lua") then talisman_path = lovely.mod_dir .. "/" .. v.name end
end

if not nativefs.getInfo(talisman_path) then
    error(
        'Could not find proper Talisman folder.\nPlease make sure that Talisman is installed correctly and the folders arent nested.')
end

-- "Borrowed" from Trance
function load_file_with_fallback2(a, aa)
    local success, result = pcall(function() return assert(load(nativefs.read(a)))() end)
    if success then
        return result
    end
    local fallback_success, fallback_result = pcall(function() return assert(load(nativefs.read(aa)))() end)
    if fallback_success then
        return fallback_result
    end
end

local talismanloc = init_localization
function init_localization()
	local abc = load_file_with_fallback2(
		talisman_path.."/localization/" .. (G.SETTINGS.language or "en-us") .. ".lua",
		talisman_path .. "/localization/en-us.lua"
	)
	for k, v in pairs(abc) do
		if k ~= "descriptions" then
			G.localization.misc.dictionary[k] = v
		end
		-- todo error messages(?)
		G.localization.misc.dictionary[k] = v
	end
	talismanloc()
end

Talisman = {config_file = {disable_anims = false, break_infinity = "omeganum", score_opt_id = 3}, mod_path = talisman_path}
if nativefs.read(talisman_path.."/config.lua") then
    Talisman.config_file = STR_UNPACK(nativefs.read(talisman_path.."/config.lua"))
    if Talisman.config_file.break_infinity == "bignumber" then
      Talisman.config_file.break_infinity = "omeganum"
      Talisman.config_file.score_opt_id = 2
    end
    if Talisman.config_file.score_opt_id == 3 then Talisman.config_file.score_opt_id = 2 end
    if Talisman.config_file.break_infinity and type(Talisman.config_file.break_infinity) ~= 'string' then
      Talisman.config_file.break_infinity = "omeganum"
    end
end
if not SMODS or not JSON then
  local createOptionsRef = create_UIBox_options
  function create_UIBox_options()
  contents = createOptionsRef()
  local m = UIBox_button({
  minw = 5,
  button = "talismanMenu",
  label = {
  	localize({ type = "name_text", set = "Spectral", key = "c_talisman" })
  },
  colour = G.C.GOLD
  })
  table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, m)
  return contents
  end
end

Talisman.config_tab = function()
                tal_nodes = {{n=G.UIT.R, config={align = "cm"}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = localize("talisman_string_A"), colours = {G.C.WHITE}, shadow = true, scale = 0.4})}},
                }},create_toggle({label = localize("talisman_string_B"), ref_table = Talisman.config_file, ref_value = "disable_anims",
                callback = function(_set_toggle)
	                nativefs.write(talisman_path .. "/config.lua", STR_PACK(Talisman.config_file))
                end}),
                create_option_cycle({
                  label = localize("talisman_string_C"),
                  scale = 0.8,
                  w = 6,
                  options = {localize("talisman_vanilla"), localize("talisman_omeganum") .. "(e10##1000)"},
                  opt_callback = 'talisman_upd_score_opt',
                  current_option = Talisman.config_file.score_opt_id,
                })}
                return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 10,
                    align = "cm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = tal_nodes
            }
              end
G.FUNCS.talismanMenu = function(e)
  local tabs = create_tabs({
      snap_to_nav = true,
      tabs = {
          {
              label = localize({ type = "name_text", set = "Spectral", key = "c_talisman" }),
              chosen = true,
              tab_definition_function = Talisman.config_tab
          },
      }})
  G.FUNCS.overlay_menu{
          definition = create_UIBox_generic_options({
              back_func = "options",
              contents = {tabs}
          }),
      config = {offset = {x=0,y=10}}
  }
end
G.FUNCS.talisman_upd_score_opt = function(e)
  Talisman.config_file.score_opt_id = e.to_key
  local score_opts = {"", "omeganum"}
  Talisman.config_file.break_infinity = score_opts[e.to_key]
  nativefs.write(talisman_path .. "/config.lua", STR_PACK(Talisman.config_file))
end
if Talisman.config_file.break_infinity then
  Big, err = nativefs.load(talisman_path.."/big-num/"..Talisman.config_file.break_infinity..".lua")
  if not err then Big = Big() else Big = nil end
  Notations = nativefs.load(talisman_path.."/big-num/notations.lua")()
  -- We call this after init_game_object to leave room for mods that add more poker hands
  Talisman.igo = function(obj)
      for _, v in pairs(obj.hands) do
          v.chips = to_big(v.chips)
          v.mult = to_big(v.mult)
          v.s_chips = to_big(v.s_chips)
          v.s_mult = to_big(v.s_mult)
          v.l_chips = to_big(v.l_chips)
          v.l_mult = to_big(v.l_mult)
          v.level = to_big(v.level)
      end
      obj.starting_params.dollars = to_big(obj.starting_params.dollars)
      return obj
  end

  local nf = number_format
  function number_format(num, e_switch_point)
      if type(num) == 'table' then
          --num = to_big(num)
          if num.str then return num.str end
          if num:arraySize() > 2 then
            local str = Notations.Balatro:format(num, 3)
            num.str = str
            return str
          end
          G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
          if (num or 0) < (to_big(G.E_SWITCH_POINT) or 0) then
              return nf(num:to_number(), e_switch_point)
          else
            return Notations.Balatro:format(num, 3)
          end
      else return nf(num, e_switch_point) end
  end

  local mf = math.floor
  function math.floor(x)
      if type(x) == 'table' then return x.floor and x:floor() or x end
      return mf(x)
  end
  local mc = math.ceil
  function math.ceil(x)
      if type(x) == 'table' then return x:ceil() end
      return mc(x)
  end

function lenient_bignum(x)
    if type(x) == "number" then return x end
    if to_big(x) < to_big(1e300) and to_big(x) > to_big(-1e300) then
      return x:to_number()
    end
    return x
  end

  --prevent some log-related crashes
  local sns = score_number_scale
  function score_number_scale(scale, amt)
    local ret = sns(scale, amt)
    if type(ret) == "table" then
      if ret > to_big(1e300) then return 1e300 end
      return ret:to_number()
    end
    return ret
  end

  local gftsj = G.FUNCS.text_super_juice
  function G.FUNCS.text_super_juice(e, _amount)
    if type(_amount) == "table" then
      if _amount > to_big(1e300) then
        _amount = 1e300
      else
        _amount = _amount:to_number()
      end
    end
    return gftsj(e, _amount)
  end

  local l10 = math.log10
  function math.log10(x)
      if type(x) == 'table' then 
        if x.log10 then return lenient_bignum(x:log10()) end
        return lenient_bignum(l10(math.min(x:to_number(),1e300)))
      end
      return lenient_bignum(l10(x))
  end

  local lg = math.log
  function math.log(x, y)
      if not y then y = 2.718281828459045 end
      if type(x) == 'table' then 
        if x.log then return lenient_bignum(x:log(to_big(y))) end
        if x.logBase then return lenient_bignum(x:logBase(to_big(y))) end
        return lenient_bignum(lg(math.min(x:to_number(),1e300),y))
      end
      return lenient_bignum(lg(x,y))
  end

  function math.exp(x)
    local big_e = to_big(2.718281828459045)
    
    if type(big_e) == "number" then
      return lenient_bignum(big_e ^ x)
    else
      return lenient_bignum(big_e:pow(x))
    end
  end 

  if SMODS then
    function SMODS.get_blind_amount(ante)
      local k = to_big(0.75)
      local scale = G.GAME.modifiers.scaling
      local amounts = {
          to_big(300),
          to_big(700 + 100*scale),
          to_big(1400 + 600*scale),
          to_big(2100 + 2900*scale),
          to_big(15000 + 5000*scale*math.log(scale)),
          to_big(12000 + 8000*(scale+1)*(0.4*scale)),
          to_big(10000 + 25000*(scale+1)*((scale/4)^2)),
          to_big(50000 * (scale+1)^2 * (scale/7)^2)
      }
      
      if ante < 1 then return to_big(100) end
      if ante <= 8 then 
        local amount = amounts[ante]
        if (amount:lt(R.E_MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
       end
      local a, b, c, d = amounts[8], amounts[8]/amounts[7], ante-8, 1 + 0.2*(ante-8)
      local amount = math.floor(a*(b + (b*k*c)^d)^c)
      if (amount:lt(R.E_MAX_SAFE_INTEGER)) then
        local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
        amount = math.floor(amount / exponent):to_number() * exponent
      end
      amount:normalize()
      return amount
    end
  end
  -- There's too much to override here so we just fully replace this function
  -- Note that any ante scaling tweaks will need to manually changed...
  local gba = get_blind_amount
  function get_blind_amount(ante)
    if G.GAME.modifiers.scaling and (G.GAME.modifiers.scaling ~= 1 and G.GAME.modifiers.scaling ~= 2 and G.GAME.modifiers.scaling ~= 3) then return SMODS.get_blind_amount(ante) end
    if type(to_big(1)) == 'number' then return gba(ante) end
      local k = to_big(0.75)
      if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
        local amounts = {
          to_big(300),  to_big(800), to_big(2000),  to_big(5000),  to_big(11000),  to_big(20000),   to_big(35000),  to_big(50000)
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.E_MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      elseif G.GAME.modifiers.scaling == 2 then 
        local amounts = {
          to_big(300),  to_big(900), to_big(2600),  to_big(8000), to_big(20000),  to_big(36000),  to_big(60000),  to_big(100000)
          --300,  900, 2400,  7000,  18000,  32000,  56000,  90000
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.E_MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      elseif G.GAME.modifiers.scaling == 3 then 
        local amounts = {
          to_big(300),  to_big(1000), to_big(3200),  to_big(9000),  to_big(25000),  to_big(60000),  to_big(110000),  to_big(200000)
          --300,  1000, 3000,  8000,  22000,  50000,  90000,  180000
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.E_MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      end
    end

  function check_and_set_high_score(score, amt)
    if G.GAME.round_scores[score] and to_big(math.floor(amt)) > to_big(G.GAME.round_scores[score].amt) then
      G.GAME.round_scores[score].amt = to_big(math.floor(amt))
    end
    if  G.GAME.seeded  then return end
    --[[if G.PROFILES[G.SETTINGS.profile].high_scores[score] and math.floor(amt) > G.PROFILES[G.SETTINGS.profile].high_scores[score].amt then
      if G.GAME.round_scores[score] then G.GAME.round_scores[score].high_score = true end
      G.PROFILES[G.SETTINGS.profile].high_scores[score].amt = math.floor(amt)
      G:save_settings()
    end--]] --going to hold off on modifying this until proper save loading exists
  end

  local ics = inc_career_stat
  -- This is used often for unlocks, so we can't just prevent big money from being added
  -- Also, I'm completely overriding this, since I don't think any mods would want to change it
  function inc_career_stat(stat, mod)
    if G.GAME.seeded or G.GAME.challenge then return end
    if not G.PROFILES[G.SETTINGS.profile].career_stats[stat] then G.PROFILES[G.SETTINGS.profile].career_stats[stat] = 0 end
    G.PROFILES[G.SETTINGS.profile].career_stats[stat] = G.PROFILES[G.SETTINGS.profile].career_stats[stat] + (mod or 0)
    -- Make sure this isn't ever a talisman number
    if type(G.PROFILES[G.SETTINGS.profile].career_stats[stat]) == 'table' then
      if G.PROFILES[G.SETTINGS.profile].career_stats[stat] > to_big(1e300) then
        G.PROFILES[G.SETTINGS.profile].career_stats[stat] = to_big(1e300)
      elseif G.PROFILES[G.SETTINGS.profile].career_stats[stat] < to_big(-1e300) then
        G.PROFILES[G.SETTINGS.profile].career_stats[stat] = to_big(-1e300)
      end
      G.PROFILES[G.SETTINGS.profile].career_stats[stat] = G.PROFILES[G.SETTINGS.profile].career_stats[stat]:to_number()
    end
    G:save_settings()
  end

  local sn = scale_number
  function scale_number(number, scale, max, e_switch_point)
    if not Big then return sn(number, scale, max, e_switch_point) end
    if type(scale) ~= "table" then scale = to_big(scale) end
    if type(number) ~= "table" then number = Big:ensureBig(number) end
    if number.scale then return number.scale end
    G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
    if not number or not is_number(number) then return scale end
    if not max then max = 10000 end
    if type(number) ~= "table" then math.min(3, scale:to_number()) end
    if number.e and number.e == 10^1000 then
      scale = scale*math.floor(math.log(max*10, 10))/7
    end
    if not e_switch_point and number:arraySize() > 2 then --this is noticable faster than >= on the raw number for some reason
      if number:arraySize() <= 2 and (number.array[1] or 0) <= 999 then --gross hack
        scale = scale*math.floor(math.log(max*10, 10))/7 --this divisor is a constant so im precalcualting it
      else
        scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.max(7,string.len(number.str or number_format(number))-1))
      end
    elseif to_big(number) >= to_big(e_switch_point or G.E_SWITCH_POINT) then
      if number:arraySize() <= 2 and (number.array[1] or 0) <= 999 then --gross hack
        scale = scale*math.floor(math.log(max*10, 10))/7 --this divisor is a constant so im precalcualting it
      else
        scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.max(7,string.len(number_format(number))-1))
      end
    elseif to_big(number) >= to_big(max) then
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(number*10, 10))
    end
    local scale = math.min(3, scale:to_number())
    number.scale = scale
    return scale
   end

  local tsj = G.FUNCS.text_super_juice
  function G.FUNCS.text_super_juice(e, _amount)
    if type(_amount) == 'table' then
      if _amount > to_big(2) then _amount = 2 end
    else
      if _amount > 2 then _amount = 2 end
    end
    return tsj(e, _amount)
  end

  local max = math.max
  --don't return a Big unless we have to - it causes nativefs to break
  function math.max(x, y)
    if type(x) == 'table' or type(y) == 'table' then
    x = to_big(x)
    y = to_big(y)
    if (x > y) then
      return x
    else
      return y
    end
    else return max(x,y) end
  end

  local min = math.min
  function math.min(x, y)
    if type(x) == 'table' or type(y) == 'table' then
    x = to_big(x)
    y = to_big(y)
    if (x < y) then
      return x
    else
      return y
    end
    else return min(x,y) end
  end

  local sqrt = math.sqrt
  function math.sqrt(x)
    if type(x) == 'table' then
      if getmetatable(x) == BigMeta then return x:sqrt() end
      if getmetatable(x) == OmegaMeta then return x:pow(0.5) end
    end
    return sqrt(x)
  end

 

  local old_abs = math.abs
  function math.abs(x)
    if type(x) == 'table' then
    x = to_big(x)
    if (x < to_big(0)) then
      return -1 * x
    else
      return x
    end
    else return old_abs(x) end
  end
end

function is_number(x)
  if type(x) == 'number' then return true end
  if type(x) == 'table' and ((x.e and x.m) or (x.array and x.sign)) then return true end
  return false
end

function to_big(x, y)
  if type(x) == 'string' and x == "0" then --hack for when 0 is asked to be a bignumber need to really figure out the fix
    return 0
  elseif Big and Big.m then
    local x = Big:new(x,y)
    return x
  elseif Big and Big.array then
    local result = Big:create(x)
    result.sign = y or result.sign or x.sign or 1
    return result
  elseif is_number(x) then
    return x * 10^(y or 0)

  elseif type(x) == "nil" then
    return 0
  else
    if ((#x>=2) and ((x[2]>=2) or (x[2]==1) and (x[1]>308))) then
      return 1e309
    end
    if (x[2]==1) then
      return math.pow(10,x[1])
    end
    return x[1]*(y or 1);
  end
end
function to_number(x)
  if type(x) == 'table' and (getmetatable(x) == BigMeta or getmetatable(x) == OmegaMeta) then
    return x:to_number()
  else
    return x
  end
end

function uncompress_big(str, sign)
    local curr = 1
    local array = {}
    for i, v in pairs(str) do
        for i2 = 1, v[2] do
            array[curr] = v[1]
            curr = curr + 1
        end
    end
    return to_big(array, y)
end

--patch to remove animations
local cest = card_eval_status_text
function card_eval_status_text(a,b,c,d,e,f)
    if not Talisman.config_file.disable_anims then cest(a,b,c,d,e,f) end
end
local jc = juice_card
function juice_card(x)
    if not Talisman.config_file.disable_anims then jc(x) end
end
local cju = Card.juice_up
function Card:juice_up(...)
    if not Talisman.config_file.disable_anims then cju(self, ...) end
end
function tal_uht(config, vals)
    local col = G.C.GREEN
    if vals.chips and G.GAME.current_round.current_hand.chips ~= vals.chips then
        local delta = (is_number(vals.chips) and is_number(G.GAME.current_round.current_hand.chips)) and (vals.chips - G.GAME.current_round.current_hand.chips) or 0
        if to_big(delta) < to_big(0) then delta = number_format(delta); col = G.C.RED
        elseif to_big(delta) > to_big(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.chips) == 'string' then delta = vals.chips end
        G.GAME.current_round.current_hand.chips = vals.chips
        if G.hand_text_area.chips.config.object then
          G.hand_text_area.chips:update(0)
        end
    end
    if vals.mult and G.GAME.current_round.current_hand.mult ~= vals.mult then
        local delta = (is_number(vals.mult) and is_number(G.GAME.current_round.current_hand.mult))and (vals.mult - G.GAME.current_round.current_hand.mult) or 0
        if to_big(delta) < to_big(0) then delta = number_format(delta); col = G.C.RED
        elseif to_big(delta) > to_big(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.mult) == 'string' then delta = vals.mult end
        G.GAME.current_round.current_hand.mult = vals.mult
        if G.hand_text_area.mult.config.object then
          G.hand_text_area.mult:update(0)
        end
    end
    if vals.handname and G.GAME.current_round.current_hand.handname ~= vals.handname then
        G.GAME.current_round.current_hand.handname = vals.handname
    end
    if vals.chip_total then G.GAME.current_round.current_hand.chip_total = vals.chip_total;G.hand_text_area.chip_total.config.object:pulse(0.5) end
    if vals.level and G.GAME.current_round.current_hand.hand_level ~= ' '..localize('k_lvl')..tostring(vals.level) then
        if vals.level == '' then
            G.GAME.current_round.current_hand.hand_level = vals.level
        else
            G.GAME.current_round.current_hand.hand_level = ' '..localize('k_lvl')..tostring(vals.level)
            if is_number(vals.level) then
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[type(vals.level) == "number" and math.floor(math.min(vals.level, 7)) or math.floor(to_number(math.min(vals.level, 7)))]
            else
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[1]
            end
        end
    end
    return true
end
local uht = update_hand_text
function update_hand_text(config, vals)
    if Talisman.config_file.disable_anims then
        if G.latest_uht then
          local chips = G.latest_uht.vals.chips
          local mult = G.latest_uht.vals.mult
          if not vals.chips then vals.chips = chips end
          if not vals.mult then vals.mult = mult end
        end
        G.latest_uht = {config = config, vals = vals}
    else uht(config, vals)
    end
end


G.FUNCS.evaluate_play = function(e)
  Talisman.scoring_state = "intro"
  text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta = evaluate_play_intro()
  if not G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text) then
    Talisman.scoring_state = "main"
    text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta = evaluate_play_main(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
  else
    Talisman.scoring_state = "debuff"
    text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta = evaluate_play_debuff(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
  end
  Talisman.scoring_state = "final_scoring"
  text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta = evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
  Talisman.scoring_state = "after"
  evaluate_play_after(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
  Talisman.scoring_state = nil
end

local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    if G.latest_uht and G.latest_uht.config and G.latest_uht.vals then
        tal_uht(G.latest_uht.config, G.latest_uht.vals)
        G.latest_uht = nil
    end
    if Talisman.dollar_update then
      G.HUD:get_UIE_by_ID('dollar_text_UI').config.object:update()
      G.HUD:recalculate()
      Talisman.dollar_update = false
    end
end
Talisman.F_NO_COROUTINE = false --easy disabling for bugfixing, since the coroutine can make it hard to see where errors are
if not Talisman.F_NO_COROUTINE then
  --scoring coroutine
  local oldplay = G.FUNCS.evaluate_play

  function G.FUNCS.evaluate_play(...)
      G.SCORING_COROUTINE = coroutine.create(oldplay)
      G.LAST_SCORING_YIELD = love.timer.getTime()
      G.CARD_CALC_COUNTS = {} -- keys = cards, values = table containing numbers
      local success, err = coroutine.resume(G.SCORING_COROUTINE, ...)
      if not success then
        error(err)
      end
  end

  function G.FUNCS.tal_abort()
      tal_aborted = true
  end

  local oldupd = love.update

  function love.update(dt, ...)
      oldupd(dt, ...)
      if G.SCORING_COROUTINE then
        if collectgarbage("count") > 1024*1024 then
          collectgarbage("collect")
        end
          if coroutine.status(G.SCORING_COROUTINE) == "dead" or tal_aborted then
              G.SCORING_COROUTINE = nil
              G.FUNCS.exit_overlay_menu()
              local totalCalcs = 0
              for i, v in pairs(G.CARD_CALC_COUNTS) do
                totalCalcs = totalCalcs + v[1]
              end
              G.GAME.LAST_CALCS = totalCalcs
              G.GAME.LAST_CALC_TIME = G.CURRENT_CALC_TIME
              G.CURRENT_CALC_TIME = 0
              if tal_aborted and Talisman.scoring_state == "main" then
                evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
              end
              tal_aborted = nil
              Talisman.scoring_state = nil
          else
              G.SCORING_TEXT = nil
              if not G.OVERLAY_MENU then
                  G.scoring_text = {localize("talisman_string_D"), "", "", ""}
                  G.SCORING_TEXT = { 
                    {n = G.UIT.C, nodes = {
                      {n = G.UIT.R, config = {padding = 0.1, align = "cm"}, nodes = {
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.scoring_text, ref_value = 1}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 1, silent = true})}},
                      }},{n = G.UIT.R,  nodes = {
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.scoring_text, ref_value = 2}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4, silent = true})}},
                      }},{n = G.UIT.R,  nodes = {
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.scoring_text, ref_value = 3}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4, silent = true})}},
                      }},{n = G.UIT.R,  nodes = {
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.scoring_text, ref_value = 4}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4, silent = true})}},
                      }},{n = G.UIT.R,  nodes = {
                      UIBox_button({
                        colour = G.C.BLUE,
                        button = "tal_abort",
                        label = { localize("talisman_string_E") },
                        minw = 4.5,
                        focus_args = { snap_to = true },
                      })}},
                    }}}
                  G.FUNCS.overlay_menu({
                      definition = 
                      {n=G.UIT.ROOT, minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5, config={align = "cm", padding = 9999, offset = {x = 0, y = -3}, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes= G.SCORING_TEXT}, 
                      config = {align="cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH, bond = 'Weak'}
                  })
              else

                  if G.OVERLAY_MENU and G.scoring_text then
                    local totalCalcs = 0
                    for i, v in pairs(G.CARD_CALC_COUNTS) do
                      totalCalcs = totalCalcs + v[1]
                    end
                    local jokersYetToScore = #G.jokers.cards + #G.play.cards - #G.CARD_CALC_COUNTS
                    G.CURRENT_CALC_TIME = (G.CURRENT_CALC_TIME or 0) + dt
                    G.scoring_text[1] = localize("talisman_string_D")
                    G.scoring_text[2] = localize("talisman_string_F")..tostring(totalCalcs).." ("..tostring(number_format(G.CURRENT_CALC_TIME)).."s)"
                    G.scoring_text[3] = localize("talisman_string_G")..tostring(jokersYetToScore)
                    G.scoring_text[4] = localize("talisman_string_H") .. tostring(G.GAME.LAST_CALCS or localize("talisman_string_I")) .." ("..tostring(G.GAME.LAST_CALC_TIME and number_format(G.GAME.LAST_CALC_TIME) or "???").."s)"
                  end

              end
        --this coroutine allows us to stagger GC cycles through
        --the main source of waste in terms of memory (especially w joker retriggers) is through local variables that become garbage
        --this practically eliminates the memory overhead of scoring
        --event queue overhead seems to not exist if Talismans Disable Scoring Animations is off.
        --event manager has to wait for scoring to finish until it can keep processing events anyways.

              
              G.LAST_SCORING_YIELD = love.timer.getTime()
              
              local success, msg = coroutine.resume(G.SCORING_COROUTINE)
              if not success then
                error(msg)
              end
          end
      end
  end



  TIME_BETWEEN_SCORING_FRAMES = 0.03 -- 30 fps during scoring
  -- we dont want overhead from updates making scoring much slower
  -- originally 10 fps, I think 30 fps is a good way to balance it while making it look smooth, too
  --wrap everything in calculating contexts so we can do more things with it
  Talisman.calculating_joker = false
  Talisman.calculating_score = false
  Talisman.calculating_card = false
  Talisman.dollar_update = false
  local ccj = Card.calculate_joker
  function Card:calculate_joker(context)
    --scoring coroutine
    G.CURRENT_SCORING_CARD = self
    G.CARD_CALC_COUNTS = G.CARD_CALC_COUNTS or {}
    if G.CARD_CALC_COUNTS[self] then
      G.CARD_CALC_COUNTS[self][1] = G.CARD_CALC_COUNTS[self][1] + 1
    else
      G.CARD_CALC_COUNTS[self] = {1, 1}
    end


    if G.LAST_SCORING_YIELD and ((love.timer.getTime() - G.LAST_SCORING_YIELD) > TIME_BETWEEN_SCORING_FRAMES) and coroutine.running() then
          coroutine.yield()
    end
    Talisman.calculating_joker = true
    local ret, trig = ccj(self, context)

    if ret and type(ret) == "table" and ret.repetitions then
      if not ret.card then
        G.CARD_CALC_COUNTS.other = G.CARD_CALC_COUNTS.other or {1,1}
        G.CARD_CALC_COUNTS.other[2] = G.CARD_CALC_COUNTS.other[2] + ret.repetitions
      else
        G.CARD_CALC_COUNTS[ret.card] = G.CARD_CALC_COUNTS[ret.card] or {1,1}
        G.CARD_CALC_COUNTS[ret.card][2] = G.CARD_CALC_COUNTS[ret.card][2] + ret.repetitions
      end
    end
    Talisman.calculating_joker = false
    return ret, trig
  end
  local cuc = Card.use_consumable
  function Card:use_consumable(x,y)
    Talisman.calculating_score = true
    local ret = cuc(self, x,y)
    Talisman.calculating_score = false
    return ret
  end
  local gfep = G.FUNCS.evaluate_play
  G.FUNCS.evaluate_play = function(e)
    Talisman.calculating_score = true
    local ret = gfep(e)
    Talisman.calculating_score = false
    return ret
  end
end
--[[local ec = eval_card
function eval_card()
  Talisman.calculating_card = true
  local ret = ec()
  Talisman.calculating_card = false
  return ret
end--]]
local sm = Card.start_materialize
function Card:start_materialize(a,b,c)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then return end
  return sm(self,a,b,c)
end
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then self:remove() return end
  return sd(self,a,b,c,d)
end
local ss = Card.set_seal
function Card:set_seal(a,b,immediate)
  return ss(self,a,b,Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) or immediate)
end

function Card:get_chip_x_bonus()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (SMODS.multiplicative_stacking(self.ability.x_chips or 1, self.ability.perma_x_chips or 0) or 0) <= 1 then return 0 end
    return SMODS.multiplicative_stacking(self.ability.x_chips or 1, self.ability.perma_x_chips or 0)
end

function Card:get_chip_e_bonus()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.e_chips or 0) <= 1 then return 0 end
    return self.ability.e_chips
end

function Card:get_chip_ee_bonus()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.ee_chips or 0) <= 1 then return 0 end
    return self.ability.ee_chips
end

function Card:get_chip_eee_bonus()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.eee_chips or 0) <= 1 then return 0 end
    return self.ability.eee_chips
end

function Card:get_chip_hyper_bonus()
    if self.debuff then return {0,0} end
    if self.ability.set == 'Joker' then return {0,0} end
	if type(self.ability.hyper_chips) ~= 'table' then return {0,0} end
    if (self.ability.hyper_chips[1] <= 0 or self.ability.hyper_chips[2] <= 0) then return {0,0} end
    return self.ability.hyper_chips
end

function Card:get_chip_e_mult()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.e_mult or 0) <= 1 then return 0 end
    return self.ability.e_mult
end

function Card:get_chip_ee_mult()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.ee_mult or 0) <= 1 then return 0 end
    return self.ability.ee_mult
end

function Card:get_chip_eee_mult()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if (self.ability.eee_mult or 0) <= 1 then return 0 end
    return self.ability.eee_mult
end

function Card:get_chip_hyper_mult()
    if self.debuff then return {0,0} end
    if self.ability.set == 'Joker' then return {0,0} end
	if type(self.ability.hyper_mult) ~= 'table' then return {0,0} end
    if (self.ability.hyper_mult[1] <= 0 or self.ability.hyper_mult[2] <= 0) then return {0,0} end
    return self.ability.hyper_mult
end

--Easing fixes
--Changed this to always work; it's less pretty but fine for held in hand things
local edo = ease_dollars
function ease_dollars(mod, instant)
  if Talisman.config_file.disable_anims then--and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then
    mod = mod or 0
    if to_big(mod) < to_big(0) then inc_career_stat('c_dollars_earned', mod) end
    G.GAME.dollars = G.GAME.dollars + mod
    Talisman.dollar_update = true
  else return edo(mod, instant) end
end

local su = G.start_up
function safe_str_unpack(str)
  local chunk, err = loadstring(str)
  if chunk then
    setfenv(chunk, {Big = Big, BigMeta = BigMeta, OmegaMeta = OmegaMeta, to_big = to_big, inf = 1.79769e308, uncompress_big=uncompress_big})  -- Use an empty environment to prevent access to potentially harmful functions
    local success, result = pcall(chunk)
    if success then
    return result
    else
    print("[Talisman] Error unpacking string: " .. result)
    print(tostring(str))
    return nil
    end
  else
    print("[Talisman] Error loading string: " .. err)
    print(tostring(str))
    return nil
  end
  end
function G:start_up()
  STR_UNPACK = safe_str_unpack
  su(self)
  STR_UNPACK = safe_str_unpack
end

--Skip round animation things
local gfer = G.FUNCS.evaluate_round
function G.FUNCS.evaluate_round()
    if Talisman.config_file.disable_anims then
      if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
          add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = 0.95})
      else
          add_round_eval_row({dollars = 0, name='blind1', pitch = 0.95, saved = true})
      end
      local arer = add_round_eval_row
      add_round_eval_row = function() return end
      local dollars = gfer()
      add_round_eval_row = arer
      add_round_eval_row({name = 'bottom', dollars = Talisman.dollars})
    else
        return gfer()
    end
end

local g_start_run = Game.start_run
function Game:start_run(args)
  local ret = g_start_run(self, args)
  self.GAME.round_resets.ante_disp = self.GAME.round_resets.ante_disp or number_format(self.GAME.round_resets.ante)
  return ret
end

-- Steamodded calculation API: add extra operations
if SMODS and SMODS.calculate_individual_effect then
  local scie = SMODS.calculate_individual_effect
  function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    -- For some reason, some keys' animations are completely removed
    -- I think this is caused by a lovely patch conflict
    --if key == 'chip_mod' then key = 'chips' end
    --if key == 'mult_mod' then key = 'mult' end
    --if key == 'Xmult_mod' then key = 'x_mult' end
    local ret = scie(effect, scored_card, key, amount, from_edition)
    if ret then
      return ret
    end

    if (key == 'e_chips' or key == 'echips' or key == 'Echip_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local chips = SMODS.Scoring_Parameters["chips"]
        chips:modify(chips.current ^ amount - chips.current)
      else
        hand_chips = mod_chips(hand_chips ^ amount)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount, colour =  G.C.EDITION, edition = true})
          elseif key ~= 'Echip_mod' then
              if effect.echip_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.echip_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'e_chips', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'ee_chips' or key == 'eechips' or key == 'EEchip_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local chips = SMODS.Scoring_Parameters["chips"]
        chips:modify(to_big(chips.current):tetrate(amount) - chips.current)
      else
        hand_chips = mod_chips(hand_chips:tetrate(amount))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^"..amount, colour =  G.C.EDITION, edition = true})
          elseif key ~= 'EEchip_mod' then
              if effect.eechip_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eechip_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'ee_chips', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'eee_chips' or key == 'eeechips' or key == 'EEEchip_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local chips = SMODS.Scoring_Parameters["chips"]
        chips:modify(to_big(chips.current):arrow(3, amount) - chips.current)
      else
        hand_chips = mod_chips(hand_chips:arrow(3, amount))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^^"..amount, colour =  G.C.EDITION, edition = true})
          elseif key ~= 'EEEchip_mod' then
              if effect.eeechip_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eeechip_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'eee_chips', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'hyper_chips' or key == 'hyperchips' or key == 'hyperchip_mod') and type(amount) == 'table' then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local chips = SMODS.Scoring_Parameters["chips"]
        chips:modify(to_big(chips.current):arrow(amount[1], amount[2]) - chips.current)
      else
        hand_chips = mod_chips(hand_chips:arrow(amount[1], amount[2]))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = (amount[1] > 5 and ('{' .. amount[1] .. '}') or string.rep('^', amount[1])) .. amount[2], colour =  G.C.EDITION, edition = true})
          elseif key ~= 'hyperchip_mod' then
              if effect.hyperchip_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.hyperchip_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'hyper_chips', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'e_mult' or key == 'emult' or key == 'Emult_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local mult = SMODS.Scoring_Parameters["mult"]
        mult:modify(mult.current ^ amount - mult.current)
      else
        mult = mod_mult(mult ^ amount)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
          elseif key ~= 'Emult_mod' then
              if effect.emult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.emult_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'e_mult', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'ee_mult' or key == 'eemult' or key == 'EEmult_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local mult = SMODS.Scoring_Parameters["mult"]
        mult:modify(to_big(mult.current):arrow(2, amount) - mult.current)
      else
        mult = mod_mult(mult:arrow(2, amount))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
          elseif key ~= 'EEmult_mod' then
              if effect.eemult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eemult_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'ee_mult', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'eee_mult' or key == 'eeemult' or key == 'EEEmult_mod') and amount ~= 1 then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local mult = SMODS.Scoring_Parameters["mult"]
        mult:modify(to_big(mult.current):arrow(3, amount) - mult.current)
      else
        mult = mod_mult(mult:arrow(3, amount))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
          elseif key ~= 'EEEmult_mod' then
              if effect.eeemult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eeemult_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'eee_mult', amount, percent)
              end
          end
      end
      return true
    end

    if (key == 'hyper_mult' or key == 'hypermult' or key == 'hypermult_mod') and type(amount) == 'table' then
      if effect.card then juice_card(effect.card) end
      if SMODS.Scoring_Parameters then
        local mult = SMODS.Scoring_Parameters["mult"]
        mult:modify(to_big(mult.current):arrow(amount[1], amount[2]) - mult.current)
      else
        mult = mod_mult(mult:arrow(amount[1], amount[2]))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      end
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = ((amount[1] > 5 and ('{' .. amount[1] .. '}') or string.rep('^', amount[1])) .. amount[2]).." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
          elseif key ~= 'hypermult_mod' then
              if effect.hypermult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.hypermult_message)
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'hyper_mult', amount, percent)
              end
          end
      end
      return true
    end
  end
  for _, v in ipairs({'e_mult', 'e_chips', 'ee_mult', 'ee_chips', 'eee_mult', 'eee_chips', 'hyper_mult', 'hyper_chips',
                      'emult', 'echips', 'eemult', 'eechips', 'eeemult', 'eeechips', 'hypermult', 'hyperchips',
                      'Emult_mod', 'Echip_mod', 'EEmult_mod', 'EEchip_mod', 'EEEmult_mod', 'EEEchip_mod', 'hypermult_mod', 'hyperchip_mod'}) do
    table.insert(SMODS.scoring_parameter_keys or SMODS.calculation_keys, v)
  end

  -- prvent juice animations
  local smce = SMODS.calculate_effect
  function SMODS.calculate_effect(effect, ...)
    if Talisman.config_file.disable_anims then effect.juice_card = nil end
    return smce(effect, ...)
  end
end

--some debugging functions
--[[local callstep=0
function printCallerInfo()
  -- Get debug info for the caller of the function that called printCallerInfo
  local info = debug.getinfo(3, "Sl")
  callstep = callstep+1
  if info then
      print("["..callstep.."] "..(info.short_src or "???")..":"..(info.currentline or "unknown"))
  else
      print("Caller information not available")
  end
end
local emae = EventManager.add_event
function EventManager:add_event(x,y,z)
  printCallerInfo()
  return emae(self,x,y,z)
end--]]

function HEX(hex)
    if #hex <= 6 then hex = hex.."FF" end
    local _,_,r,g,b,a = hex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
    local color = {tonumber(r,16)/255,tonumber(g,16)/255,tonumber(b,16)/255,tonumber(a,16)/255 or 255}
    return color
  end

local nativefs = require("nativefs")
local lovely = require("lovely")
Trance_config = {palette = "Base Game", font = "m6x11"}
baladir = lovely.mod_dir:sub(1, #lovely.mod_dir-5)
if nativefs.read(baladir .. "/config/Trance.lua") then
    Trance_config = load(nativefs.read(baladir .. "/config/Trance.lua"))()
end
function is_color(v)
    return type(v) == 'table' and #v == 4 and type(v[1]) == "number" and type(v[2]) == "number" and type(v[3]) == "number" and type(v[4]) == "number"
end
function load_file_with_fallback(primary_path, fallback_path, reset_config)
    local success, result = pcall(function() return assert(load(nativefs.read(primary_path)))() end)
    if success then
        return result
    end
    reset_config()
    local fallback_success, fallback_result = pcall(function() return assert(load(nativefs.read(fallback_path)))() end)
    if fallback_success then
        return fallback_result
    end
end
Trance = assert(load(nativefs.read(lovely.mod_dir .. "/Trance/colors/Base Game.lua")))()
Trance_theme = load_file_with_fallback(
    lovely.mod_dir .. "/Trance/colors/" .. (Trance_config.palette or "Base Game") .. ".lua",
    lovely.mod_dir .. "/Trance/colors/Base Game.lua",
    function() Trance_config.palette = "Base Game" end
)
Trance_font = load_file_with_fallback(
    lovely.mod_dir .. "/Trance/fonts/" .. (Trance_config.font or "m6x11") .. ".lua",
    lovely.mod_dir .. "/Trance/fonts/m6x11.lua",
    function() Trance_config.font = "m6x11" end
)
for k, v in pairs(Trance_theme) do
    if is_color(v) then 
        Trance[k] = v
    elseif type(v) == 'table' then
        for _k, _v in pairs(Trance_theme[k]) do
            if is_color(_v) then 
                Trance[k][_k] = _v
            end
        end
    end
end
local file = nativefs.read(lovely.mod_dir .. "/Trance/fonts/"..(Trance_config.font or "m6x11")..".ttf")
local gsl = Game.set_language
function Game:set_language()
    gsl(self)
    local file = nativefs.read(lovely.mod_dir .. "/Trance/fonts/"..(Trance_config.font or "m6x11")..".ttf")
    love.filesystem.write("temp-font.ttf", file)
    G.LANG.font.FONT = love.graphics.newFont("temp-font.ttf", G.TILESIZE * Trance_font.render_scale)
    for k, v in pairs(Trance_font) do
        G.LANG.font[k] = v
    end
    love.filesystem.remove("temp-font.ttf")
end


local files = nativefs.getDirectoryItems(lovely.mod_dir .. "/Trance/colors")
Trance_palettes = {}
for _, v in pairs(files) do
    if v:match("%.lua$") then
        Trance_palettes[#Trance_palettes+1] = v:gsub("%.lua$", "")
    end
end
files = nativefs.getDirectoryItems(lovely.mod_dir .. "/Trance/fonts")
Trance_fonts = {}
for _, v in pairs(files) do
    if v:match("%.lua$") then
        Trance_fonts[#Trance_fonts+1] = v:gsub("%.lua$", "")
    end
end

--color injection
function Trance_set_globals(G, dt)
    for k, v in pairs(Trance) do
        if is_color(v) then 
            if is_color(G.C[k]) then ease_colour(G.C[k],v,dt) else G.C[k] = v end
        elseif type(v) == 'table' then
            if not G.C[k] then G.C[k] = {} end
            for _k, _v in pairs(Trance[k]) do
                if is_color(_v) then 
                    if is_color(G.C[k][_k]) then ease_colour(G.C[k][_k],_v,dt) else G.C[k][_k] = _v end
                end
            end
        end
    end
    if Trance.MULT then ease_colour(G.C.UI_MULT,Trance.MULT,dt) end
    if Trance.CHIPS then ease_colour(G.C.UI_CHIPS,Trance.CHIPS,dt) end
    if G.P_BLINDS then
        for k, v in pairs(Trance.BOSSES) do
            if G.P_BLINDS[k] and G.P_BLINDS[k].boss_colour then G.P_BLINDS[k].boss_colour = v end
        end
    end
end

local iip = Game.init_item_prototypes
function Game:init_item_prototypes()
    iip(self)
    for k, v in pairs(Trance.BOSSES) do
        if G.P_BLINDS[k] and G.P_BLINDS[k].boss_colour then G.P_BLINDS[k].boss_colour = v end
    end
end

G_FUNCS_options_ref = G.FUNCS.options
G.FUNCS.options = function(e)
    G_FUNCS_options_ref(e)
    if love.filesystem.getInfo(baladir .. "/config", "directory") == nil then love.filesystem.createDirectory(baladir .. "/config") end
    nativefs.write(baladir .. "/config/Trance.lua", STR_PACK(Trance_config))
end
G.FUNCS.set_Trance_font = function(x)
    Trance_config.font = x.to_val
    
    Trance_font = assert(load(nativefs.read(lovely.mod_dir .. "/Trance/fonts/"..(Trance_config.font or "m6x11")..".lua")))()
    
    local file = nativefs.read(lovely.mod_dir .. "/Trance/fonts/"..Trance_config.font..".ttf")
    love.filesystem.write("temp-font.ttf", file)
    G.LANG.font.FONT = love.graphics.newFont("temp-font.ttf", G.TILESIZE * Trance_font.render_scale)
    for k, v in pairs(Trance_font) do
        G.LANG.font[k] = v
    end
    for k, v in pairs(G.I.UIBOX) do
        if v.recalculate and type(v.recalculate) == "function" then
            v:recalculate()
        end
    end
    love.filesystem.remove("temp-font.ttf")
end
G.FUNCS.set_Trance_palette = function(x)
    Trance_config.palette = x.to_val
    
    Trance = assert(load(nativefs.read(lovely.mod_dir .. "/Trance/colors/Base Game.lua")))()
    Trance_theme = assert(load(nativefs.read(lovely.mod_dir .. "/Trance/colors/"..Trance_config.palette..".lua")))()
    for k, v in pairs(Trance_theme) do
        if is_color(v) then 
            Trance[k] = v
        elseif type(v) == 'table' then
            for _k, _v in pairs(Trance_theme[k]) do
                if is_color(_v) then 
                    Trance[k][_k] = _v
                end
            end
        end
    end
    Trance_set_globals(G, 1)
end
local createOptionsRef = create_UIBox_options
  function create_UIBox_options()
  contents = createOptionsRef()
  local m = UIBox_button({
  minw = 5,
  button = "tranceMenu",
  label = {
  "Trance"
  },
  colour = G.C.BLUE
  })
  table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, m)
  return contents
end
G.FUNCS.tranceMenu = function(e)
    local tabs = create_tabs({
        snap_to_nav = true,
        tabs = {
            {
                label = "Trance",
                chosen = true,
                tab_definition_function = function()
                    local palette_idx = 0
                    for i = 1, #Trance_palettes do
                        if Trance_palettes[i] == Trance_config.palette then
                            palette_idx = i
                            break
                        end
                    end
                    local font_idx = 0
                    for i = 1, #Trance_fonts do
                        if Trance_fonts[i] == Trance_config.font then
                            font_idx = i
                            break
                        end
                    end
                    return {
                        n = G.UIT.ROOT,
                        config = {
                            emboss = 0.05,
                            minh = 6,
                            r = 0.1,
                            minw = 10,
                            align = "cm",
                            padding = 0.2,
                            colour = G.C.BLACK
                        },
                        nodes = {
                            create_option_cycle({
                                label = "Selected Palette",
                                scale = 0.8,
                                w = 4,
                                options = Trance_palettes,
                                opt_callback = 'set_Trance_palette',
                                current_option = palette_idx,
                            }),
                            create_option_cycle({
                                label = "Selected Font",
                                scale = 0.8,
                                w = 4,
                                options = Trance_fonts,
                                opt_callback = 'set_Trance_font',
                                current_option = font_idx,
                            }),
                        },
                    }
                end
            },
        }})
    G.FUNCS.overlay_menu{
            definition = create_UIBox_generic_options({
                back_func = "options",
                contents = {tabs}
            }),
        config = {offset = {x=0,y=10}}
    }
end
DismissAlert = {}

DismissAlert.COLLECTION_NAMES = { 'P_CENTERS', 'P_BLINDS', 'P_TAGS', 'P_SEALS' }

DismissAlert.COLLECTION_UI_LOOKUP = {
	your_collection_vouchers = { 'P_CENTER_POOLS', 'Voucher' },
	your_collection_tarots = { 'P_CENTER_POOLS', 'Tarot' },
	your_collection_planets = { 'P_CENTER_POOLS', 'Planet' },
	your_collection_spectrals = { 'P_CENTER_POOLS', 'Spectral' },
	your_collection_jokers = { 'P_CENTER_POOLS', 'Joker' },
	your_collection_editions = { 'P_CENTER_POOLS', 'Edition' },
	your_collection_boosters = { 'P_CENTER_POOLS', 'Booster' },
	your_collection_blinds = 'P_BLINDS',
	your_collection_tags = 'P_TAGS',
	your_collection_seals = 'P_SEALS'
}

G.FUNCS.dismissalert_temporary_reset_alerts = function(e)
	for _, k in ipairs(DismissAlert.COLLECTION_NAMES) do
		if G[k] then
			for _, v in pairs(G[k]) do
				if type(v) == 'table' and v.alerted == true then v.alerted = false end
			end
		end
	end

	G.REFRESH_ALERTS = true
	set_alerts()
end

G.FUNCS.dismissalert_dismiss_collection_alert = function(e)
	local args = e and e.config and e.config.ref_table or {}
	local success = false

	if args.id == 'collection' or args.id == 'your_collection' then
		for _, collection in ipairs(DismissAlert.COLLECTION_NAMES) do
			if G[collection] then
				for _, v in pairs(G[collection]) do
					if v.discovered then v.alerted = true end
				end
				success = true
			end
		end
	else
		local ref = DismissAlert.COLLECTION_UI_LOOKUP[args.id]
		local collection = G

		if ref == nil then
			print("DismissAlert :: Unknown collection type:")
			print(args)
		else
			if type(ref) == 'string' then
				collection = G[ref]
			elseif type(ref) == 'table' then
				for _, k in ipairs(ref) do
					if not collection[k] then break end
					collection = collection[k]
				end
			end

			if type(collection) ~= 'table' then
				print("DismissAlert :: Could not find collection " .. tostring(args.id) .. " at " .. tostring(ref))
			else
				for _, v in pairs(collection) do
					if type(v) == 'table' and v.discovered then v.alerted = true end
				end
				success = true
			end
		end
	end

	if success and args.alert_uibox_name and G[args.alert_uibox_name] then
		G[args.alert_uibox_name]:remove()
		G[args.alert_uibox_name] = nil
	end

	G:save_progress()
end
require 'cartomancer.init'

Cartomancer.path = assert(
    Cartomancer.find_self('cartomancer.lua'),
    "Failed to find mod folder. Make sure that `Cartomancer` folder has `cartomancer.lua` file!"
)

Cartomancer.load_mod_file('internal/config.lua', 'cartomancer.config')
Cartomancer.load_mod_file('internal/atlas.lua', 'cartomancer.atlas')
Cartomancer.load_mod_file('internal/ui.lua', 'cartomancer.ui')
Cartomancer.load_mod_file('internal/keybinds.lua', 'cartomancer.keybinds')

Cartomancer.load_mod_file('core/view-deck.lua', 'cartomancer.view-deck')
Cartomancer.load_mod_file('core/flames.lua', 'cartomancer.flames')
Cartomancer.load_mod_file('core/optimizations.lua', 'cartomancer.optimizations')
Cartomancer.load_mod_file('core/jokers.lua', 'cartomancer.jokers')
Cartomancer.load_mod_file('core/hand.lua', 'cartomancer.hand')
Cartomancer.load_mod_file('core/blinds_info.lua', 'cartomancer.blinds_info')
if SMODS then
    Cartomancer.load_mod_file('core/view-deck-steamodded.lua', 'cartomancer.view-deck-steamodded')
end

Cartomancer.load_config()

Cartomancer.INTERNAL_jokers_menu = false

-- TODO dedicated keybinds file? keybinds need to load after config
Cartomancer.register_keybind {
    name = 'hide_joker',
    func = function (controller)
        Cartomancer.hide_hovered_joker(controller)
    end
}

Cartomancer.register_keybind {
    name = 'toggle_tags',
    func = function (controller)
        Cartomancer.SETTINGS.hide_tags = not Cartomancer.SETTINGS.hide_tags
        Cartomancer.update_tags_visibility()
    end
}

Cartomancer.register_keybind {
    name = 'toggle_consumables',
    func = function (controller)
        Cartomancer.SETTINGS.hide_consumables = not Cartomancer.SETTINGS.hide_consumables
    end
}

Cartomancer.register_keybind {
    name = 'toggle_deck',
    func = function (controller)
        Cartomancer.SETTINGS.hide_deck = not Cartomancer.SETTINGS.hide_deck
    end
}

Cartomancer.register_keybind {
    name = 'toggle_jokers',
    func = function (controller)
        if not (G and G.jokers) then
            return
        end
        G.jokers.cart_hide_all = not G.jokers.cart_hide_all

        if G.jokers.cart_hide_all then
            Cartomancer.hide_all_jokers()
        else
            Cartomancer.show_all_jokers()
        end
        Cartomancer.align_G_jokers()
    end
}

Cartomancer.register_keybind {
    name = 'toggle_jokers_buttons',
    func = function (controller)
        Cartomancer.SETTINGS.jokers_controls_buttons = not Cartomancer.SETTINGS.jokers_controls_buttons
    end
}

require 'blueprint.init'

Blueprint.load_mod_file('internal/config.lua', 'internal.config')

Blueprint.load_mod_file('core/settings.lua', 'core.settings')
Blueprint.load_mod_file('internal/assets.lua', 'internal.assets')

Blueprint.load_config()

Blueprint.load_mod_file('core/core.lua', 'core.main')

Blueprint.log "Finished loading core"
