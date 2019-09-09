
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = require("luci.model.uci").cursor()
local fs = require "luci.clash"
local http = luci.http

ful = Form("upload", nil)
ful.reset = false
ful.submit = false


m = Map("clash")
s = m:section(TypedSection, "clash")
s.anonymous = true
s.addremove=false


local conf = "/etc/clash/custom/config.yaml"
sev = s:option(TextValue, "conf")
sev.readonly=true
--update_time = SYS.exec("ls -l --full-time /etc/clash/config.yaml|awk '{print $6,$7;}'")
--sev.description = update_time
--sev.description = translate("Changes to config file must be made from source")
sev.rows = 20
sev.wrap = "off"
sev.cfgvalue = function(self, section)
	return NXFS.readfile(conf) or ""
end
sev.write = function(self, section, value)
end


o = s:option(Button,"configrm")
o.inputtitle = translate("Delete Config")
o.write = function()
  SYS.call("rm -rf /etc/clash/custom/config.yaml")
end

o = s:option(Button, "Download") 
o.inputtitle = translate("Download Config")
o.inputstyle = "apply"
o.write = function ()
	local sPath, sFile, fd, block
	sPath = "/etc/clash/custom/config.yaml"
	sFile = NXFS.basename(sPath)
	if fs.isdirectory(sPath) then
		fd = io.popen('tar -C "%s" -cz .' % {sPath}, "r")
		sFile = sFile .. ".tar.gz"
	else
		fd = nixio.open(sPath, "r")
	end
	if not fd then
		return
	end
	HTTP.header('Content-Disposition', 'attachment; filename="%s"' % {sFile})
	HTTP.prepare_content("application/octet-stream")
	while true do
		block = fd:read(nixio.const.buffersize)
		if (not block) or (#block ==0) then
			break
		else
			HTTP.write(block)
		end
	end
	fd:close()
	HTTP.close()
end

return ful , m
