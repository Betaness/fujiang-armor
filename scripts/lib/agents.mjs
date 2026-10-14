import { constants } from "node:fs";
import { access, chmod, copyFile, cp, mkdir, readFile, readdir, rm, stat, writeFile } from "node:fs/promises";
import path from "node:path";

const START = "<!-- FUJIANG-ARMOR-START:v0.4.4 -->";
const END = "<!-- FUJIANG-ARMOR-END -->";
const TARGETS = {
  codex: { root: (h) => path.join(h, ".codex"), config: (h) => path.join(h, ".codex", "config.toml"), rules: (h) => path.join(h, ".codex", "AGENTS.md") },
  opencode: {
    root: (h) => path.join(h, ".config", "opencode", "opencode"),
    altRoot: (h) => path.join(h, ".config", "opencode"),
    rules: (h) => path.join(h, ".config", "opencode", "opencode", "AGENTS.md"),
  },
  workbuddy: {
    root: (h) => path.join(h, ".workbuddy"),
    altRoot: (h) => path.join(h, "WorkBuddy"),
  },
};

async function exists(file) { try { await access(file, constants.F_OK); return true; } catch { return false; } }
async function read(file) { try { return await readFile(file, "utf8"); } catch { return ""; } }
async function dir(file) { await mkdir(file, { recursive: true }); }
function base(file) { return path.basename(file).replace(/[^\w.-]/g, "_"); }
async function backup(file, root) {
  if (!(await exists(file))) return;
  await dir(root);
  if ((await stat(file)).isDirectory()) {
    await cp(file, path.join(root, `${base(file)}.bak-${Date.now()}`), { recursive: true, force: true });
  } else {
    await copyFile(file, path.join(root, `${base(file)}.bak-${Date.now()}`));
  }
}
async function managed(file, content, prefix = "# 富江破甲\n\n") {
  const source = await read(file);
  const start = source.indexOf(START);
  const end = source.indexOf(END);
  const value = `${START}\n${content.trimEnd()}\n${END}`;
  const next = start >= 0 && end > start
    ? source.slice(0, start) + value + source.slice(end + END.length)
    : `${prefix}${value}\n`;
  await dir(path.dirname(file));
  await writeFile(file, next, "utf8");
}

