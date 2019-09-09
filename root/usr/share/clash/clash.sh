#!/bin/bash
subscribe_url=$(uci get clash.config.subscribe_url 2>/dev/null)
subtype=$(uci get clash.config.subcri 2>/dev/null)
urlv2ray=$(uci get clash.config.v2ray 2>/dev/null)
urlsurge=$(uci get clash.config.surge 2>/dev/null)
cusrule=$(uci get clash.config.cusrule 2>/dev/null)
config_type=$(uci get clash.config.config_type 2>/dev/null)
CONFIG_YAML="/etc/clash/sub/config.yaml"
CONFIG_YAML_TEMP="/etc/clash/server.yaml"
CONFIG_YAML_RULE="/usr/share/clash/rule.yaml"
if [ $config_type == "sub" ];then 
if pidof clash >/dev/null; then
rm -rf /etc/clash/config.bak 2> /dev/null
if [ $subtype == "clash" ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $subscribe_url -O 2>&1 >1 $CONFIG_YAML
elif [ $subtype == "v2rayn2clash" ];then
if [ $cusrule == 1 ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $urlv2ray.$subscribe_url -O 2>&1 >1 $CONFIG_YAML_TEMP
if [ -f $CONFIG_YAML_TEMP ];then
sed -i '/Rule:/,$d' $CONFIG_YAML_TEMP 
cat $CONFIG_YAML_TEMP $CONFIG_YAML_RULE > $CONFIG_YAML 
fi
else
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $urlv2ray.$subscribe_url -O 2>&1 >1 $CONFIG_YAML
fi
elif [ $subtype == "surge2clash" ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $urlsurge.$subscribe_url -O 2>&1 >1 $CONFIG_YAML
fi
rm -rf $CONFIG_YAML_TEMP 2> /dev/null
/etc/init.d/clash stop 2>/dev/null
uci set clash.config.enable=1 2> /dev/null
uci commit clash 2> /dev/null
/etc/init.d/clash start 2>/dev/null
else
rm -rf /etc/clash/config.bak 2> /dev/null
if [ $subtype == "clash" ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $subscribe_url -O 2>&1 >1 $CONFIG_YAML
elif [ $subtype == "v2rayn2clash" ];then
if [ $cusrule == 1 ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: MozillaLuci-app-clash-v1.03/OpenWRT" $urlv2ray.$subscribe_url -O 2>&1 >1 $CONFIG_YAML_TEMP
if [ -f $CONFIG_YAML_TEMP ];then
sed -i '/Rule:/,$d' $CONFIG_YAML_TEMP 
cat $CONFIG_YAML_TEMP $CONFIG_YAML_RULE > $CONFIG_YAML 
fi
else
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $urlv2ray.$subscribe_url -O 2>&1 >1 $CONFIG_YAML
fi
elif [ $subtype == "surge2clash" ];then
wget-ssl --no-check-certificate --user-agent="User-Agent: Luci-app-clash-v1.03/OpenWRT" $urlsurge.$subscribe_url -O 2>&1 >1 $CONFIG_YAML
fi
rm -rf $CONFIG_YAML_TEMP 2> /dev/null
fi
fi


