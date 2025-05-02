local function notify(title, level, msg)
  if title == "" then
    title = level
  end

  local levels = {
    ERROR = vim.log.levels.ERROR,
    INFO = vim.log.levels.INFO,
    OFF = vim.log.levels.OFF,
    WARN = vim.log.levels.WARN,
    DEBUG = vim.log.levels.DEBUG,
    -- TRACE = vim.log.level.TRACE,
  }

  if type(msg) == "table" then
    msg = require("vim.inspect").inspect(msg)
  end

  vim.notify(msg, levels[level], {
    title = title,
  })
end

local function notify_error(title, msg)
  notify(title, "ERROR", msg)
end

local function notify_info(title, msg)
  notify(title, "INFO", msg)
end

local function notify_off(title, msg)
  notify(title, "OFF", msg)
end

local function notify_warn(title, msg)
  notify(title, "WARN", msg)
end

local function notify_debug(title, msg)
  notify(title, "DEBUG", msg)
end

local function notify_trace(title, msg)
  notify(title, "TRACE", msg)
end

--------------------------------------------------------------------------------

local function plugin_finder(file, name)
  local plugins = require("plugins." .. file)

  for _, plugin in pairs(plugins) do
    if plugin[1] == name then
      return plugin
    end
  end

  return false
end

local function table_to_json(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. table_to_json(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

return {
  plugin_finder = plugin_finder,
  table_to_json = table_to_json,
  notify = {
    error = notify_error,
    info = notify_info,
    off = notify_off,
    warn = notify_warn,
    debug = notify_debug,
    trace = notify_trace,
  },
}
