# KB 全库去重门禁

root: `/root/.dsh/plugins/fujiang-armor/kb`
modules（有 frontmatter name/id）: **419** / 扫描 .md: 902

## S1 同名（归一化后）

无

## S1b 内容完全相同

无

## S3 命令重复对（共享 >1 行，前 20）

| 共享 | A | B | 示例 |
|---|---|---|---|
| 291 | `vendor/pentest-skills-merged/bb-local-toolkit/SKILL.md` | `vendor/pentest-skills-merged/bug-bounty/SKILL.md` | `${7*7} -> 49 = Freemarker / Pebble / Velocity` |
| 68 | `vendor/pentest-skills-merged/offensive-windows-boundaries/SKILL.md` | `vendor/pentest-skills-merged/offensive-windows-mitigations/SKILL.md` | `&secCaps, sizeof(secCaps), NULL, NULL);` |
| 53 | `vendor/pentest-skills-merged/offensive-basic-exploitation/SKILL.md` | `vendor/pentest-skills-merged/offensive-crash-analysis/SKILL.md` | `(gdb) continue` |
| 47 | `vendor/pentest-skills-merged/offensive-crash-analysis/SKILL.md` | `vendor/pentest-skills-merged/offensive-windows-mitigations/SKILL.md` | `!analyze -v` |
| 38 | `vendor/pentest-skills-merged/offensive-exploit-dev-course/SKILL.md` | `vendor/pentest-skills-merged/offensive-fuzzing-course/SKILL.md` | `-DPEDANTIC no-shared -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRO` |
| 31 | `vendor/pentest-skills-merged/offensive-basic-exploitation/SKILL.md` | `vendor/pentest-skills-merged/offensive-windows-mitigations/SKILL.md` | `// Vulnerable: Stack buffer overflow` |
| 26 | `vendor/pentest-skills-merged/offensive-crash-analysis/SKILL.md` | `vendor/pentest-skills-merged/offensive-fuzzing-course/SKILL.md` | `(gdb) continue` |
| 16 | `vendor/pentest-skills-merged/offensive-basic-exploitation/SKILL.md` | `vendor/pentest-skills-merged/offensive-windows-boundaries/SKILL.md` | `close(fd);` |
| 15 | `vendor/pentest-skills-merged/offensive-crash-analysis/SKILL.md` | `vendor/pentest-skills-merged/offensive-windows-boundaries/SKILL.md` | `.sin_family = AF_INET,` |
| 14 | `vendor/pentest-skills-merged/offensive-dependency-confusion/SKILL.md` | `vendor/pentest-skills-merged/offensive-supply-chain/SKILL.md` | `<add key="nuget.org" value="https://api.nuget.org/v3/ind` |
| 14 | `vendor/pentest-skills-merged/bug-bounty/SKILL.md` | `vendor/pentest-skills-merged/security-arsenal/SKILL.md` | `' OR '1'='1` |
| 14 | `vendor/pentest-skills-merged/bb-local-toolkit/SKILL.md` | `vendor/pentest-skills-merged/security-arsenal/SKILL.md` | `' OR '1'='1` |
| 13 | `vendor/pentest-skills-merged/bug-bounty/SKILL.md` | `vendor/pentest-skills-merged/report-writing/SKILL.md` | `Broken access control` |
| 13 | `vendor/pentest-skills-merged/bb-local-toolkit/SKILL.md` | `vendor/pentest-skills-merged/report-writing/SKILL.md` | `Broken access control` |
| 12 | `vendor/pentest-skills-merged/offensive-wifi/SKILL.md` | `vendor/pentest-skills-merged/offensive-wpa2-psk/SKILL.md` | `--enable_status=1 --filterlist_ap=targets.txt --filtermo` |
| 12 | `vendor/pentest-skills-merged/offensive-advanced-redteam/SKILL.md` | `vendor/pentest-skills-merged/offensive-c2-frameworks/SKILL.md` | `base64url;` |
| 10 | `vendor/pentest-skills-merged/security-arsenal/SKILL.md` | `vendor/pentest-skills-merged/triage-validation/SKILL.md` | `Autocomplete on password fields` |
| 10 | `vendor/pentest-skills-merged/offensive-parameter-pollution/SKILL.md` | `vendor/pentest-skills-merged/offensive-request-smuggling/SKILL.md` | `Connection: Upgrade` |
| 10 | `vendor/pentest-skills-merged/hunt-sqli/SKILL.md` | `vendor/pentest-skills-merged/security-arsenal/SKILL.md` | `' AND SLEEP(5)--` |
| 10 | `vendor/pentest-skills-merged/hunt-saml/SKILL.md` | `vendor/pentest-skills-merged/security-arsenal/SKILL.md` | `3. Change NameID to admin@company.com` |

## S3b 同一命令出现在 3+ 模块（前 20）

| 次数 | 命令 | 模块 |
|---|---|---|
| 26 | `python3 -c "` | `bb-methodology`<br>`firebase-supabase-attack`<br>`http2-header-impersonation`<br>`hunt-api-misconfig` |
| 9 | `Transfer-Encoding: chunked` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-http-smuggling`<br>`hunt-sharepoint` |
| 7 | `[X]` | `offensive-crash-analysis`<br>`offensive-dependency-confusion`<br>`offensive-linux-privesc`<br>`offensive-persistence` |
| 5 | `engine = RequestEngine(endpoint=target.endpoint,` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-http-smuggling`<br>`hunt-mfa-bypass` |
| 5 | `- uses: actions/checkout@v4` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-cicd`<br>`offensive-exploit-development` |
| 5 | `Host: target.com` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-business-logic`<br>`hunt-idor` |
| 5 | `http://metadata.google.internal/computeMetadata/v1/instance/` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-ssrf`<br>`offensive-cloud` |
| 5 | `POST / HTTP/1.1` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-http-smuggling`<br>`offensive-request-smuggling` |
| 5 | `Content-Type: application/x-www-form-urlencoded` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-cache-poison`<br>`hunt-csrf` |
| 5 | `typedef struct {` | `offensive-basic-exploitation`<br>`offensive-crash-analysis`<br>`offensive-fuzzing-course`<br>`offensive-windows-boundaries` |
| 5 | `continue` | `offensive-crash-analysis`<br>`offensive-crypto-attacks`<br>`offensive-windows-boundaries`<br>`offensive-windows-mitigations` |
| 4 | `' OR 1=1--` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-sqli`<br>`security-arsenal` |
| 4 | `{{config.__class__.__init__.__globals__['os'].popen('id').re` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-ssti`<br>`security-arsenal` |
| 4 | `SMUGGLED` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-http-smuggling`<br>`security-arsenal` |
| 4 | `' OR '1'='1` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-sqli`<br>`security-arsenal` |
| 4 | `http://[X]/latest/meta-data/iam/security-credentials/` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-file-upload`<br>`security-arsenal` |
| 4 | `' UNION SELECT NULL--` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-sqli`<br>`security-arsenal` |
| 4 | `Content-Length: 13` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-http-smuggling`<br>`security-arsenal` |
| 4 | `<%= `id` %>` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-ssti`<br>`security-arsenal` |
| 4 | `concurrentConnections=1,` | `bb-local-toolkit`<br>`bug-bounty`<br>`hunt-mfa-bypass`<br>`hunt-race-condition` |

## 判定

`S1 = 0`　`S1b = 0`　`命令重复对 = 710`　`3+模块命令 = 122`

**verdict: PASS**

> 门禁三条：S1=0、S1b=0、新增模块的命令不与既有模块重复。命令重复对多为通用前置动作，按对判断。
