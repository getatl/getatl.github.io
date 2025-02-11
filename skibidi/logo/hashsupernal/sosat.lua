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


local hiddenProperties = {}
function sethiddenproperty(obj, property, value)
    if not obj or type(property) ~= "string" then
        error("Failed to set hidden property '" .. tostring(property) .. "' on the object: " .. tostring(obj))
    end
    hiddenProperties[obj] = hiddenProperties[obj] or {}
    hiddenProperties[obj][property] = value
    return true
end

function gethiddenproperty(obj, property)
    if not obj or type(property) ~= "string" then
        error("Failed to get hidden property '" .. tostring(property) .. "' from the object: " .. tostring(obj))
    end
    local value = hiddenProperties[obj] and hiddenProperties[obj][property] or nil
    local isHidden = true
    return value or (property == "size_xml" and 5), isHidden
end
function hookmetamethod(t, index, func)
	assert(type(t) == "table" or type(t) == "userdata", "invalid argument #1 to 'hookmetamethod' (table or userdata expected, got " .. type(t) .. ")", 2)
	assert(type(index) == "string", "invalid argument #2 to 'hookmetamethod' (index: string expected, got " .. type(t) .. ")", 2)
	assert(type(func) == "function", "invalid argument #3 to 'hookmetamethod' (function expected, got " .. type(t) .. ")", 2)
	local o = t
	local mt = Xeno.debug.getmetatable(t)
	mt[index] = func
	t = mt
	return o
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
    print(text or "Current identity is faked lol real identity is 3", 7)
end
