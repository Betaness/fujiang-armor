# DEDUPE-PLAN · 全库 24 组同名处置

> 实测来源：`_audit/kb-audit.py`（451 模块 / 1001 个 .md）。归档=移动到 `fujiang-arsenal/_archive/` 下同路径，**不删除**。

| # | 同名 | 保留 | 归档 |
|---|---|---|---|
| 1 | `api-security` | `vendor/reverse-skill/skills/api-security/SKILL.md` | `vendor/pentest-skills-merged/offensive-api-security/SKILL.md` |
| 2 | `apk-reverse` | `vendor/reverse-skill/skills/apk-reverse/SKILL.md` | `seep/skill/safe-skills/apk-reverse/SKILL.md` |
| 3 | `business-logic` | `vendor/pentest-skills-merged/hunt-business-logic/SKILL.md` | `vendor/pentest-skills-merged/offensive-business-logic/SKILL.md` |
| 4 | `deserialization` | `vendor/pentest-skills-merged/hunt-deserialization/SKILL.md` | `vendor/pentest-skills-merged/offensive-deserialization/SKILL.md` |
| 5 | `email-security` | `vendor/reverse-skill/skills/email-security/SKILL.md` | `vendor/pentest-skills-merged/email-security/SKILL.md` |
| 6 | `file-upload` | `vendor/pentest-skills-merged/hunt-file-upload/SKILL.md` | `vendor/pentest-skills-merged/offensive-file-upload/SKILL.md` |
| 7 | `graphql` | `vendor/pentest-skills-merged/hunt-graphql/SKILL.md` | `vendor/pentest-skills-merged/offensive-graphql/SKILL.md` |
| 8 | `grill-me` | `skills/grill-me/SKILL.md` | `skills/grill-me/UPSTREAM_SKILL.md` |
| 9 | `grilling` | `skills/grilling/SKILL.md` | `skills/grilling/UPSTREAM_SKILL.md` |
| 10 | `ida-reverse` | `vendor/reverse-skill/skills/ida-reverse/SKILL.md` | `seep/skill/ida-reverse/SKILL.md`<br>`seep/skill/safe-skills/ida-reverse/SKILL.md` |
| 11 | `idor` | `vendor/pentest-skills-merged/hunt-idor/SKILL.md` | `vendor/pentest-skills-merged/offensive-idor/SKILL.md` |
| 12 | `oauth` | `vendor/pentest-skills-merged/hunt-oauth/SKILL.md` | `vendor/pentest-skills-merged/offensive-oauth/SKILL.md` |
| 13 | `open-redirect` | `vendor/pentest-skills-merged/hunt-open-redirect/SKILL.md` | `vendor/pentest-skills-merged/offensive-open-redirect/SKILL.md` |
| 14 | `osint-methodology` | `vendor/pentest-skills-merged/osint-methodology/SKILL.md` | `vendor/pentest-skills-merged/offensive-osint-methodology/SKILL.md` |
| 15 | `race-condition` | `vendor/pentest-skills-merged/hunt-race-condition/SKILL.md` | `vendor/pentest-skills-merged/offensive-race-condition/SKILL.md` |
| 16 | `radare2` | `vendor/reverse-skill/skills/radare2/SKILL.md` | `seep/skill/safe-skills/radare2/SKILL.md` |
| 17 | `rce` | `vendor/pentest-skills-merged/hunt-rce/SKILL.md` | `vendor/pentest-skills-merged/offensive-rce/SKILL.md` |
| 18 | `reverse-engineering` | `vendor/reverse-skill/skills/reverse-engineering/SKILL.md` | `seep/skill/safe-skills/reverse-engineering/SKILL.md` |
| 19 | `reverse-skill-router` | `vendor/reverse-skill/skills/SKILL.md` | `vendor/reverse-skill/plugins/reverse-skill/skills/reverse-skill-router/SKILL.md`<br>`skills/reverse-skill-router/SKILL.md` |
| 20 | `sqli` | `vendor/pentest-skills-merged/hunt-sqli/SKILL.md` | `vendor/pentest-skills-merged/offensive-sqli/SKILL.md` |
| 21 | `ssrf` | `vendor/pentest-skills-merged/hunt-ssrf/SKILL.md` | `vendor/pentest-skills-merged/offensive-ssrf/SKILL.md` |
| 22 | `ssti` | `vendor/pentest-skills-merged/hunt-ssti/SKILL.md` | `vendor/pentest-skills-merged/offensive-ssti/SKILL.md` |
| 23 | `xss` | `vendor/pentest-skills-merged/hunt-xss/SKILL.md` | `vendor/pentest-skills-merged/offensive-xss/SKILL.md` |
| 24 | `xxe` | `vendor/pentest-skills-merged/hunt-xxe/SKILL.md` | `vendor/pentest-skills-merged/offensive-xxe/SKILL.md` |

