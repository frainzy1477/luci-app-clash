<h1 align="center">
  <img src="https://github.com/Dreamacro/clash/raw/master/docs/logo.png" alt="Clash" width="200">
  <br>Clash for OpenWrt <br>

</h1>

  <p align="center">
	A rule based custom proxy for Openwrt based on <a href="https://github.com/Dreamacro/clash" target="_blank">Clash</a>.
  </p>
  <p align="center">
	<a target="_blank" href="https://github.com/frainzy1477/clash/releases/tag/c0.15.0">
    <img src="https://img.shields.io/badge/Clash-v0.15.0-orange.svg">
  </a>
  <a target="_blank" href="https://github.com/frainzy1477/luci-app-clash/releases/tag/v0.23.0">
    <img src="https://img.shields.io/badge/luci%20for%20clash-v0.23.0-blue.svg">
  </a>
  
  </p>

  
 ## Usage

- Download and install clash ipk for openwrt [Download Clash ipk](https://github.com/frainzy1477/clash/releases/tag/c0.15.0) .

- Also Download and install luci for clash ipk  [Download Luci for Clash ipk](https://github.com/frainzy1477/luci-app-clash/releases/tag/v0.23.0)

 
## Features
- Support sspanel Server subscription
- Support Manually config upload (config.yaml)
- GeoIP Database Update
- Iptables udp redirect
- IP Query / Website Access Check
- Proxy Lan IP(Client IP) that go through Proxy
- Bypass Lan IP(Client IP) that can't go through Proxy
- DNS Forwarding

## Dependency

- clash
- wget
- bash
- coreutils-nohup

## Clash on Other Platforms

- [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg/releases) : A Windows GUI based on Clash
- [clashX](https://github.com/yichengchen/clashX) : A rule based custom proxy with GUI for Mac base on clash
- [ClashA](https://github.com/ccg2018/ClashA/tree/master) : An Android GUI for Clash
- [KoolClash OpenWrt/LEDE](https://github.com/SukkaW/Koolshare-Clash/tree/master) : A rule based custom proxy for Koolshare OpenWrt/LEDE based on Clash.

## License

Clash for OpenWrt is released under the MIT License - see detailed [LICENSE](https://github.com/frainzy1477/luci-app-clash/blob/rm/LICENSE) .

IP Query / Website Access Check based on  knowledge from  [MyIP](https://github.com/SukkaW/MyIP)

[Clash Dashboard](https://github.com/Dreamacro/clash-dashboard)

[Yet Another Clash Dashboard](https://github.com/haishanh/yacd)
