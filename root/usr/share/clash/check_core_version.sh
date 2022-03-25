#!/bin/sh

#new_core_version=`curl -sL "https://github.com/frainzy1477/clash_dev/tags"| grep "/frainzy1477/clash_dev/releases/"| head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//'`
new_core_version=`curl -sL ${clash_curl_proxy} "https://github.com/Dreamacro/clash/tags"| grep "a href=\"/Dreamacro/clash/releases" | head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//'`

if [ "$?" -eq "0" ]; then
rm -rf /usr/share/clash/new_core_version
if [ $new_core_version ]; then
echo $new_core_version > /usr/share/clash/new_core_version 2>&1 & >/dev/null
elif [ $new_core_version =="" ]; then
echo 0 > /usr/share/clash/new_core_version 2>&1 & >/dev/null
fi
fi
 
