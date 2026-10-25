---
id: kb-enterprise-vpn
title: 边界 · 企业 VPN / 远程接入设备
domain: cloud
tier: 1
updated: 2026-10-25
source: Claude-BugHunter / enterprise-vpn-attack（结构参考，正文重写）
keywords: ["vpn","ssl vpn","ipsec","anyconnect","fortinet","fortigate","pulse","globalprotect","citrix","netscaler","凭证喷洒","mfa 绕过","CVE-2024-3400","CVE-2023-3519","CVE-2019-11510"]
aliases: ["vpn 攻击","边界设备","ssl vpn","fortigate","citrix"]
negative: ["内网横向"]
next: [kb-recon-org-surface, kb-m365-entra]
---

# 边界 · 企业 VPN / 远程接入

## 热路径
```
curl -sk https://[HOST]/ | grep -Ei 'fortinet|pulse|citrix|globalprotect|anyconnect'
curl -sk https://[HOST]/remote/login | head -20
curl -sk https://[HOST]/dana-na/auth/url_default/welcome.cgi | head -20
nmap -Pn -p 443,4443,10443 --script ssl-cert,http-title [HOST]
curl -sk -X POST "https://[HOST]/gw/test.js" --data 'x' -o /dev/null -w '%{http_code}'
# 进去之后
ipconfig /all; route print; nltest /dsgetdc:[DOMAIN]
```

## 判据表
| 观察 | 判定 | 下一步 |
|---|---|---|
| 门户无 MFA、本地账户可枚举 | 口令喷洒 | 低速率 + 固定指纹 |
| 版本在 CVE 区间 | 未授权 RCE/路径穿越 | 只验证读取，不落地 |
| 客户端配置可下载 | 含网关/认证方式/分割隧道策略 | 解析内网网段 |
| 分割隧道开启 | 只走特定网段 | 先打能到的段 |
| VPN 账号 = AD 账号 | 一次突破即域内身份 | 转 windows-ad |

## 坑
- 边界设备普遍有账号锁定与 IP 封禁 → 喷洒低于阈值（默认 5 次/30 分）。
- 打 VPN 设备易造成全员掉线 → 只做只读验证与凭据侧。
- 客户端配置里的证书可重放 → 保存原件做证据。

## 产物
`case-<id>/vpn.md`：厂商/版本、可利用面、内网网段推断、凭据来源、进入后的身份级别。
