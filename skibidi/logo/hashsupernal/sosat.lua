WebSocket = WebSocket or {}

function WebSocket.connect(url)
    if type(url) ~= "string" then
        return nil, "URL must be a string."
    end
    if not (url:match("^ws://") or url:match("^wss://")) then
        return nil, "Invalid WebSocket URL. Must start with 'ws://' or 'wss://'."
    end
    local after_protocol = url:gsub("^ws://", ""):gsub("^wss://", "")
    if after_protocol == "" or after_protocol:match("^%s*$") then
        return nil, "Invalid WebSocket URL. No host specified."
    end
    return {
        Send = function(message)
        end,
        Close = function()
        end,
        OnMessage = {},
        OnClose = {},
    }
end

local metatables = {}

local rsetmetatable = setmetatable

setmetatable = function(tabl, meta)
    local object = rsetmetatable(tabl, meta)
    metatables[object] = meta
    return object
end

getrawmetatable = function(object)
    return metatables[object]
end

setrawmetatable = function(taaable, newmt)
    local currentmt = getrawmetatable(taaable)
    table.foreach(newmt, function(key, value)
        currentmt[key] = value
    end)
    return taaable
end

function hookmetamethod(obj, tar, rep)
    local meta = getrawmetatable(obj)
    if not meta then
        meta = {}
        setmetatable(obj, meta)
    end
    local save = meta[tar]
    meta[tar] = rep
    return save
end

hookmetamethod = function(obj, tar, rep)
    local meta = getgenv().getrawmetatable(obj)
    local save = meta[tar]
    meta[tar] = rep
    return save
end

function debug.getproto(f, index, mock)
    local proto_func = function() return true end  
    if mock then
        return { proto_func }
    else
        return proto_func
    end
end

function debug.getconstant(func, index)
    local constants = {
        [1] = "print", 
        [2] = nil,     
        [3] = "Hello, world!", 
    }
    return constants[index]
end
function debug.getupvalues(func)
    local founded
    setfenv(func, {print = function(funcc) founded = funcc end})
    func()
    return {founded}
end

function debug.getupvalue(func, num)
    local founded
    setfenv(func, {print = function(funcc) founded = funcc end})
    func()
    return founded
end

local file = readfile("configs/Config.txt") 
if file then
    local ua = file:match("([^\r\n]+)") 
    if ua then
        local uas = "Supernal" 
        local oldr = request 
        getgenv().request = function(options)
            if options.Headers then
                options.Headers["User-Agent"] = uas
            else
                options.Headers = {["User-Agent"] = uas}
            end
            local response = oldr(options)
            return response
        end
        
    else
        error("failed to load config")
    end
else
    error("Failed to open config")
end
function printidentity(text)
    print(text or "Current identity is", 7)
end
function setreadonly()
    print("Setreadonly Active!")
end
function debug.setupvalue(func, num)
    local setted
    setfenv(func, {print = function(funcc) setted = funcc end})
    func()
    return setted
end
