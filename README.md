<h2 align="center">
 <img src="https://github.com/Dreamacro/clash/raw/master/docs/logo.png" alt="Clash" width="200">
  <br>Luci For Clash - OpenWrt <br>

</h2>

  <p align="center">
	A rule based custom proxy for Openwrt based on <a href="https://github.com/Dreamacro/clash" target="_blank">Clash</a>.
  </p>
  <p align="center">
  <a target="_blank" href="https://github.com/frainzy1477/luci-app-clash/releases/tag/v1.1.1">
    <img src="https://img.shields.io/badge/luci%20for%20clash-v1.1.1-blue.svg">
  </a>
  
  </p>

  
 ## Usage

- Download and install clash ipk for openwrt [Download Clash ipk](https://github.com/frainzy1477/clash/releases/tag/v0.15.3) .

- Also Download and install luci for clash ipk  [Download Luci for Clash ipk](https://github.com/frainzy1477/luci-app-clash/releases/tag/v1.1.1)

- cd /tmp

- opkg install clash_0.15.3_x86_64.ipk

- opkg install luci-app-clash_1.1.1_all.ipk


- [Fake-IP wiki](https://github.com/frainzy1477/luci-app-clash/wiki/Fake-IP-Mode)

- [Redir-Host wiki](https://github.com/frainzy1477/luci-app-clash/wiki/Redir-Host-Mode)


## Features
- Support sspanel Server subscription
- Support Manually config upload (config.yaml)
- GeoIP Database Update
- Iptables udp redirect
- IP Query / Website Access Check
- Proxy Lan IP(Client IP) that go through Proxy
- Bypass Lan IP(Client IP) that can't go through Proxy
- DNS Forwarding
- Ping Custom proxy servers

## Dependency

- bash
- coreutils
- coreutils-nohup
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
- [OpenClash] (https://github.com/vernesong/OpenClash/tree/master) : Another Clash Client For OpenWrt
## License

Luci For Clash - OpenWrt is released under the GPL v3.0 License - see detailed [LICENSE](https://github.com/frainzy1477/luci-app-clash/blob/master/LICENSE) .

IP Query / Website Access Check based on  knowledge from  [@SukkaW - MyIP](https://github.com/SukkaW/MyIP)

[Clash Dashboard](https://github.com/Dreamacro/clash-dashboard)


