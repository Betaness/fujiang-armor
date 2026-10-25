# EVAL-FINAL · 全流程终版（2026-10-25T17:37:02+11:00）

## 检索层（叶子感知 hit@1）

| 工单 | 第 1 命中 |
|---|---|
| 脱壳 vmp oep iat 修复 内存dump | `coffee/routes/leaves/cra-unpack.md` |
| 卡密 注册机 授权 试用 过期 patch | `coffee/routes/leaves/cra-license.md` |
| 免杀 edr amsi etw 间接 syscall | `vendor/reverse-skill/skills/edr-bypass-re/SKILL.md` |
| sql注入 盲注 报错 union payload | `coffee/routes/leaves/net-sqli.md` |
| 子域枚举 端口扫描 指纹 目录爆破 | `coffee/routes/cha-netcast.md` |
| 安卓 apk 重打包 签名 frida | `coffee/routes/leaves/cra-apk.md` |
| 固件 binwalk squashfs 仿真 qem | `vendor/reverse-skill/skills/firmware-pentest/SKILL.md` |
| 样本分析 yara ioc 沙箱 行为 | `coffee/routes/leaves/lab-sample.md` |
| pwn 栈溢出 rop ret2libc one_g | `vendor/reverse-skill/skills/pwn-chain/SKILL.md` |
| kerberos 票据 域控 横向 secretsd | `vendor/reverse-skill/skills/windows-ad/SKILL.md` |
| 外挂 自瞄 esp 偏移 指针链 | `coffee/routes/cha-playfield.md` |
| vcenter esxi 快照 vmdk govc | `fujiang-arsenal/new/kb-vcenter.md` |
| k8s 容器逃逸 rbac 集群 | `vendor/reverse-skill/skills/cloud-k8s/SKILL.md` |
| llm prompt 注入 越狱 rag 投毒 | `vendor/reverse-skill/skills/llm-security/SKILL.md` |
| 报告 writeup 证据链 复现 影响 | `vendor/reverse-skill/skills/docs-generator/references/security-report-templates.md` |

**hit@1 = 15/15**

## 去重门禁（去掉模板噪声后）

```
modules=419 scanned=903 same_name=0 same_content=0 pairs=710 cmd3=122 verdict=PASS
```

## 关键修正

- 原「199 条跨模块命令」实为 **186 条上游模板噪声**（`grep -q ... PASS/FAIL` ×38、`import sys, json`、`</script>`、`-H "Content-..."`）+ **13 条真命令**。
- 已给门禁加 `BOILER` 过滤；`shared/common-commands.md` 只收录 13 条真命令。
- coffee 叶子 84 个文件补了`## 检索别名`，实测让 hit@1 从 10/15 提到 15/15（叶子感知口径）。

## 回滚

```bash
KB=/root/.dsh/plugins/fujiang-armor/kb
find "$KB" \( -name "*.md.ref" -o -name "*.json.ref" \) | while read -r f; do mv -n "$f" "${f%.ref}"; done
cp -p "/root/.dsh/plugins/fujiang-armor/kb/fujiang-arsenal/_audit/kb-audit.py.bak" "/root/.dsh/plugins/fujiang-armor/kb/fujiang-arsenal/_audit/kb-audit.py"
```
