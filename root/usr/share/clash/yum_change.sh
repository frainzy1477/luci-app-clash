#!/bin/bash
CONFIG_YAML="/etc/clash/config.yaml"
CONFIG_YAML_SUB="/etc/clash/sub/config.yaml"
CONFIG_YAML_UPL="/etc/clash/upload/config.yaml"
CONFIG_YAML_CUS="/etc/clash/custom/config.yaml"

select_config(){
#=========================================================================================================================== 
config_type=$(uci get clash.config.config_type 2>/dev/null)
if [ -f $CONFIG_YAML ];then 
	rm -rf $CONFIG_YAML
fi
if [ $config_type == "sub" ];then 
	cp $CONFIG_YAML_SUB $CONFIG_YAML
elif [ $config_type == "upl" ];then 
	cp $CONFIG_YAML_UPL $CONFIG_YAML
elif [ $config_type == "cus" ];then 
	cp $CONFIG_YAML_CUS $CONFIG_YAML
fi
#=========================================================================================================================== 
}

select_config

#===========================================================================================================================
		mode=$(uci get clash.config.mode 2>/dev/null)
		da_password=$(uci get clash.config.dash_pass 2>/dev/null)
		redir_port=$(uci get clash.config.redir_port 2>/dev/null)
		http_port=$(uci get clash.config.http_port 2>/dev/null)
		socks_port=$(uci get clash.config.socks_port 2>/dev/null)
		dash_port=$(uci get clash.config.dash_port 2>/dev/null)
		log_level=$(uci get clash.config.level 2>/dev/null)
		subtype=$(uci get clash.config.subcri 2>/dev/null)
		lan_ip=$(uci get network.lan.ipaddr 2>/dev/null)		
if [ $mode -eq 1 ];  then	
		
		sed -i "/Proxy:/i\#clash-openwrt" $CONFIG_YAML
                sed -i "/#clash-openwrt/a\#=============" $CONFIG_YAML
		sed -i "/#=============/a\ " $CONFIG_YAML
		sed -i '1,/#clash-openwrt/d' $CONFIG_YAML		
		mv /etc/clash/config.yaml /etc/clash/dns.yaml
		cat /usr/share/clash/dns.yaml /etc/clash/dns.yaml > $CONFIG_YAML 
		rm -rf /etc/clash/dns.yaml
		sed -i "1i\port: ${http_port}" $CONFIG_YAML
		sed -i "2i\socks-port: ${socks_port}" $CONFIG_YAML
		sed -i "3i\redir-port: ${redir_port}" $CONFIG_YAML
		sed -i "4i\allow-lan: true" $CONFIG_YAML
		sed -i "5i\mode: Rule" $CONFIG_YAML
		sed -i "6i\log-level: ${log_level}" $CONFIG_YAML
		sed -i "7i\external-controller: ${lan_ip}:${dash_port}" $CONFIG_YAML
		sed -i "8i\secret: '${da_password}'" $CONFIG_YAML
		sed -i "9i\external-ui: "/usr/share/clash/dashboard"" $CONFIG_YAML
		sed -i "10i\ " $CONFIG_YAML
		sed -i "11i\ " $CONFIG_YAML
		sed -i '/#=============/ d' $CONFIG_YAML		
else
		if [ $subtype == "v2rayn2clash" ];then
		sed -i "/Proxy:/i\#clash-openwrt" $CONFIG_YAML
                sed -i "/#clash-openwrt/a\#=============" $CONFIG_YAML
		sed -i "/#=============/a\ " $CONFIG_YAML
		sed -i '1,/#clash-openwrt/d' $CONFIG_YAML		
		mv $CONFIG_YAML /etc/clash/dns.yaml
		cat /usr/share/clash/dns.yaml /etc/clash/dns.yaml > $CONFIG_YAML 
		rm -rf /etc/clash/dns.yaml

		else

		sed -i "/dns:/i\#clash-openwrt" $CONFIG_YAML
               sed -i "/#clash-openwrt/a\#=============" $CONFIG_YAML
		sed -i '1,/#clash-openwrt/d' $CONFIG_YAML
		fi

		sed -i "1i\port: ${http_port}" $CONFIG_YAML
		sed -i "2i\socks-port: ${socks_port}" $CONFIG_YAML
		sed -i "3i\redir-port: ${redir_port}" $CONFIG_YAML
		sed -i "4i\allow-lan: true" $CONFIG_YAML
		sed -i "5i\mode: Rule" $CONFIG_YAML
		sed -i "6i\log-level: ${log_level}" $CONFIG_YAML
		sed -i "7i\external-controller: ${lan_ip}:${dash_port}" $CONFIG_YAML
		sed -i "8i\secret: '${da_password}'" $CONFIG_YAML
		sed -i "9i\external-ui: "/usr/share/clash/dashboard"" $CONFIG_YAML
		sed -i "10i\ " $CONFIG_YAML
		sed -i "11i\ " $CONFIG_YAML
		sed -i '/#=============/ d' $CONFIG_YAML
fi
#=========================================================================================================================== 
