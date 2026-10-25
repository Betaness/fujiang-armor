---
name: cra-patch
description: >
  CHA leaf workflow for 补丁制作. Use when: 补丁 patch 改字节 JNZ JMP NOP.
parent: cha-bin-unlock
---

# 补丁制作 · LEAF-cra-patch

父技能：`cha-bin-unlock`
关键词：补丁 patch 改字节 JNZ JMP NOP

第一步 钉要改的指令与原字节。

第二步 写 PATCH_BYTE 表，避开完整性哈希或一并改哈希。

第三步 交补丁器和备份、校验哈希。

缺参用 TARGET / HOST / TOKEN / OFFSET / PATCH_BYTE / PAYLOAD / SERIAL / ROLE_A / ROLE_B。收口：当前:对象 / 结果 / 下一步


## 检索别名（提升命中率，不改变流程）
补丁、patch、改字节、JNZ、JMP、NOP、恒真、AOB

## 实战补充（回写 2026-10-25 · P6-dex-inplace）
> 冲突说明：本条是**条件分支**，不替代主流程；主流程仍见模块正文。

## 分支：apktool 不可用 / 只需等长替换时的 DEX 直改

> **仅在**下列条件同时成立时走这条路：没有 apktool，或改动是**等长字节替换**（同长度才能不动偏移）。
> 其余情况仍按主流程 `apktool b` → `zipalign` → `apksigner`，且**必须保留 META-INF 原文件**
> （整删会触发 ServiceLoader 缺失，见 apkseep/references/pitfalls.md P1）。

```python
import zipfile, hashlib, zlib, struct
z = zipfile.ZipFile('in.apk'); dex = bytearray(z.read('classes.dex'))
OLD, NEW = b'6.18.21-android', b'9.99.99-android'      # 必须等长
assert len(OLD) == len(NEW)
dex = bytearray(bytes(dex).replace(OLD, NEW))
dex[12:32] = hashlib.sha1(bytes(dex[32:])).digest()      # 重算 signature
struct.pack_into('<I', dex, 8, zlib.adler32(bytes(dex[12:])) & 0xffffffff)  # 重算 checksum
# 重打包时逐条复制原 entry，只替换 classes.dex
```

自检三件：旧串残留 0 / `adler32(dex[12:])` 等于头里 checksum / `sha1(dex[32:])` 等于头里 signature。
改完 v1 摘要必然失配（正常）→ 必须重签才能安装。

