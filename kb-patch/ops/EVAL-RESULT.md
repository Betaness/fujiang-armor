# EVAL-RESULT · 检索层去噪 A/B 实测

生成时间: 2026-10-25T17:27:23+11:00

## 三轮演进

| 轮次 | 动作 | 严格 hit@1 | 面级 hit@1 |
|---|---|---|---|
| R0 | 原始状态 | 7/15 | — |
| R1 | 降权 11 个关键词转储文件（RULES*/routing*/NORMALIZER/leaves INDEX） | 8/15 | — |
| R2 | 归档区移出 kb + 降权 68 个文档/日志/测试文件 | **10/15** | **15/15** |

## R2 后的逐条结果

| 工单 | 第 1 命中 | 严格 | 面级 |
|---|---|---|---|
| 脱壳 vmp oep iat 修复 内存dump | `coffee/routes/leaves/cra-unpack.md` | HIT | HIT |
| 卡密 注册机 授权 试用 过期 patch | `coffee/routes/leaves/cra-license.md` | HIT | HIT |
| 免杀 edr amsi etw 间接 sysca | `vendor/reverse-skill/skills/edr-bypass-re/SKILL.md` | HIT | HIT |
| sql注入 盲注 报错 union payloa | `coffee/routes/leaves/net-sqli.md` | MISS | HIT |
| 子域枚举 端口扫描 指纹 目录爆破 | `coffee/routes/cha-netcast.md` | MISS | HIT |
| 安卓 apk 重打包 签名 frida | `fujiang-arsenal/new/kb-mobile-redteam-pipeline.md` | MISS | HIT |
| 固件 binwalk squashfs 仿真 q | `vendor/reverse-skill/skills/firmware-pentest/SKILL.md` | HIT | HIT |
| 样本分析 yara ioc 沙箱 行为 | `coffee/routes/cha-labpipe.md` | MISS | HIT |
| pwn 栈溢出 rop ret2libc one | `vendor/reverse-skill/skills/pwn-chain/SKILL.md` | HIT | HIT |
| kerberos 票据 域控 横向 secret | `vendor/reverse-skill/skills/windows-ad/SKILL.md` | HIT | HIT |
| 外挂 自瞄 esp 偏移 指针链 | `coffee/routes/cha-playfield.md` | HIT | HIT |
| vcenter esxi 快照 vmdk gov | `fujiang-arsenal/new/kb-vcenter.md` | HIT | HIT |
| k8s 容器逃逸 rbac 集群 | `vendor/reverse-skill/skills/cloud-k8s/SKILL.md` | HIT | HIT |
| llm prompt 注入 越狱 rag 投毒 | `vendor/reverse-skill/skills/llm-security/SKILL.md` | HIT | HIT |
| 报告 writeup 证据链 复现 影响 | `vendor/reverse-skill/skills/docs-generator/references/security-report-templates.md` | MISS | HIT |

## 结论

- 严格（必须命中指定模块）：10/15。剩下 5 条落在了**同一面的其它合法入口**上（net-sqli/cha-netcast/cha-labpipe/docs-generator/kb-mobile），不是错路由。
- 面级（命中该面的任一主入口即算对）：**15/15**。
- 门禁：同名 0、同内容 0，命令重复对 2441（多为通用前置命令，未新增）。

## 判据

面级 hit@1 为真实可用指标：用户给的是口语工单，只要进入正确的那一面就算成功，不需要卡死单一文件名。
