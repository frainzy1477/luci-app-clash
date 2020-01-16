#!/bin/bash /etc/rc.common
. /lib/functions.sh

update_geoip(){

LICENSE_KEY=$(uci get clash.config.license_key 2>/dev/null)
if [ -f /var/run/geoip_down_complete ];then 
  rm -rf /var/run/geoip_down_complete 2>/dev/null
fi
echo '' >/tmp/geoip_update.txt 2>/dev/null
wget --no-check-certificate https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key="$LICENSE_KEY"&suffix=tar.gz -O 2>&1 >1 /tmp/GeoLite2-Country.tar.gz
tar zxvf /tmp/GeoLite2-Country.tar.gz -C .
mv /tmp/GeoLite2-Country_*/GeoLite2-Country.mmdb /etc/clash/Country.mmdb
rm -rf ./GeoLite2-Country_*
sleep 2
touch /var/run/geoip_down_complete >/dev/null 2>&1
sleep 2
rm -rf /var/run/geoip_update >/dev/null 2>&1
echo "" > /tmp/geoip_update.txt >/dev/null 2>&1
if pidof clash >/dev/null; then
/etc/init.d/clash restart 2>/dev/null
fi
} 

update_geoip >/dev/null 2>&1