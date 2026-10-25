---
id: kb-okta-sso
title: 云身份 · Okta / SSO 攻击面
domain: cloud
tier: 1
updated: 2026-10-25
source: Claude-BugHunter / okta-attack（结构参考，正文重写）
keywords: ["okta","sso","单点登录","saml","断言","assertion","idp","sp","应用目录","api token","mfa","push fatigue","okta-pwn"]
aliases: ["okta","sso 攻击","saml 断言伪造","mfa 疲劳"]
negative: ["m365","azure"]
next: [kb-m365-entra, kb-recon-org-surface]
---

# 云身份 · Okta / SSO

## 热路径
```
curl -s https://[TENANT].okta.com/.well-known/openid-configuration | jq '{issuer,authorization_endpoint,token_endpoint}'
curl -s https://[TENANT].okta.com/api/v1/authn -d '{"username":"a@b.c","password":"x"}' -H 'Content-Type: application/json'
curl -s https://[TENANT].okta.com/app/[APPID]/sso/saml/metadata
okta-pwn --url https://[TENANT].okta.com --token [TOKEN] enum
okta-pwn --url https://[TENANT].okta.com --token [TOKEN] privesc
```

## 判据表
| 观察 | 判定 | 下一步 |
|---|---|---|
| SAML 响应 ds:Signature 缺失或被注释 | 可伪造任意用户断言 | SAML Raider 改 NameID |
| 签名算法 rsa-sha1 且接受自签证书 | 可自签 IdP 证书重签 | 生成证书 → 重签断言 |
| authn 返回 MFA_REQUIRED 但存在 push | MFA 疲劳可行 | 批量推送（授权测试内控频次） |
| SignOnMode=SAML_2_0 且 recipient 未校验 | 断言可投递任意 SP | 跨应用重放 |
| API token 属 Super Admin 且长期有效 | 直接接管 | 枚举 api/v1/users |

## 坑
- Okta 有速率限制与风控 → 枚举分批 + 固定 UA/IP。
- 断言重放要处理 NotOnOrAfter 与 InResponseTo → 改时间戳并去掉 InResponseTo。
- 免费租户无 app catalog 权限 → 只能走 IdP 侧。

## 产物
`case-<id>/okta.md`：org 指纹、SAML 配置缺陷项、可达应用清单、提权链、证据（断言原文）。