## 归档脚本（26 个文件）

```bash
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-api-security/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-api-security/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-api-security/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/seep/skill/safe-skills/apk-reverse/SKILL.md')"
mv -n "$KB/seep/skill/safe-skills/apk-reverse/SKILL.md" "$KB/fujiang-arsenal/_archive/seep/skill/safe-skills/apk-reverse/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-business-logic/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-business-logic/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-business-logic/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-deserialization/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-deserialization/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-deserialization/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/email-security/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/email-security/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/email-security/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-file-upload/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-file-upload/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-file-upload/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-graphql/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-graphql/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-graphql/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/skills/grill-me/UPSTREAM_SKILL.md')"
mv -n "$KB/skills/grill-me/UPSTREAM_SKILL.md" "$KB/fujiang-arsenal/_archive/skills/grill-me/UPSTREAM_SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/skills/grilling/UPSTREAM_SKILL.md')"
mv -n "$KB/skills/grilling/UPSTREAM_SKILL.md" "$KB/fujiang-arsenal/_archive/skills/grilling/UPSTREAM_SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/seep/skill/ida-reverse/SKILL.md')"
mv -n "$KB/seep/skill/ida-reverse/SKILL.md" "$KB/fujiang-arsenal/_archive/seep/skill/ida-reverse/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/seep/skill/safe-skills/ida-reverse/SKILL.md')"
mv -n "$KB/seep/skill/safe-skills/ida-reverse/SKILL.md" "$KB/fujiang-arsenal/_archive/seep/skill/safe-skills/ida-reverse/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-idor/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-idor/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-idor/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-oauth/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-oauth/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-oauth/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-open-redirect/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-open-redirect/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-open-redirect/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-osint-methodology/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-osint-methodology/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-osint-methodology/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-race-condition/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-race-condition/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-race-condition/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/seep/skill/safe-skills/radare2/SKILL.md')"
mv -n "$KB/seep/skill/safe-skills/radare2/SKILL.md" "$KB/fujiang-arsenal/_archive/seep/skill/safe-skills/radare2/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-rce/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-rce/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-rce/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/seep/skill/safe-skills/reverse-engineering/SKILL.md')"
mv -n "$KB/seep/skill/safe-skills/reverse-engineering/SKILL.md" "$KB/fujiang-arsenal/_archive/seep/skill/safe-skills/reverse-engineering/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/reverse-skill/plugins/reverse-skill/skills/reverse-skill-router/SKILL.md')"
mv -n "$KB/vendor/reverse-skill/plugins/reverse-skill/skills/reverse-skill-router/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/reverse-skill/plugins/reverse-skill/skills/reverse-skill-router/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/skills/reverse-skill-router/SKILL.md')"
mv -n "$KB/skills/reverse-skill-router/SKILL.md" "$KB/fujiang-arsenal/_archive/skills/reverse-skill-router/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-sqli/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-sqli/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-sqli/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-ssrf/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-ssrf/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-ssrf/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-ssti/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-ssti/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-ssti/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-xss/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-xss/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-xss/SKILL.md"
mkdir -p "$KB/$(dirname 'fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-xxe/SKILL.md')"
mv -n "$KB/vendor/pentest-skills-merged/offensive-xxe/SKILL.md" "$KB/fujiang-arsenal/_archive/vendor/pentest-skills-merged/offensive-xxe/SKILL.md"
```

## 回滚

```bash
cd "$KB/fujiang-arsenal/_archive" && find . -type f | while read -r f; do
  dst="$KB/${f#./}"; mkdir -p "$(dirname "$dst")"; mv -n "$f" "$dst"; done
```
