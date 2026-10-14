# 富江破甲安装脚本

[CmdletBinding()]
param()

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
$ErrorActionPreference = 'Stop'
$pluginName     = 'fujiang-armor'
$pluginLabel    = '富江破甲'
$legacyPlugins  = @()

# ---------- 输出辅助 ----------
function Write-Step { param([string]$Msg) Write-Host "`n==> $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "    [OK] $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "    [!] $Msg" -ForegroundColor Yellow }
function Write-Err  { param([string]$Msg) Write-Host "    [X] $Msg" -ForegroundColor Red }

# ---------- 路径 ----------
$dshRoot     = Join-Path $env:USERPROFILE '.dsh'
$pluginsDir  = Join-Path $dshRoot 'plugins'
$destDir     = Join-Path $pluginsDir $pluginName
$srcDir      = $PSScriptRoot

# ---------- 自动探测 DSH profile 目录 ----------
function Find-ProfileDirs {
    param([string]$ProfilesRoot)

    if ($env:DSH_PROFILE) {
        $candidate = Join-Path $ProfilesRoot $env:DSH_PROFILE
        if (Test-Path (Join-Path $candidate 'package.json')) { return @($candidate) }
        Write-Warn "环境变量 DSH_PROFILE 指向的目录不存在：$candidate（继续自动探测）"
    }

    $found = @()
    foreach ($name in @('web', 'default', 'desktop')) {
        $candidate = Join-Path $ProfilesRoot $name
        if (Test-Path (Join-Path $candidate 'package.json')) { $found += $candidate }
    }
    if ($found.Count -gt 0) { return $found }

    $dirs = @(Get-ChildItem -LiteralPath $ProfilesRoot -Directory -Force -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName 'package.json') })
    if ($dirs.Count -eq 1) { return @($dirs[0].FullName) }
    if ($dirs.Count -gt 1) {
        Write-Host '检测到多个 DSH profile，请选择要安装的目标：' -ForegroundColor Yellow
        for ($i = 0; $i -lt $dirs.Count; $i++) {
            Write-Host "  [$($i + 1)] $($dirs[$i].Name)" -ForegroundColor White
        }
        try {
            $sel = Read-Host '请输入序号'
            $idx = [int]$sel - 1
            if ($idx -ge 0 -and $idx -lt $dirs.Count) { return @($dirs[$idx].FullName) }
        } catch { }
        Write-Err '选择无效，退出。'
        exit 1
    }
    return @()
}

Write-Host "`n====================" -ForegroundColor Cyan
Write-Host "  $pluginLabel v0.4.4 一键安装" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan

# ---------- [1] 检查环境 ----------
Write-Step '检查环境'

$profilesRoot = Join-Path $dshRoot 'profiles'
if (-not (Test-Path $profilesRoot)) {
    Write-Err "未找到 DSH profiles 目录：$profilesRoot"
    Write-Host  '请先安装并启动过一次 DeepSeek Harness 再运行本脚本。' -ForegroundColor Red
    exit 1
}
$profileDirs = @(Find-ProfileDirs $profilesRoot)
if ($profileDirs.Count -eq 0) {
    Write-Err "未找到 DSH profile 目录。"
    exit 1
}
foreach ($p in $profileDirs) { Write-Ok "DSH profile：$p" }

foreach ($relativeFile in @('package.json', 'index.js', 'client.js', 'scripts\ensure-runtime.ps1', 'scripts\lib\migrate.js', 'scripts\lib\patcher.js', 'scripts\lib\agents.mjs', 'scripts\lib\run-agents.mjs', 'prompts\fujiang.md')) {
    if (-not (Test-Path -LiteralPath (Join-Path $srcDir $relativeFile) -PathType Leaf)) {
        Write-Err "安装包缺少文件：$relativeFile。请完整解压后再运行。"
        exit 1
    }
}

Write-Step '自动准备运行环境'
try {
    . (Join-Path $srcDir 'scripts\ensure-runtime.ps1')
    $runtime = Ensure-FujiangRuntime
    $nodeBin = $runtime.NodePath
    $npmPath = $runtime.NpmPath
    $pnpmPath = $runtime.PnpmPath
} catch {
    Write-Err "运行环境准备失败：$($_.Exception.Message)"
    exit 1
}

# ---------- [1.5] 清理旧版残留 ----------
Write-Step '检查旧版本'
& $nodeBin (Join-Path $srcDir 'scripts\lib\migrate.js') $dshRoot @profileDirs | Out-Null
if ($LASTEXITCODE -ne 0) { throw '旧版插件迁移失败，请根据上面的错误修复后重试。' }
Write-Ok '旧版注册与依赖已迁移。'

# ---------- [2] 复制插件到 plugins 目录 ----------
Write-Step '复制插件文件'
if (-not (Test-Path $pluginsDir)) { New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null }
if (Test-Path $destDir) {
    Write-Warn "检测到已存在的 $pluginName 目录，自动覆盖更新。"
    Remove-Item -LiteralPath $destDir -Recurse -Force
}
robocopy $srcDir $destDir /E /NFL /NDL /NJH /NJS /NC /NS /XD .git /XF install.ps1 uninstall.ps1 install.bat | Out-Null
if ($LASTEXITCODE -ge 8) {
    Write-Err "复制失败（robocopy 退出码 $LASTEXITCODE）"
    exit 1
}
Write-Ok "插件已复制到：$destDir"

