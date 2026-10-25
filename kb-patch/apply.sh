#!/usr/bin/env bash
# 幂等应用 kb-patch 到指定 KB 根目录
# 用法: bash kb-patch/apply.sh [KBROOT]
set -u
SRC="$(cd "$(dirname "$0")" && pwd)"
KB="${1:-/root/.dsh/plugins/fujiang-armor/kb}"
[ -d "$KB" ] || { echo "KBROOT 不存在: $KB"; exit 2; }

echo "[1/3] 新入口模块"
mkdir -p "$KB/fujiang-arsenal/new"
n=0
for f in "$SRC"/new/*.md; do
  b=$(basename "$f")
  if [ -f "$KB/fujiang-arsenal/new/$b" ]; then echo "  skip $b"; else cp "$f" "$KB/fujiang-arsenal/new/"; n=$((n+1)); echo "  add  $b"; fi
done

echo "[2/3] 共享命令表"
mkdir -p "$KB/fujiang-arsenal/shared"
cp "$SRC/shared/common-commands.md" "$KB/fujiang-arsenal/shared/" && echo "  ok"

echo "[3/3] 既有模块的追加小节（按标记判重）"
python3 - "$SRC" "$KB" <<'PY'
import io, os, sys, re
src, kb = sys.argv[1], sys.argv[2]
marks = {'vendor/reverse-skill/skills/apk-reverse/SKILL.md': ['签名链失控', 'Mighty Aphrodite', 'attributeStart'],
         'vendor/reverse-skill/skills/firmware-pentest/SKILL.md': ['page_size@0x18', 'ARM\\x64'],
         'coffee/routes/leaves/cra-patch.md': ['zlib.adler32']}
for rel, probes in marks.items():
    s = os.path.join(src, 'edited', rel); d = os.path.join(kb, rel)
    if not (os.path.exists(s) and os.path.exists(d)):
        print('  skip %s (缺文件)' % rel); continue
    new_txt = io.open(s, encoding='utf-8').read()
    cur = io.open(d, encoding='utf-8').read()
    if all(p in cur for p in probes if not p.startswith('ARM')):
        print('  skip %s (已含)' % rel); continue
    # 只取源文件末尾的「实战补充」段落追加，避免覆盖现有内容
    idx = new_txt.find('## 实战补充（回写')
    if idx < 0:
        print('  skip %s (源里没找到回写段)' % rel); continue
    tail = new_txt[idx:]
    io.open(d, 'a', encoding='utf-8').write('\n' + tail)
    print('  append %s (+%d B)' % (rel, len(tail.encode('utf-8'))))
PY
echo "done"
