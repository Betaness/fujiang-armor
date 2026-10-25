---
id: kb-recon-org-surface
title: 侦察 · 组织级攻击面与身份入口
domain: recon
tier: 1
updated: 2026-10-25
source: Claude-OSINT / org-attack-surface + identity-provider-recon（合并重写）
keywords: ["组织攻击面","企业测绘","asn","ip 段","子公司","身份入口","idp","sso 发现","邮箱格式","员工枚举","github 泄露","云租户发现","证书透明","dork","shodan","censys"]
aliases: ["组织测绘","企业资产","idp 侦察","入口发现"]
negative: ["单站渗透"]
next: [kb-m365-entra, kb-okta-sso]
---

# 侦察 · 组织级攻击面

## 原理
单站渗透回答"这个站能不能打"，组织级测绘回答"**从哪进最省力**"。三条主线：**归属**（域名/ASN/子公司/云租户）→ **入口**（VPN/Webmail/SSO/管理面）→ **人**（邮箱格式/员工/泄露凭据）。输出是"入口优先级表"，不是资产列表。

## 热路径
```
curl -s "https://crt.sh/?q=%25.[DOMAIN]&output=json" | jq -r '.[].name_value' | sort -u
amass intel -org "[ORG NAME]" -asn
whois -h whois.radb.net -- '-i origin AS[ASN]' | grep -E '^route'
for d in [DOMAIN] mail.[DOMAIN] owa.[DOMAIN] vpn.[DOMAIN] sso.[DOMAIN] login.[DOMAIN]; do
  code=$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 8 https://$d); echo "$code $d"; done
curl -s "https://login.microsoftonline.com/getuserrealm.srf?login=a@[DOMAIN]&xml=1"
curl -s "https://[DOMAIN]/.well-known/openid-configuration"
```

## 判据表
| 观察 | 判定 | 优先级 |
|---|---|---|
| VPN/Webmail 门户且无 MFA | 口令侧入口 | ★★★ |
| 租户 = M365 Managed | 云身份直连 | ★★★ |
| 自建 SSO（Okta/ADFS/Keycloak） | 断言伪造面 | ★★★ |
| 暴露 Actuator/Swagger/.git | 信息泄露 → 内网 | ★★ |
| 子公司域名未纳入监控 | 常为薄弱点 | ★★ |
| 云存储桶可列目录 | 数据面直接暴露 | ★★★ |

## 坑
- 只看主域会漏子公司/历史品牌 → crt.sh 历史 + 商标 + 招聘 JD。
- 邮箱格式猜错浪费一轮喷洒 → 先用 RCPT TO / 忘记密码页回显确认。
- 组织测绘比单站更敏感 → 只在授权组织范围内做，输出脱敏。

## 产物
`case-<id>/org-surface.md`：入口优先级表（入口/类型/前置条件/预估成本/证据）+ 身份系统清单 + 人员面（脱敏）+ 首打建议。
