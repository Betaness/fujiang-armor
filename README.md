# 富江破甲：DSH / Codex / OpenCode / WorkBuddy 多代理适配

富江破甲是一个本地多代理规则注入器。当前版本：`0.4.4`；插件标识：`fujiang-armor`。一次安装同时适配 DeepSeek Harness、OpenAI Codex、OpenCode 与 WorkBuddy。

## 功能

- **DSH**：双层系统提示词注入、状态条、`fujiang_profile` 元数据工具。
- **Codex**：在 `%USERPROFILE%\.codex\AGENTS.md` 写入带标记的富江规则块，可在 `config.toml` 增加 `[fujiang-armor]` 章节显式加载。
- **OpenCode**：向 `%USERPROFILE%\.config\opencode\opencode\opencode.json` 的 `instructions` 数组注册 `AGENTS.md`，并写入同目录 `AGENTS.md`。
- **WorkBuddy**：写入 `.workbuddy\fujiang-armor\`（完整提示词 + `INSTRUCTIONS.md`）、`skills\fujiang-armor__fujiang\SKILL.md`，并把规则块注入 `workspace\SOUL.md`、`workspace\AGENTS.md` 与个人身份文件（`SOUL.md` / `IDENTITY.md` / `AGENTS.md`）。
- 所有目标修改前自动备份；卸载只删除带 `FUJIANG-ARMOR-START/END` 标记的块及本项目新增文件，不破坏其他内容。

## 安装前准备

- 使用 Windows；已安装并至少启动过 DSH、Codex、OpenCode、WorkBuddy 中的目标程序（未安装的目标会被自动跳过）。
- 首次安装需要联网。已有可用的 Node.js 22+ 与 npm 时直接复用；缺失时安装器会从 Node.js 官方下载 LTS 并校验 SHA256，无需管理员权限。缺少 pnpm 会自动通过 npm 获取。
- 安装前完全退出 DSH、Codex、OpenCode 与 WorkBuddy，避免继续使用旧配置。

## 一键安装

1. 完整解压项目文件夹。
2. 完全退出目标程序。
3. 双击 `点我一键注入.bat`。
4. 按提示选择 DSH profile（非 DSH 目标无需选择）。
5. 等待安装完成后重启目标程序并新建会话。
6. 在 Codex 中输入激活词 `富江`；OpenCode / WorkBuddy 直接提出任务或输入 `富江` 均可。

安装后的插件目录为 `%USERPROFILE%\.dsh\plugins\fujiang-armor`。请保留解压后的完整项目文件夹，卸载时仍需使用其中的脚本。

自动下载的 Node.js 位于 `%LOCALAPPDATA%\FujiangArmor\runtime`，下次安装会复用。安装器只为当前执行过程设置运行环境，不改系统 PATH；DSH 本体仍需先安装并启动一次。

## 一键卸载

1. 完全退出 DSH、Codex、OpenCode 与 WorkBuddy。
2. 在完整解压的项目文件夹中，双击 `点我一键卸载.bat`。
3. 如果出现 DSH 配置选择提示，选择此前安装的目标配置。
4. 等待卸载完成后重启所有目标程序。
5. 卸载会自动清理 Codex `AGENTS.md` 标记块、OpenCode `instructions` 条目与 `AGENTS.md`、WorkBuddy 的 `fujiang-armor` 目录、技能目录与 `workspace` / 个人身份文件中的标记块；原文件备份保存在 `%LOCALAPPDATA%\FujiangArmor\backup`（Linux 为 `~/.local/share/FujiangArmor/backup`）。

## 常见问题

| 问题 | 处理方法 |
| --- | --- |
| 找不到 DSH 配置或目标配置 | 先安装并启动一次 DSH，确认 `%USERPROFILE%\.dsh` 已生成，再运行安装器。 |
| 自动下载运行环境失败 | 确认网络可以访问 `nodejs.org` 和 npm 软件包源，再重新运行安装器；错误信息会显示具体原因。 |
| 运行环境校验失败 | 安装器不会使用校验失败的下载包，请检查网络后重试。 |
| 找不到脚本、规则或其他文件 | 完整解压压缩包，保留 `prompts`、`scripts` 等子目录；不要只复制单个 BAT 文件。 |
| 安装成功但 DSH 没有显示激活状态 | 完全退出并重新启动 DSH，确认安装时选中了当前使用的配置。 |
| Codex / OpenCode 没有加载规则 | 确认安装时目标程序已退出；重启后在 `%USERPROFILE%\.codex\AGENTS.md` 或 `.config\opencode\opencode\AGENTS.md` 中看到 `FUJIANG-ARMOR-START` 标记即可。 |
| WorkBuddy 没有加载规则 | 确认 `%USERPROFILE%\.workbuddy\workspace\SOUL.md` 与 `skills\fujiang-armor__fujiang\SKILL.md` 已生成，重启 WorkBuddy 新建会话。 |
| 依赖下载失败 | 检查网络连接，并保留报错信息后重新运行安装器。 |
| 卸载后仍有残留 | 手动删除标记块或运行 `点我一键卸载.bat`；备份文件不会被删除，可手动还原。 |

「富江破甲已激活」表示插件已加载。实际回复仍受所选模型、其他提示词及 DSH 版本影响，本项目不保证所有模型都产生相同结果。

## DSH 无限重启

已核对 [dsh-purge 官方发布页](https://github.com/YuJunZhiXue/dsh-purge/releases)：1.1.52 在已应用补丁戳缺少 `sha` 时会把状态判为未对齐，并在启动时重打补丁、请求重启；上游从 1.1.53 起加入了空戳修复。若你使用 `dsh-purge` 1.1.52 并遇到反复重启，优先按其官方说明升级到 1.1.53 或更新版本，再重新启动 DSH。不要把空 `sha` 直接填成任意值；版本戳不匹配或宿主补丁未实际写入时，手动补戳可能掩盖故障。

本插件没有重启 DSH 的代码。兼容性补丁现在只在安装过程中应用；启动插件不会再重复写入宿主或 profile 文件。此次改动可避免富江插件自身在每次启动时触发写入，但不会替代 `dsh-purge` 的上游修复。若升级后仍循环，请保留相关启动日志并确认实际启用的 `dsh-purge` 版本与 profile。
