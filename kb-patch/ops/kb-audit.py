#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""kb-audit.py — 全库去重门禁（同名 / 同内容 / 命令重复）
用法: python3 kb-audit.py --root <KBROOT> [--out DIR] [--min-code 1]"""
import os, re, io, sys, json, argparse, hashlib, itertools, collections

def read(p, lim=1<<20):
    try:
        raw = open(p,'rb').read(lim)
    except OSError:
        return ''
    for enc in ('utf-8','utf-8-sig','gbk','latin-1'):
        try: return raw.decode(enc)
        except UnicodeDecodeError: continue
    return ''

def parse(p, t):
    fm = {}
    m = re.match(r'^---\s*\n(.*?)\n---', t, re.S)
    body = t[m.end():] if m else t
    if m:
        for line in m.group(1).split('\n'):
            if ':' in line:
                k, v = line.split(':', 1); fm[k.strip().lower()] = v.strip()
    name = fm.get('name') or fm.get('id') or ''
    code = set()
    for mm in re.finditer(r'```[a-zA-Z]*\n(.*?)```', body, re.S):
        for ln in mm.group(1).split('\n'):
            s = ln.strip()
            if len(s) < 8 or s.startswith('#'): continue
            if not re.search(r'[A-Za-z0-9]', s): continue
            if s.startswith('```') or re.match(r'^\|[\s\-:|]+\|$', s): continue
            # --- 模板噪声过滤（上游 skill 模板的自检行/脚本片段，非命令）---
            BOILER = (
                r'PASS:|FAIL"', r'^import ', r'^from \w+ import', r'^except', r'^if __name__',
                r'^def ', r'^return ', r'^int main\(', r'^\}', r'^</', r'^<script', r'^-H "Content-',
                r'^sleep [0-9]', r'^\s*"', r'^\.\.\.$', r'^\[X\]$', r'^data = ', r'^table\.',
                r'^if \[\[', r'^elif ', r'^else:', r'^for ', r'^while ', r'^try:', r'^with ',
                r'^TARGET="', r'^OUTDIR', r'^mkdir -p "\$', r'^" 2>', r'^echo "', r'^\s*\)',
            )
            if any(re.search(bp, s) for bp in BOILER):
                continue
            code.add(re.sub(r'\[[A-Za-z_]+\]','[X]',re.sub(r'\s+',' ',s)))
    return {'path': p, 'name': name,
            'norm': re.sub(r'^(fj-|kb-|cra-|ply-|cha-|offensive-|hunt-)','',name.lower()),
            'code': code, 'sha': hashlib.sha256(t.encode('utf-8','ignore')).hexdigest()[:16],
            'mod': bool(fm.get('name') or fm.get('id'))}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--root', required=True); ap.add_argument('--out', default='/tmp')
    ap.add_argument('--min-code', type=int, default=1); a = ap.parse_args()
    files = []
    for dp, dn, fn in os.walk(a.root):
        dn[:] = [d for d in dn if d not in ('.git','node_modules','__pycache__','_audit','_archive')]
        files += [os.path.join(dp,f) for f in fn if f.endswith('.md')]
    mods = [parse(p, read(p)) for p in sorted(files)]
    mods = [m for m in mods if m['mod']]
    by = collections.defaultdict(list); sh = collections.defaultdict(list)
    for m in mods: by[m['norm']].append(m['path']); sh[m['sha']].append(m['path'])
    same_name = {k:v for k,v in by.items() if len(v)>1 and k}
    same_content = {k:v for k,v in sh.items() if len(v)>1}
    owner = collections.defaultdict(list)
    for m in mods:
        for ln in m['code']: owner[ln].append(m['path'])
    hot = {k:v for k,v in owner.items() if len(v)>=3}
    pairs = []
    for x,y in itertools.combinations(mods,2):
        ci = x['code'] & y['code']
        if len(ci) >= a.min_code: pairs.append((len(ci), x['path'], y['path'], sorted(ci)[0]))
    pairs.sort(reverse=True)
    os.makedirs(a.out, exist_ok=True)
    rel = lambda p: p.replace(os.path.abspath(a.root)+os.sep,'')
    L = ['# KB 全库去重门禁','', 'root: `%s`'%os.path.abspath(a.root),
         'modules（有 frontmatter name/id）: **%d** / 扫描 .md: %d' % (len(mods), len(files)), '',
         '## S1 同名（归一化后）', '']
    L += ['- `%s` ← %s'%(k, ' | '.join('`%s`'%rel(x) for x in v)) for k,v in same_name.items()] or ['无']
    L += ['', '## S1b 内容完全相同', '']
    L += ['- %s ← %s'%(k[:12], ' | '.join('`%s`'%rel(x) for x in v)) for k,v in same_content.items()] or ['无']
    L += ['', '## S3 命令重复对（共享 >%d 行，前 20）'%a.min_code, '']
    if pairs:
        L += ['| 共享 | A | B | 示例 |','|---|---|---|---|']
        for n,x,y,s in pairs[:20]: L.append('| %d | `%s` | `%s` | `%s` |'%(n,rel(x),rel(y),s[:56].replace('|','\\|')))
    else: L.append('无')
    L += ['', '## S3b 同一命令出现在 3+ 模块（前 20）', '']
    if hot:
        L += ['| 次数 | 命令 | 模块 |','|---|---|---|']
        for k,v in sorted(hot.items(), key=lambda kv:-len(kv[1]))[:20]:
            L.append('| %d | `%s` | %s |'%(len(v), k[:60].replace('|','\\|'), '<br>'.join('`%s`'%os.path.basename(os.path.dirname(p)) for p in v[:4])))
    else: L.append('无')
    verdict = 'PASS' if not (same_name or same_content) else 'FAIL'
    L += ['', '## 判定', '', '`S1 = %d`　`S1b = %d`　`命令重复对 = %d`　`3+模块命令 = %d`'%(len(same_name),len(same_content),len(pairs),len(hot)),
          '', '**verdict: %s**' % verdict, '',
          '> 门禁三条：S1=0、S1b=0、新增模块的命令不与既有模块重复。命令重复对多为通用前置动作，按对判断。']
    open(os.path.join(a.out,'AUDIT-FULL.md'),'w',encoding='utf-8').write('\n'.join(L)+'\n')
    json.dump({'modules':len(mods),'scanned':len(files),'same_name':same_name,'same_content':same_content,
               'pairs':[(n,rel(x),rel(y)) for n,x,y,_ in pairs],'cmd3':{k:v for k,v in hot.items()}},
              open(os.path.join(a.out,'audit-full.json'),'w',encoding='utf-8'), ensure_ascii=False, indent=1)
    print('modules=%d scanned=%d same_name=%d same_content=%d pairs=%d cmd3=%d verdict=%s'
          % (len(mods), len(files), len(same_name), len(same_content), len(pairs), len(hot), verdict))
    print('report:', os.path.join(a.out,'AUDIT-FULL.md'))

if __name__ == '__main__': main()
