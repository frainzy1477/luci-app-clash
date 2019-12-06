local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = require("luci.model.uci").cursor()
local fs = require "luci.clash"
local clash = "clash"


m = Map("clash")
s = m:section(TypedSection, "clash")
s.anonymous = true
m.pageaction = false

o = s:option(ListValue, "core", translate("Core"))
o.default = "clashcore"
if nixio.fs.access("/etc/clash/clash") then
o:value("1", translate("Clash"))
end
if nixio.fs.access("/usr/bin/clash") then
o:value("2", translate("Clashr"))
end
o.description = translate("Select core, clashr support ssr while clash does not.")


o = s:option(ListValue, "config_type", translate("Config Type"))
o.default = "sub"
o:value("sub", translate("Subscription Config"))
o:value("upl", translate("Uploaded Config"))
o:value("cus", translate("Custom Config"))
o.description = translate("Select Configuration type")


o = s:option(Button,"enable")
o.title = translate("Start Client")
o.inputtitle = translate("Start Client")
o.description = translate("Enable/Start/Restart Client")
o.inputstyle = "apply"
o.write = function()
  m.uci:set("clash", "config", "enable", 1)
  luci.sys.call("uci commit clash")
  SYS.call("/etc/init.d/clash restart >/dev/null 2>&1 &")
  luci.http.redirect(luci.dispatcher.build_url("admin", "services", "clash"))
end


o = s:option(Button,"disable")
o.title = translate("Stop Client")
o.inputtitle = translate("Stop Client")
o.description = translate("Disable/Stop Client")
o.inputstyle = "reset"
o.write = function()
  m.uci:set("clash", "config", "enable", 0)
  luci.sys.call("uci commit clash")
  SYS.call("/etc/init.d/clash stop >/dev/null 2>&1 &")
  luci.http.redirect(luci.dispatcher.build_url("admin", "services", "clash"))
end



return m

