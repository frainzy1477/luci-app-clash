
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local uci = require("luci.model.uci").cursor()
local fs = require "luci.clash"
local http = luci.http


ful = SimpleForm("upload", nil)
sul =ful:section(SimpleSection, "", translate(""))
o = sul:option(FileUpload, "")
o.title = translate("Upload Config")
o.template = "clash/clash_upload"
um = sul:option(DummyValue, "", nil)
um.template = "clash/clash_dvalue"

local dir, fd
dir = "/usr/share/clash/config/upload/"
http.setfilehandler(
	function(meta, chunk, eof)
		if not fd then
			if not meta then return end

			if	meta and chunk then fd = nixio.open(dir .. meta.file, "w") end

			if not fd then
				um.value = translate("upload file error.")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
			fd = nil
			local clash_conf = "/usr/share/clash/config/upload/config.yml"
			if NXFS.access(clash_conf) then
				  SYS.call("mv /usr/share/clash/config/upload/config.yml /usr/share/clash/config/upload/config.yaml")
			end
			um.value = translate("File saved to") .. ' "/usr/share/clash/config/upload/"'
			
		end
	end
)

if luci.http.formvalue("upload") then


	local f = luci.http.formvalue("ulfile")
	if #f <= 0 then
		um.value = translate("No specify upload file.")
	end
end


m = Map("clash")
s = m:section(TypedSection, "clash")
m.pageaction = false
s.anonymous = true
s.addremove=false


local conf = "/usr/share/clash/config/upload/config.yaml"
sev = s:option(TextValue, "conf")
sev.readonly=true
sev.rows = 20
sev.wrap = "off"
sev.cfgvalue = function(self, section)
	return NXFS.readfile(conf) or ""
end
sev.write = function(self, section, value)
end


return ful , m
