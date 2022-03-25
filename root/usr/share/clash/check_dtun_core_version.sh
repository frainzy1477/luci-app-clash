#!/bin/sh

#new_clashdtun_core_version=`curl -sL "https://github.com/frainzy1477/clashdtun/tags"| grep "/frainzy1477/clashdtun/releases/"| head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//'`
#new_clashdtun_core_version=`curl -sL ${clash_curl_proxy} "https://github.com/Dreamacro/clash/releases/tag/premium" | grep 'a href="/Dreamacro/clash/releases/tag/premium' | head -n 1 | awk -F ' ' '{print $3}'| sed 's/<\/a>//'`
#版本号格式为clash(premium)_version=2022.03.21 放在第三行。
new_clashdtun_core_version=`curl -sL "https://raw.githubusercontents.com/yaof2/luci-app-clash/master/clash(premium)_version"| sed -n '3p' | cut -d "=" -f2`
#new_clashdtun_core_version=`curl -sL "https://cdn.jsdelivr.net/gh/yaof2/luci-app-clash/master/clash(premium)_version"| sed -n '3p' | cut -d "=" -f2`

sleep 2
if [ "$?" -eq "0" ]; then
rm -rf /usr/share/clash/new_clashdtun_core_version
if [ $new_clashdtun_core_version ]; then
echo $new_clashdtun_core_version > /usr/share/clash/new_clashdtun_core_version 2>&1 & >/dev/null
elif [ $new_clashdtun_core_version =="" ]; then
echo 0 > /usr/share/clash/new_clashdtun_core_version 2>&1 & >/dev/null
fi
fi