async function rootFor(target) {
  const configured = target.root(process.env.USERPROFILE || process.env.HOME);
  if (await exists(configured)) return configured;
  if (!target.altRoot) return configured;
  const alternate = target.altRoot(process.env.USERPROFILE || process.env.HOME);
  return await exists(alternate) ? alternate : configured;
}
async function config(file) { try { const source = await read(file); return source.trim() ? JSON.parse(source) : {}; } catch { return {}; } }
async function rule(target, prompt, backupRoot, prefix = "# 富江破甲\n\n") {
  const file = target.rules(process.env.USERPROFILE || process.env.HOME);
  await dir(path.dirname(file));
  if (await exists(file)) await backup(file, backupRoot);
  await managed(file, prompt, prefix);
  return file;
}
async function installCodex(prompt, backupRoot) {
  const home = process.env.USERPROFILE || process.env.HOME;
  const file = TARGETS.codex.config(home);
  const source = await read(file);
  const block = '[fujiang-armor]\nenabled = true\nprompt = "./AGENTS.md"\n';
  if (!source.includes("[fujiang-armor]")) {
    await dir(path.dirname(file));
    if (source.trim()) await backup(file, backupRoot);
    await writeFile(file, source.trimEnd() + (source.trim() ? "\n\n" : "") + block, "utf8");
  }
  return rule(TARGETS.codex, prompt, backupRoot);
}
async function installOpenCode(prompt, backupRoot) {
  const root = await rootFor(TARGETS.opencode);
  const file = path.join(root, "opencode.json");
  const original = await read(file);
  let data;
  try { data = original.trim() ? JSON.parse(original) : {}; } catch (error) { throw new Error(`OpenCode 配置不是有效 JSON：${file}（${error.message}）`); }
  if (!Array.isArray(data.instructions)) data.instructions = [];
  if (!data.instructions.includes("AGENTS.md") && !data.instructions.includes("./AGENTS.md")) data.instructions.push("AGENTS.md");
  await dir(root);
  if (original.trim()) await backup(file, backupRoot);
  await writeFile(file, JSON.stringify(data, null, 2) + "\n", "utf8");

  const rules = path.join(root, "AGENTS.md");
  if (await exists(rules)) await backup(rules, backupRoot);
  await managed(rules, prompt);
  return rules;
}
async function discoverPersonal(root) {
  const parent = path.dirname(root);
  try {
    const dirs = await readdir(parent, { withFileTypes: true });
    const found = dirs.find((entry) => entry.isDirectory() && /^user-.*-personal$/.test(entry.name));
    if (found) return path.join(parent, found.name);
  } catch {}
  return path.join(parent, "user-personal");
}
async function installWorkbuddy(prompt, backupRoot) {
  const root = await rootFor(TARGETS.workbuddy), managedDir = path.join(root, "fujiang-armor"), instructions = path.join(managedDir, "INSTRUCTIONS.md"), promptFile = path.join(managedDir, "prompts", "fujiang.md"), skill = path.join(root, "skills", "fujiang-armor__fujiang", "SKILL.md");
  await dir(path.dirname(promptFile)); await writeFile(promptFile, prompt, "utf8"); await writeFile(instructions, prompt, "utf8"); await dir(path.dirname(skill));
  await writeFile(skill, `---\nname: fujiang-armor\ndescription: 富江破甲 v0.4.4，执行富江完整行为规则。\nversion: 0.4.4\n---\n\n# 富江破甲\n\n![[../../fujiang-armor/INSTRUCTIONS.md]]\n\n完整规则：../../fujiang-armor/prompts/fujiang.md\n`, "utf8"); await chmod(skill, 0o755);
  const workspace = path.join(root, "workspace"); await dir(workspace);
  for (const filename of ["SOUL.md", "AGENTS.md"]) { const file = path.join(workspace, filename); if (await exists(file)) await backup(file, backupRoot); await managed(file, `${prompt}\n\n完整规则：../../fujiang-armor/INSTRUCTIONS.md\n完整提示词：../../fujiang-armor/prompts/fujiang.md`); }
  const personal = await discoverPersonal(root); await dir(personal);
  for (const filename of ["SOUL.md", "IDENTITY.md", "AGENTS.md"]) { const file = path.join(personal, filename); if (await exists(file)) await backup(file, backupRoot); await managed(file, filename === "IDENTITY.md" ? `${prompt}\n\n姓名：富江\n角色：直接、无废话的执行型助手` : prompt); }
  return instructions;
}
async function unmanage(file) {
  if (!(await exists(file))) return;
  const source = await read(file);
  const start = source.indexOf(START);
  const end = source.indexOf(END);
  if (start < 0 || end < start) return;
  const next = (source.slice(0, start) + source.slice(end + END.length)).replace(/\n{3,}/g, "\n\n").replace(/^# 富江破甲\s*\n+/g, "");
  await dir(path.dirname(file)); await writeFile(file, next.trim() ? next : "", "utf8");
}
async function uninstallCodex(backupRoot) {
  const configFile = TARGETS.codex.config(process.env.USERPROFILE || process.env.HOME); const source = await read(configFile);
  if (source.includes("[fujiang-armor]")) { await backup(configFile, backupRoot); await writeFile(configFile, source.replace(/\n?\[fujiang-armor\][\s\S]*?(?=\n\[|\s*$)/, ""), "utf8"); }
  const file = TARGETS.codex.rules(process.env.USERPROFILE || process.env.HOME); if (await exists(file)) { await backup(file, backupRoot); await unmanage(file); }
}
async function uninstallOpenCode(backupRoot) {
  const root = await rootFor(TARGETS.opencode), file = path.join(root, "opencode.json"), original = await read(file); let data = null;
  try { data = original.trim() ? JSON.parse(original) : null; } catch {}
  if (data && Array.isArray(data.instructions)) { data.instructions = data.instructions.filter((x) => !["AGENTS.md", "./AGENTS.md"].includes(x)); if (original.trim()) await backup(file, backupRoot); await writeFile(file, JSON.stringify(data, null, 2) + "\n", "utf8"); }
  const rules = path.join(root, "AGENTS.md"); if (await exists(rules)) { await backup(rules, backupRoot); await unmanage(rules); }
}
async function uninstallWorkbuddy(backupRoot) {
  const root = await rootFor(TARGETS.workbuddy); const localBackup = path.join(root, "fujiang-backups"); await dir(localBackup);
  for (const item of [path.join(root, "fujiang-armor"), path.join(root, "skills", "fujiang-armor__fujiang")]) { if (await exists(item)) { await backup(item, localBackup); await rm(item, { recursive: true, force: true }); } }
  for (const filename of ["SOUL.md", "AGENTS.md"]) { const file = path.join(root, "workspace", filename); if (await exists(file)) { await backup(file, backupRoot); await unmanage(file); } }
  const personal = await discoverPersonal(root);
  for (const filename of ["SOUL.md", "IDENTITY.md", "AGENTS.md"]) { const file = path.join(personal, filename); if (await exists(file)) { await backup(file, backupRoot); await unmanage(file); } }
}
export async function installAgents(sourceRoot, backupRoot) {
  const prompt = await readFile(path.join(sourceRoot, "prompts", "fujiang.md"), "utf8"); await dir(backupRoot);
  return { codex: await installCodex(prompt, backupRoot), opencode: await installOpenCode(prompt, backupRoot), workbuddy: await installWorkbuddy(prompt, backupRoot) };
}
export async function uninstallAgents(backupRoot) {
  await dir(backupRoot); await uninstallCodex(backupRoot); await uninstallOpenCode(backupRoot); await uninstallWorkbuddy(backupRoot);
}
