
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = luci.model.uci.cursor()
local fs = require "luci.clash"
local http = luci.http
local clash = "clash"

kk = Map(clash)
r = kk:section(TypedSection, "clash", translate("Auto Update Config"))
r.anonymous = true
kk.pageaction = false

o = r:option(Flag, "auto_update", translate("Auto Update"))
o.description = translate("Auto Update Server subscription")

o = r:option(ListValue, "auto_update_time", translate("Update time (every day)"))
o:value("1", translate("Every Hour"))
o:value("6", translate("Every 6 Hours"))
o:value("12", translate("Every 12 Hours"))
o:value("24", translate("Every 24 Hours"))
o.description = translate("Daily Server subscription update time. Only update config in use")

o = r:option(Button, "Apply")
o.title = translate("Save & Apply")
o.inputtitle = translate("Save & Apply")
o.inputstyle = "apply"
o.write = function()
  kk.uci:commit("clash")
end




m = Map("clash")
s = m:section(TypedSection, "clash" , translate("Clear Clash Log"))
m.pageaction = false
s.anonymous = true
s.addremove=false

o = s:option(Flag, "auto_clear_log", translate("Auto Clear Log"))
o.description = translate("Auto Clear Log")


o = s:option(ListValue, "clear_time", translate("Clear Time (Time of Day)"))
o:value("1", translate("Every Hour"))
o:value("6", translate("Every 6 Hours"))
o:value("12", translate("Every 12 Hours"))
o:value("24", translate("Every 24 Hours"))
o.description = translate("Clear Log Time")

o=s:option(Button,"clear_clear")
o.inputtitle = translate("Save & Apply")
o.title = translate("Save & Apply")
o.inputstyle = "reload"
o.write = function()
  m.uci:commit("clash")
end


r = m:section(TypedSection, "addtype", translate("IP Rules"))
r.anonymous = true
r.addremove = true
r.sortable = false
r.template = "cbi/tblsection"
r.extedit = luci.dispatcher.build_url("admin/services/clash/ip-rules/%s")
function r.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(r.extedit % sid)
		return
	end
end

o = r:option(DummyValue, "type", translate("Type"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end


o = r:option(DummyValue, "p-group", translate("Policy Groups"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end


local t = {
    {Load,Apply}
}

k = Form("apply")
k.reset = false
k.submit = false
s = k:section(Table, t)


o = s:option(Button, "Load") 
o.inputtitle = translate("Load Groups")
o.inputstyle = "apply"
o.write = function()
  m.uci:commit("clash")
  luci.sys.call("bash /usr/share/clash/load_groups.sh >/dev/null 2>&1 &")
  luci.sys.call("sleep 3")
  HTTP.redirect(luci.dispatcher.build_url("admin", "services", "clash", "settings", "other"))   
end

o = s:option(Button, "Apply")
o.inputtitle = translate("Save & Apply")
o.inputstyle = "apply"
o.write = function()
  m.uci:commit("clash")
  if luci.sys.call("pidof clash >/dev/null") == 0 then
	SYS.call("/etc/init.d/clash restart >/dev/null 2>&1 &")
    luci.http.redirect(luci.dispatcher.build_url("admin", "services", "clash"))
  else
  	HTTP.redirect(luci.dispatcher.build_url("admin", "services", "clash", "settings", "other"))
  end
end

return kk, m, r, k
