---
id: kb-web3-contract-audit
title: Web3 · 合约与链上审计
domain: web3
tier: 1
updated: 2026-10-25
source: Claude-BugHunter / web3-audit + meme-coin-audit（合并重写）
keywords: ["web3","合约","solidity","evm","代币","token","rug","honeypot","蜜罐","重入","reentrancy","闪电贷","flashloan","预言机","oracle","mint","代理","proxy","upgradeable","slither","mythril","foundry"]
aliases: ["合约审计","链上","rug pull","蜜罐检测"]
negative: ["传统 web"]
next: [case-review]
---

# Web3 · 合约与链上审计

## 热路径
```
slither [CONTRACT].sol --print human-summary
myth analyze [CONTRACT].sol -o json
forge test -vvv
grep -nE 'onlyOwner|require\(msg.sender|owner *=' [CONTRACT].sol
grep -nEi 'blacklist|_tax|pause|setFee|setMaxTx|tradingEnabled' [CONTRACT].sol
cast code [ADDR] --rpc-url [RPC] | head -c 200
cast call [ADDR] "owner()(address)" --rpc-url [RPC]
cast storage [ADDR] [SLOT] --rpc-url [RPC]
```

## 判据表
| 观察 | 判定 | 影响 |
|---|---|---|
| 外部调用先于状态更新 | 重入 | 资金被抽干 |
| tx.origin 做鉴权 | 授权劫持 | 用户资产被转 |
| 预言机单源 + 可被闪电贷操纵 | 价格操纵 | 清算套利 |
| 代理 + upgradeTo 无时间锁 | 逻辑可被替换 | 全量资金风险 |
| 转账可变税/黑名单 | 蜜罐或 rug 开关 | 买入无法卖出 |
| mint 无上限且仅 owner | 无限增发 | 价值归零 |

## 坑
- 源码未验证 → 反编译字节码（heimdall/panoramix），结论标"未验证"。
- 只看单合约会漏 → 必须看 pair、router、LP 锁仓、多签。
- 主网 fork 测试比本地可靠 → forge test --fork-url。

## 产物
`case-<id>/web3.md`：风险表（类别/SWC/严重度/证据行号）+ 链上核对结果 + 攻击路径。
