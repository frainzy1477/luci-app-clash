local m, s, o
local clash = "clash"
local uci = luci.model.uci.cursor()
--local fs = require "nixio.fs"
local sys = require "luci.sys"
local sid = arg[1]
local fs = require "luci.clash"

m = Map(clash, translate("Edit IP Rule & Group"))
--m.pageaction = false
m.redirect = luci.dispatcher.build_url("admin/services/clash/settings/other")
if m.uci:get(clash, sid) ~= "addtype" then
	luci.http.redirect(m.redirect)
	return
end





s = m:section(NamedSection, sid, "addtype")
s.anonymous = true
s.addremove   = false

o = s:option(ListValue, "type", translate("Type"))
o.rmempty = false
o.description = translate("Choose Type")
o:value("DST-PORT", translate("DST-PORT"))
o:value("SRC-PORT", translate("SRC-PORT"))
o:value("SRC-IP-CIDR", translate("SRC-IP-CIDR"))
o:value("IP-CIDR", translate("IP-CIDR"))
o:value("DOMAIN", translate("DOMAIN"))
o:value("DOMAIN-KEYWORD", translate("DOMAIN-KEYWORD"))
o:value("DOMAIN-SUFFIX", translate("DOMAIN-SUFFIX"))


o = s:option(ListValue, "p-group", translate("Select Proxy Group"))
uci:foreach("clash", "conf_groups",
		function(s)
		  if s.name ~= "" and s.name ~= nil then
			   o:value(s.name)
			end
		end)
o:value("DIRECT")
o:value("REJECT")
o.rmempty = true
o.description = translate("Select a policy group to add rule")


o = s:option(DynamicList, "ip-addr", translate("IP/Domain/Address"))
o.rmempty = false


return m
