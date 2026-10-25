# COMMON-COMMANDS · 跨模块真命令速查

> 来源：全库命令级去重（3+ 模块重复）。**已剔除上游模板噪声**
> （`grep -q ... PASS/FAIL` 自检行、`import xxx`、`</script>`、`-H "Content-..."` 等片段）。
> 原始 3+ 模块重复行 199 条，其中**真命令 13 条**；其余 186 条是模板片段，已在门禁里过滤。

| 分类 | 条数 |
|---|---|
| 通用 | 5 |
| 侦察 / 指纹 | 4 |
| Linux 现场 | 4 |

## 通用（5 条）

| 次数 | 命令 | 代表模块 |
|---|---|---|
| 26 | `python3 -c "` | `bb-methodology`, `firebase-supabase-attack`, `firmware-pentest` |
| 4 | `aws sts get-caller-identity` | `cloud-iam-deep`, `cloud-k8s`, `offensive-cicd-secrets` |
| 3 | `python3 << 'EOF'` | `dsl-vm-reverse`, `offensive-crash-analysis`, `offensive-fuzzing-course` |
| 3 | `make -j$(nproc)` | `offensive-crash-analysis`, `offensive-exploit-dev-course`, `offensive-fuzzing-course` |
| 3 | `aws s3 ls s3://target-bucket-name --no-sign-request` | `bb-local-toolkit`, `bug-bounty`, `hunt-cloud-misconfig` |

## 侦察 / 指纹（4 条）

| 次数 | 命令 | 代表模块 |
|---|---|---|
| 3 | `curl --max-time 30 --connect-timeout 10 -sk -X POST "https://target.com/graphql"` | `hunt-broken-function-level-auth`, `hunt-fastapi`, `hunt-schema-enumeration` |
| 3 | `curl --max-time 30 --connect-timeout 10 -sk -X POST "https://target.com/api/user` | `hunt-fastapi`, `hunt-nestjs`, `hunt-sqli` |
| 3 | `curl --max-time 30 --connect-timeout 10 -s -o /dev/null -w "$name: %{http_code}\` | `bb-local-toolkit`, `bug-bounty`, `hunt-cloud-misconfig` |
| 3 | `curl --max-time 30 --connect-timeout 10 -s -X POST https://$TARGET/api/login \` | `hunt-deserialization`, `hunt-ldap`, `hunt-nosqli` |

## Linux 现场（4 条）

| 次数 | 命令 | 代表模块 |
|---|---|---|
| 4 | `sudo airmon-ng check kill && sudo airmon-ng start wlan0` | `offensive-wifi`, `offensive-wifi-recon`, `offensive-wpa2-psk` |
| 3 | `sudo make install` | `offensive-crash-analysis`, `offensive-exploit-dev-course`, `offensive-fuzzing-course` |
| 3 | `sudo iw reg set US` | `offensive-wifi`, `offensive-wifi-recon`, `offensive-wpa2-psk` |
| 3 | `sudo apt update` | `offensive-basic-exploitation`, `offensive-exploit-dev-course`, `offensive-fuzzing-course` |

