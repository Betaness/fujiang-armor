#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="fujiang-armor"
TARGET_PLUGINS=("$PLUGIN_NAME")
DSH_ROOT="${DSH_HOME:-$HOME/.dsh}"
PLUGINS_DIR="${DSH_ROOT}/plugins"

echo "==> 查找 profile 配置..."
for name in web default desktop; do
  pDir="${DSH_ROOT}/profiles/${name}"
  pkgPath="${pDir}/package.json"
  patchPath="${pDir}/cordis.patch.yml"

  if [[ -f "${pkgPath}" ]]; then
    node - "${pkgPath}" "${patchPath}" "${TARGET_PLUGINS[@]}" <<'NODE'
const fs = require("fs");
const [pkgPath, patchPath, ...legacy] = process.argv.slice(2);
if (fs.existsSync(pkgPath)) {
  const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));
  let changed = false;
  if (pkg.dependencies) {
    for (const old of legacy) {
      if (pkg.dependencies[old]) { delete pkg.dependencies[old]; changed = true; }
    }
  }
  if (pkg.dsh && pkg.dsh.profile && pkg.dsh.profile.bundles) {
    pkg.dsh.profile.bundles = pkg.dsh.profile.bundles.filter(b => !legacy.includes(b));
    changed = true;
  }
  if (changed) {
    fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2) + "\n");
    console.log("    [OK] package.json 已更新: " + pkgPath);
  }
}

if (fs.existsSync(patchPath)) {
  let patchContent = fs.readFileSync(patchPath, "utf8");
  for (const old of legacy) {
    const reg = new RegExp("^([ \\t]*)-[ \\t]+insert:[ \\t]*\\r?\\n[ \\t]+-[ \\t]+id:[ \\t]+" + old + "[ \\t]*(?:\\r?\\n|(?![\\s\\S]))[\\s\\S]*?(?=^\\1-[ \\t]|(?![\\s\\S]))", "gm");
    patchContent = patchContent.replace(reg, "");
  }
  fs.writeFileSync(patchPath, patchContent.trim() + "\n");
  console.log("    [OK] cordis.patch.yml 已更新: " + patchPath);
}
NODE

    for old in "${TARGET_PLUGINS[@]}"; do
      rm -rf "${pDir}/node_modules/${old}" 2>/dev/null || true
    done

    (cd "${pDir}" && pnpm install >/dev/null 2>&1 || true)
  fi
done

for old in "${TARGET_PLUGINS[@]}"; do
  if [[ -d "${PLUGINS_DIR}/${old}" ]]; then
    rm -rf "${PLUGINS_DIR}/${old}"
    echo "    [OK] 已删除插件目录: ${PLUGINS_DIR}/${old}"
  fi
done

echo "==> 清理 Codex / OpenCode / WorkBuddy 注入..."
AGENT_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/FujiangArmor/backup"
mkdir -p "$AGENT_BACKUP"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/scripts/lib/run-agents.mjs" ]; then
  node "$SCRIPT_DIR/scripts/lib/run-agents.mjs" uninstall "$SCRIPT_DIR/scripts/lib/run-agents.mjs" "$AGENT_BACKUP" || true
  echo "    [OK] Codex / OpenCode / WorkBuddy 规则已移除，备份：$AGENT_BACKUP"
fi

echo "==> 富江破甲卸载完成，请重启 DeepSeek Harness、Codex、OpenCode 与 WorkBuddy。"
