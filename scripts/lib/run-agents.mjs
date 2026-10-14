// 富江破甲跨代理安装/卸载入口
// 用法：node run-agents.mjs install <sourceRoot> <backupRoot>
//       node run-agents.mjs uninstall <agentsMjsPath> <backupRoot>

async function main() {
  const [mode, arg2, backupRoot] = process.argv.slice(2);

  if (mode === "install") {
    const module = await import("./agents.mjs");
    const result = await module.installAgents(arg2, backupRoot);
    process.stdout.write(`install ok: ${JSON.stringify(result)}\n`);
    return;
  }

  if (mode === "uninstall") {
    const module = await import("./agents.mjs");
    await module.uninstallAgents(backupRoot);
    process.stdout.write("uninstall ok\n");
    return;
  }

  throw new Error(`未知模式：${mode}（应为 install 或 uninstall）`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
