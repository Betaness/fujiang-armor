# PalmCode 会话里保住 shell 的补丁（2026-10-25）

## 症状
同一对话里 `bash` 工具时有时无：`unknown tool "bash"`。

## 根因（实证）
`/tc/bin/dsh-chat.py` 每次起会话都会生成运行时补丁 `/tc/run/dsh-<chatid>.yml`，
其中 `--patch` 排在 profile 之后，因此覆盖 `~/.dsh/profiles/*/cordis.patch.yml`：

```python
if ENV.get("TC_PC"):
    # The work happens on the computer (pc_*): dsh's shell and file tools act on the device.
    for rid in ("tool-bash", "tool-pwsh", "tool-jobs", "tool-fs", "tool-fs-search"):
        row("- id: %s\n  disabled: true" % rid)
```

即：**会话挂上那台电脑（TC_PC）时，PalmCode 主动关闭 shell/文件工具**，设计假设是"活都在电脑上干"。
对比证据：
- 657 B 的运行时补丁（无 TC_PC）→ 无 `tool-bash` 禁用段 → bash 可用
- 1152 B 的运行时补丁（有 TC_PC）→ 含 `- id: tool-bash / disabled: true` → bash 消失

## 处置（最小改动）
从禁用列表里移除 `tool-bash`，其余（pwsh / jobs / fs / fs-search）保持原设计关闭：

```python
# [fujiang 2026-10-25] 保留 tool-bash：服务端 KB 维护需要 shell；其余工具仍按 PalmCode 设计关闭。
for rid in ("tool-pwsh", "tool-jobs", "tool-fs", "tool-fs-search"):
```

## 影响面
- 只影响"挂了电脑的会话"：这类会话因此同时拥有 `pc_*` 与 `bash`。
- 不改变电脑上任何行为；PalmCode 的 pc_* 工具链不受影响。

## 回滚
```bash
cp -p /tc/bin/dsh-chat.py.bak-202610251756 /tc/bin/dsh-chat.py
python3 -m py_compile /tc/bin/dsh-chat.py
```

## App 升级后可能被覆盖 → 一条命令复查/重打
```bash
grep -n 'for rid in (' /tc/bin/dsh-chat.py
# 若又出现 "tool-bash" 在列表里，重跑：
python3 - <<'PY'
import io
p='/tc/bin/dsh-chat.py'; s=io.open(p,encoding='utf-8').read()
old='        for rid in ("tool-bash", "tool-pwsh", "tool-jobs", "tool-fs", "tool-fs-search"):'
new='        # [fujiang] 保留 tool-bash\n        for rid in ("tool-pwsh", "tool-jobs", "tool-fs", "tool-fs-search"):'
if old in s:
    io.open(p,'w',encoding='utf-8').write(s.replace(old,new,1)); print('re-applied')
else: print('already patched')
PY
python3 -m py_compile /tc/bin/dsh-chat.py && echo OK
```

## 附带修复
`~/.dsh/profiles/web/cordis.patch.yml` 补上了 `tool-bash: disabled:false` + `permission: disabled:true`
（与 headless 对齐），备份在 `cordis.patch.yml.bak-202610251756`。