# ---------- [3] 备份 package.json ----------
Write-Step '备份 package.json'
foreach ($pDir in $profileDirs) {
    $pkgPath = Join-Path $pDir 'package.json'
    $bakPath = "$pkgPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item -LiteralPath $pkgPath -Destination $bakPath -Force
    Write-Ok "备份完成：$bakPath"
}

# ---------- [4] 写入依赖与 bundles ----------
Write-Step '写入 profile 配置'
foreach ($pDir in $profileDirs) {
    $pName = Split-Path $pDir -Leaf
    $pkgPath = Join-Path $pDir 'package.json'
    Write-Host "  -> 处理 Profile: $pName" -ForegroundColor White

    $pkg = Get-Content -LiteralPath $pkgPath -Raw -Encoding UTF8 | ConvertFrom-Json

    if (-not $pkg.dependencies) { $pkg | Add-Member -NotePropertyName 'dependencies' -NotePropertyValue @{} }
    foreach ($old in $legacyPlugins) {
        if ($pkg.dependencies.PSObject.Properties.Name -contains $old) {
            $pkg.dependencies.PSObject.Properties.Remove($old)
        }
    }
    if ($pkg.dependencies.PSObject.Properties.Name -contains $pluginName) {
        Write-Warn "[$pName] dependencies 已包含 $pluginName，跳过"
    } else {
        $pkg.dependencies | Add-Member -NotePropertyName $pluginName -NotePropertyValue "file:../../plugins/$pluginName" -Force
        Write-Ok "[$pName] dependencies 已添加"
    }

    if ($pkg.dsh -and $pkg.dsh.profile -and $pkg.dsh.profile.bundles) {
        $bundles = @($pkg.dsh.profile.bundles)
        foreach ($old in ($legacyPlugins + @($pluginName))) {
            $bundles = @($bundles | Where-Object { $_ -ne $old })
        }
        $pkg.dsh.profile.bundles = $bundles
    }

    $json = $pkg | ConvertTo-Json -Depth 10
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($pkgPath, $json + [Environment]::NewLine, $utf8NoBom)
    Write-Ok "[$pName] package.json 已更新"

    # ---------- [5] pnpm install ----------
    Write-Step "[$pName] 安装依赖（pnpm install）"
    $nmEntry = Join-Path $pDir "node_modules\$pluginName"
    if (Test-Path $nmEntry) {
        try {
            if ((Get-Item $nmEntry).LinkType -eq 'Junction') {
                cmd.exe /c "rmdir `"$nmEntry`"" 2>$null | Out-Null
            } else {
                Remove-Item -LiteralPath $nmEntry -Recurse -Force
            }
        } catch {
            Remove-Item -LiteralPath $nmEntry -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    $nmDir = Join-Path $pDir 'node_modules'
    if (-not (Test-Path $nmDir)) { New-Item -ItemType Directory -Path $nmDir -Force | Out-Null }
    cmd.exe /c "mklink /J `"$nmEntry`" `"$destDir`"" 2>$null | Out-Null

    Push-Location $pDir
    try {
        if ($pnpmPath) { & $pnpmPath install }
        else { & $npmPath exec --yes --package=pnpm@10 -- pnpm install }
        if ($LASTEXITCODE -ne 0) { throw "依赖安装失败，退出码 $LASTEXITCODE。" }
        Write-Ok "[$pName] 依赖安装完成"
    } catch {
        Write-Err "[$pName] $($_.Exception.Message)"
        exit 1
    } finally { Pop-Location }
}

# ---------- [6] 配置 Codex / OpenCode / WorkBuddy ----------
Write-Step '配置 Codex / OpenCode / WorkBuddy'
$agentBackupRoot = Join-Path $env:LOCALAPPDATA 'FujiangArmor\backup'
$agentScript = Join-Path $srcDir 'scripts\lib\run-agents.mjs'
& $nodeBin $agentScript install $srcDir $agentBackupRoot
if ($LASTEXITCODE -ne 0) { Write-Warn '跨代理适配安装失败（不影响 DSH 部分）。' }
else { Write-Ok "跨代理规则已配置，备份目录：$agentBackupRoot" }

# ---------- [7] 完成 ----------
Write-Step '安装完成'
Write-Host ''
Write-Host "  $pluginLabel v0.4.4 已安装（DSH + Codex + OpenCode + WorkBuddy）！" -ForegroundColor Green
Write-Host ''
Write-Host "  目标 DSH profile：$((($profileDirs | ForEach-Object { Split-Path $_ -Leaf }) -join ', '))" -ForegroundColor White
Write-Host '  最后一步：完全退出并重启目标程序，新建会话即可生效。' -ForegroundColor White
Write-Host ''
Write-Host '  验证：DSH 输入框上方应显示「富江破甲已激活」；Codex 输入「富江」。' -ForegroundColor Yellow
Write-Host ''
Write-Host '  卸载：双击「点我一键卸载.bat」。' -ForegroundColor Yellow
Write-Host ''

try { Read-Host 'Press Enter to exit' } catch { }
