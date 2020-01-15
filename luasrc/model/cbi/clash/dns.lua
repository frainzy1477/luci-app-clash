
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

y = s:option(ListValue, "dnsforwader", translate("DNS Forwarding"))
y:value("0", translate("disabled"))
y:value("1", translate("enabled"))
y.description = translate("Set custom DNS forwarder in DHCP and DNS Settings and forward all dns traffic to clash")

deldns = s:option(Flag, "delan", translate("Remove Lan DNS"))
deldns.description = translate("Remove Lan custom DNS Servers when client is disabled")

cdns = s:option(Flag, "culan", translate("Enable Lan DNS"))
cdns.default = 1
cdns.description = translate("Enabling will set custom DNS Servers for Lan")
cdns:depends("dnsforwader", 0)

dns = s:option(DynamicList, "landns", translate("Lan DNS servers"))
dns.description = translate("Set custom DNS Servers for Lan")
dns.datatype = "ipaddr"
dns.cast     = "string"
dns:depends("culan", 1)

y = s:option(ListValue, "ipv6", translate("Enable ipv6"))
y:value("0", translate("disabled"))
y:value("1", translate("enabled"))
y.description = translate("Allow ipv6 traffic through clash")

md = s:option(Flag, "mode", translate("Custom DNS"))
md.default = 1
md.rmempty = false
md.description = translate("Enabling Custom DNS will Overwrite your config.yaml dns section")

local dns = "/usr/share/clash/dns.yaml"
o = s:option(TextValue, "dns",translate("Modify yaml DNS"))
o.template = "clash/tvalue"
o.rows = 26
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(dns) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(dns, value:gsub("\r\n", "\n"))
end
o.description = translate("NB: press ENTER to create a blank line at the end of input.")
o:depends("mode", 1)


o = s:option(Button, "Apply")
o.inputtitle = translate("Save & Apply")
o.inputstyle = "apply"
o.write = function()
local clash_conf = "/etc/clash/config.yaml"
if NXFS.access(clash_conf) then
	uci:commit("clash")
	SYS.call("sh /usr/share/clash/yum_change.sh 2>&1 &")
	if luci.sys.call("pidof clash >/dev/null") == 0 then
	SYS.call("/etc/init.d/clash restart >/dev/null 2>&1 &")
    luci.http.redirect(luci.dispatcher.build_url("admin", "services", "clash"))
	end
else
  	uci:commit("clash")
  	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "clash" , "settings", "dns"))
end
end


return m


