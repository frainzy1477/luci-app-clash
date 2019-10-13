#!/bin/sh /etc/rc.common
subscribe_url=$(uci get clash.config.subscribe_url_clash 2>/dev/null)
subtype=$(uci get clash.config.subcri 2>/dev/null)
urlv2ray=$(uci get clash.config.v2ray 2>/dev/null)
urlssr=$(uci get clash.config.ssr 2>/dev/null)
config_type=$(uci get clash.config.config_type 2>/dev/null)

CONFIG_YAML="/usr/share/clash/config/sub/config.yaml" 

	if pidof clash >/dev/null; then
		if [ $subtype == "clash" ];then
			wget-ssl --no-check-certificate --user-agent="Clash/OpenWRT" $subscribe_url -O 2>&1 >1 $CONFIG_YAML
		fi
		if [ $config_type == "sub" ];then 
		/etc/init.d/clash restart 2>/dev/null
		fi
	else
		if [ $subtype == "clash" ];then
			wget-ssl --no-check-certificate --user-agent="Clash/OpenWRT" $subscribe_url -O 2>&1 >1 $CONFIG_YAML
		fi
	fi

