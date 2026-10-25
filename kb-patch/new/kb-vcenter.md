---
id: kb-vcenter
title: 虚拟化 · vCenter / ESXi 攻击面
domain: cloud
tier: 1
updated: 2026-10-25
source: Claude-BugHunter / vmware-vcenter-attack（结构参考，正文重写）
keywords: ["vcenter","esxi","vmware","vsphere","虚拟化","hypervisor","快照","snapshot","datastore","vmdk","sso","sts","CVE-2021-21972","CVE-2021-22005","CVE-2023-34048"]
aliases: ["vcenter","esxi","虚拟化攻击","vsphere"]
negative: ["k8s","容器"]
next: [kb-cloud-iam-deep]
---

# 虚拟化 · vCenter / ESXi

## 热路径
```
curl -sk https://[VC]/sdk/vimServiceVersions.xml | head -40
curl -sk https://[VC]/ui/ | grep -Ei 'version|build'
nmap -Pn -p 443,902,5480,8443 --script ssl-cert [VC]
# 未授权面对号
curl -sk "https://[VC]/ui/vropspluginui/rest/services/uploadova" -X POST
curl -sk "https://[VC]/analytics/telemetry/ph/api/hyper/send?_c=&_i=/../../"
# 有凭据后
govc about --url https://[USER]:[PASS]@[VC]/sdk
govc ls /
govc snapshot.tree -vm [VM]
govc datastore.download "[DS]" [PATH] -
```

## 判据表
| 观察 | 判定 | 下一步 |
|---|---|---|
| 版本落在已知 CVE 区间 | 优先打现成漏洞 | 公开 PoC，只验证不破坏 |
| /ui/ 可达但 /sdk 401 | SSO 前置需凭据 | SSO 弱口令/默认账户 |
| 快照早于密码轮换 | 含旧凭据/旧配置 | 只读挂载读 SAM/shadow |
| vmdk 可读 | 离线取全盘 | 挂载后走本地提权 |
| ESXi Shell/SSH 开启 | 主机层直达 | root 后密钥全在 |

## 坑
- 打 vCenter 会把生产打挂 → 只在快照/测试集群验证。
- govc 证书报错 → GOVC_INSECURE=1。
- 快照挂载写操作污染证据 → 一律 -o ro 只读。

## 产物
`case-<id>/vcenter.md`：版本↔CVE 矩阵、可达面、凭据来源、快照清单、数据面影响。
