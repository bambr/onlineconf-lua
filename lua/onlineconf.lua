local posix = require('posix');
local cjson = require('cjson.safe');

local onlineconf = {
    config_dir    = '/usr/local/etc/onlineconf',
    expires       = 15,

    modules       = {},
    loaded        = {},
    checked       = {},
}


local function _get_module_filename(module_name)
    if module_name:match('[^%w\-]') then
        error("onlineconf: invalid onlineconf module '"  .. module_name .. "'")
    end
    return onlineconf.config_dir .. '/' .. module_name .. '.conf'
end

function onlineconf.module(module_name)
    if onlineconf.modules[module_name] then
        if os.time()-onlineconf.checked[module_name] < onlineconf.expires then
-- print "DEBUG: not expired"
            return onlineconf.modules[module_name]
        elseif posix.stat( _get_module_filename(module_name), 'mtime') == onlineconf.loaded[module_name] then
-- print "DEBUG: not changed"
            onlineconf.checked[module_name] = os.time()
            return onlineconf.modules[module_name]
        end
    end

-- print "DEBUG: load now"
    local data = {}
    local meta = {}
    for line in io.lines( _get_module_filename(module_name) ) do
        local key, value;
        key, value = line:match("^%s*#!%s*(%S+)%s+(.+)$")
        if key then
            meta[key] = value
        elseif line == '#EOF' then
            meta.Eof = 1
            break
        elseif not line:match("^%s*#") then
            key, value = line:match("^%s*(%S+)%s+(.+)$")
            if key then
                value = value:gsub("\\r", "\r")
                value = value:gsub("\\n", "\n")
                local is_json = key:match("^(.+):JSON$");
                if is_json and value then
                    local error;
                    key = is_json;
                    value, error = cjson.decode(value)
                    if not value then
                        error("onlineconf: can't parse json variable "..key.." => "..value..": "..error)
                        value=nil
                    end
                end
                data[key] = value
            end
        end
    end
    if not meta.Eof then
        error("onlineconf: cant find EOF marker for module "..module_name)
        return
    elseif not meta.Version or not meta.Name then
        error("onlineconf: invalid name/version variable(s) for module "..module_name)
        return
    elseif meta.Name ~= module_name then
        error("onlineconf: module mismatch, config "..module_name.." contains data for module "..meta.Name)
        return
    end

    if onlineconf.modules[module_name] then
        for k in pairs(onlineconf.modules[module_name]) do
            onlineconf.modules[module_name][k] = nil
        end
        for k in pairs(data) do
            onlineconf.modules[module_name][k] = data[k]
        end
    else
        onlineconf.modules[module_name] = data
    end
    onlineconf.checked[module_name] = os.time()
    onlineconf.loaded[module_name]  = onlineconf.checked[module_name]
    return onlineconf.modules[module_name]
end

return onlineconf;
