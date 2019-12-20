
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = require("luci.model.uci").cursor()


m = Map("clash")
s = m:section(TypedSection, "clash")
m.pageaction = false
s.anonymous = true
s.addremove=false

log = s:option(TextValue, "clog")
log.template = "clash/status_log"

o = s:option(Button,"log")
o.inputtitle = translate("Clear Logs")
o.write = function()
  SYS.call('echo "0" > /usr/share/clash/logstatus_check 2>&1 &')
  SYS.call('echo "" > /tmp/clash.log 2>&1 &')
  HTTP.redirect(DISP.build_url("admin", "services", "clash", "log"))
end

return m
