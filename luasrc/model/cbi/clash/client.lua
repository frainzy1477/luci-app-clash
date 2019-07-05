
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"


m = Map("clash")
s = m:section(TypedSection, "clash")
s.anonymous = true


o = s:option( Flag, "enable")
o.title = translate("Enable")
o.default = 0
o.rmempty = false
o.description = translate("After clash start running, wait a moment for servers to resolve")

o = s:option(Value, "proxy_port")
o.title = translate("Redir Port")
o.default = 7892
o.datatype = "port"
o.rmempty = false
o.description = translate("Redir Port")

o = s:option(Value, "dash_port")
o.title = translate("Dashboard Port")
o.default = 9090
o.datatype = "port"
o.rmempty = false
o.description = translate("Dashboard Port")

o = s:option(Value, "dash_pass")
o.title = translate("Dashboard Secret")
o.default = 123456
o.rmempty = false
o.description = translate("Dashboard Secret")

o = s:option(ListValue, "level", translate("Log level"))
o.description = translate("Choose Log Level")
o:value("info", translate("info"))
o:value("silent", translate("silent"))
o:value("warning", translate("warning"))
o:value("error", translate("error"))
o:value("debug", translate("debug"))

o = s:option(Flag, "auto_update", translate("Auto Update"))
o.rmempty = false
o.description = translate("Auto Update Server subscription")


o = s:option(ListValue, "auto_update_time", translate("Update time (every day)"))
for t = 0,23 do
o:value(t, t..":00")
end
o.default=0
o.rmempty = false
o.description = translate("Daily Server subscription update time")

o = s:option(Value, "subscribe_url")
o.title = translate("Subcription Url")
o.description = translate("Server Subscription Address")
o.rmempty = true

o = s:option(Button,"update")
o.title = translate("Update Subcription")
o.inputtitle = translate("Update Configuration")
o.inputstyle = "reload"
o.write = function()
  os.execute("mv /etc/clash/config.yaml /etc/clash/config.bak")
  SYS.call("bash /usr/share/clash/clash.sh >>/tmp/clash.log 2>&1 &")
  HTTP.redirect(DISP.build_url("admin", "services", "clash", "client"))
end


local apply = luci.http.formvalue("cbi.apply")
if apply then
	os.execute("/etc/init.d/clash restart >/dev/null 2>&1 &")
end


return m


