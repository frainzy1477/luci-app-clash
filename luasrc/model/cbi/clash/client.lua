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
--m.pageaction = false
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"))
o.default = 0
o.rmempty = false
o.description = translate("Enable")


o = s:option(ListValue, "config_type", translate("Config Type"))
o.default = "sub"
o:value("sub", translate("Subscription Config"))
o:value("upl", translate("Uploaded Config"))
o:value("cus", translate("Custom Config"))
o.description = translate("Select Configuration type")
o:depends("enable", "1")

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
  SYS.call("rm -rf /tmp/clash.log >/dev/null 2>&1 &")
  SYS.call("sh /usr/share/clash/clash.sh >>/tmp/clash.log 2>&1 &")
  HTTP.redirect(DISP.build_url("admin", "services", "clash", "client"))
end




local apply = luci.http.formvalue("cbi.apply")
if apply then
    uci:commit("clash")
	os.execute("/etc/init.d/clash restart >/dev/null 2>&1 &")
end

return m

