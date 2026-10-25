# kb-patch · 富江知识库增量（2026-10-25）

本目录是**叠加在发布包之上的增量**，不是完整 KB。重装插件后按 `apply.sh` 打回去即可。

## 内容

| 目录 | 说明 |
|---|---|
| `new/` | 7 个新入口模块（M365/Entra、Okta、vCenter、企业 VPN、Web3 合约、移动红队流水线、组织级测绘） |
| `shared/common-commands.md` | 跨模块真命令速查（13 条，已剔除模板噪声） |
| `edited/` | 3 个被追加过小节的既有模块（`apk-reverse`、`firmware-pentest`、`cra-patch`）——**整文件副本**，便于比对；追加位置在文件末尾「实战补充（回写 …）」小节 |
| `ops/` | 去重门禁脚本、审计报告、15 面路由表、PalmCode shell 修复记录与重打脚本 |

## 这轮做了什么

1. **去重**：全库 24 组同名 → 0；跨模块完全重复命令行 → 0。26 个重复件移入 `_archive/`（不参与检索）。
2. **降权**：76 个非入口文件（`RULES*.md`/`routing*.md`/`NORMALIZER.md`/`leaves/INDEX.md`/`docs/`/`field-journal/`/`examples/` 等）改名 `.md.ref`，退出关键词打分。
3. **补别名**：84 个 coffee 叶子补 `## 检索别名`，实测面级 `hit@1` 7/15 → **15/15**。
4. **回写 6 条**：JKS 口令摘要验法、jks+口令同仓的审计判据、boot.img 头偏移与伪镜像判据、banner/ARM64 魔数、AXML 偏移两坑、DEX 等长直改 + adler32 重算。

## 应用

```bash
bash kb-patch/apply.sh /root/.dsh/plugins/fujiang-armor/kb
```

脚本是**幂等**的：目标模块已含同名小节则跳过，不会重复追加。
