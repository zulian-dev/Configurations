if os.getenv("NVIMLANG") == 'none' then
	return false
end

require("config.cron")
require("config.lazy")
require("config.options")
require("config.mappings")
