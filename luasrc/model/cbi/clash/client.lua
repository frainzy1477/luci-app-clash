local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = require("luci.model.uci").cursor()
local fs = require "luci.clash"
local clash = "clash"


ful = Form("upload", nil)
ful.reset = false
ful.submit = false

m = Map("clash")
s = m:section(TypedSection, "clash")
s.anonymous = true

o = s:option(ListValue, "config_type", translate("Config Type"))
o.default = "sub"
o:value("sub", translate("Subscription Config"))
o:value("upl", translate("Uploaded Config"))
o:value("cus", translate("Custom Config"))
o.description = translate("Select Configuration type")

o = s:option(Flag, "auto_update", translate("Auto Update"))
o.description = translate("Auto Update Server subscription")
o:depends("config_type", "sub")

o = s:option(ListValue, "auto_update_time", translate("Update time (every day)"))
for t = 0,23 do
o:value(t, t..":00")
end
o.default=0
o.description = translate("Daily Server subscription update time")
o:depends("config_type", "sub")


o = s:option(ListValue, "subcri", translate("Subcription Type"))
o.default = clash
o:value("clash", translate("clash"))
o:value("v2rayn2clash", translate("v2rayn2clash"))
o:value("surge2clash", translate("surge2clash"))
o.description = translate("Select Subcription Type, enter only your subcription url without https://tgbot.lbyczf.com/*?")
o:depends("config_type", "sub")


md = s:option(Flag, "cusrule", translate("Enabled Custom Rule"))
md.default = 1
md.description = translate("Enabled Custom Rule")
md:depends("subcri", 'v2rayn2clash')
o:depends("config_type", "sub")

o = s:option(Value, "subscribe_url")
o.title = translate("Subcription Url")
o.description = translate("Server Subscription Address")
o.rmempty = true
o:depends("config_type", "sub")

o = s:option(Button,"update")
o:depends("config_type", "sub")
o.title = translate("Update Subcription")
o.inputtitle = translate("Update")
o.description = translate("Update Config")
o.inputstyle = "reload"
o.write = function()
  os.execute("sed -i '/enable/d' /etc/config/clash")
  uci:commit("clash")
  SYS.call("rm -rf /tmp/clash.log")
  SYS.call("sh /usr/share/clash/clash.sh >>/tmp/clash.log 2>&1 &")
  HTTP.redirect(DISP.build_url("admin", "services", "clash", "client"))
end


o = s:option(Button,"enable")
o.title = translate("Start Client")
o.inputtitle = translate("Start Client")
o.description = translate("Enable/Start/Restart Client")
o.inputstyle = "apply"
o.write = function()
  uci:set("clash", "config", "enable", 1)
  luci.sys.call("uci commit clash")
  SYS.call("/etc/init.d/clash restart >/dev/null 2>&1 &")
end


o = s:option(Button,"disable")
o.title = translate("Stop Client")
o.inputtitle = translate("Stop Client")
o.description = translate("Disable/Stop Client")
o.inputstyle = "reset"
o.write = function()
  uci:set("clash", "config", "enable", 0)
  luci.sys.call("uci commit clash")
  SYS.call("/etc/init.d/clash stop >/dev/null 2>&1 &")
end

return m, ful

