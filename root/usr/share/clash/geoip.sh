#!/bin/sh

Key=$(uci get clash.config.license_key 2>/dev/null)

if [ -f /var/run/geoip_down_complete ];then 
  rm -rf /var/run/geoip_down_complete 2>/dev/null
fi

echo '' >/tmp/geoip_update.txt 2>/dev/null
sleep 3

wget -c4 --no-check-certificate --timeout=300 --tries=5 --user-agent="Mozilla" https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key="$Key"&suffix=tar.gz -O 2>&1 >1 /tmp/geoip.tar.gz

if [ "$?" -eq "0" ] && [ "$(ls -l /tmp/geoip.tar.gz |awk '{print int($5)}')" -ne 0 ]; then

tar zxvf /tmp/geoip.tar.gz -C .
mv /tmp/GeoLite2-Country_*/GeoLite2-Country.mmdb /etc/clash/Country.mmdb
chmod 755 /etc/clash/Country.mmdb >/dev/null 2>&1
rm -rf /tmp/GeoLite2-Country_* /tmp/geoip.tar.gz
sleep 2
touch /var/run/geoip_down_complete >/dev/null 2>&1
sleep 2
rm -rf /var/run/geoip_update >/dev/null 2>&1
echo "" > /tmp/geoip_update.txt >/dev/null 2>&1
if pidof clash >/dev/null; then
/etc/init.d/clash restart 2>/dev/null
fi

fi

