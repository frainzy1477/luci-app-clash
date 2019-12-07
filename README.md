<h2 align="center">
 <img src="https://github.com/Dreamacro/clash/raw/master/docs/logo.png" alt="Clash" width="200">
  <br>Luci For Clash - OpenWrt <br>

</h2>

  <p align="center">
	A rule based custom proxy for Openwrt based on <a href="https://github.com/Dreamacro/clash" target="_blank">Clash</a>.
  </p>
  <p align="center">
  <a target="_blank" href="https://github.com/frainzy1477/luci-app-clash/releases/tag/v1.3.2">
    <img src="https://img.shields.io/badge/luci%20for%20clash-v1.3.2-blue.svg">
  </a>
  
  </p>

  
 ## Usage



- Also Download and install luci for clash ipk  [Download Luci for Clash ipk](https://github.com/frainzy1477/luci-app-clash/releases/tag/v1.3.2)

- cd /tmp

- opkg install luci-app-clash_1.3.2-1_all.ipk

- opkg install luci-app-clash_1.3.2-2_all.ipk

- [Fake-IP wiki](https://github.com/frainzy1477/luci-app-clash/wiki/Fake-IP-Mode)

- [Redir-Host wiki](https://github.com/frainzy1477/luci-app-clash/wiki/Redir-Host-Mode)


## Features

- Support Manually config upload (config.yaml / config.yml)
- GeoIP Database Update
- Iptables udp redirect
- IP Query / Website Access Check
- Proxy Lan IP(Client IP) that go through Proxy
- Bypass Lan IP(Client IP) that can't go through Proxy
- DNS Forwarding
- Ping Custom proxy servers
- Create v2ray & ssr clash config from subscription url
- Create Custom Clash Config


## Dependency

- bash
- coreutils
- coreutils-nohup
- coreutils-base64
- ipset
- iptables
- luci
- luci-base
- libopenssl 
- libustream-openssl
- openssl-util
- wget


## Clash on Other Platforms

- [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg/releases) : A Windows GUI based on Clash
- [clashX](https://github.com/yichengchen/clashX) : A rule based custom proxy with GUI for Mac base on clash
- [ClashA](https://github.com/ccg2018/ClashA/tree/master) : An Android GUI for Clash
- [KoolClash OpenWrt/LEDE](https://github.com/SukkaW/Koolshare-Clash/tree/master) : A rule based custom proxy for Koolshare OpenWrt/LEDE based on Clash
- [OpenClash](https://github.com/vernesong/OpenClash/tree/master) : Another Clash Client For OpenWrt
## License

Luci For Clash - OpenWrt is released under the GPL v3.0 License - see detailed [LICENSE](https://github.com/frainzy1477/luci-app-clash/blob/master/LICENSE) .

[Clash Dashboard](https://github.com/Dreamacro/clash-dashboard)

[Yet Another Clash Dashboard](https://github.com/haishanh/yacd)
