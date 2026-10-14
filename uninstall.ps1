# 富江破甲卸载脚本

[CmdletBinding()]
param()

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
$ErrorActionPreference = 'Stop'
$pluginName     = 'fujiang-armor'
$pluginLabel    = '富江破甲'
$targetPlugins  = @($pluginName)

function Write-Step { param([string]$Msg) Write-Host "`n==> $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "    [OK] $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "    [!] $Msg" -ForegroundColor Yellow }

$dshRoot     = Join-Path $env:USERPROFILE '.dsh'
$pluginsDir  = Join-Path $dshRoot 'plugins'

Write-Step '查找 DSH profile 配置'
$dirs = @('web', 'default', 'desktop') | ForEach-Object { Join-Path (Join-Path $dshRoot 'profiles') $_ } | Where-Object { Test-Path (Join-Path $_ 'package.json') }

foreach ($pDir in $dirs) {
    $pName = Split-Path $pDir -Leaf
    $pkgPath = Join-Path $pDir 'package.json'
    $pkg = Get-Content -LiteralPath $pkgPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $changed = $false
    foreach ($p in $targetPlugins) {
        if ($pkg.dependencies -and $pkg.dependencies.PSObject.Properties.Name -contains $p) {
            $pkg.dependencies.PSObject.Properties.Remove($p)
            $changed = $true
        }
        if ($pkg.dsh -and $pkg.dsh.profile -and $pkg.dsh.profile.bundles -contains $p) {
            $pkg.dsh.profile.bundles = @($pkg.dsh.profile.bundles | Where-Object { $_ -ne $p })
            $changed = $true
        }
    }
    if ($changed) {
        $json = $pkg | ConvertTo-Json -Depth 10
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($pkgPath, $json + [Environment]::NewLine, $utf8NoBom)
        Write-Ok "[$pName] 已从 package.json 移除插件配置"
    }

    $patchPath = Join-Path $pDir 'cordis.patch.yml'
    if (Test-Path $patchPath) {
        $patchContent = [System.IO.File]::ReadAllText($patchPath, [System.Text.Encoding]::UTF8)
        $cleanedPatch = $patchContent
        foreach ($old in $targetPlugins) {
            $cleanedPatch = $cleanedPatch -replace "(?m)^([ \t]*)-[ \t]+insert:[ \t]*\r?\n[ \t]+-[ \t]+id:[ \t]+$old[ \t]*(?:\r?\n|\z)[\s\S]*?(?=^\1-[ \t]|\z)", ""
        }
        $cleanedPatch = $cleanedPatch.Trim()
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($patchPath, $cleanedPatch + [Environment]::NewLine, $utf8NoBom)
        Write-Ok "[$pName] 已从 cordis.patch.yml 移除插件挂载"
    }

    foreach ($old in $targetPlugins) {
        $nmEntry = Join-Path $pDir "node_modules\$old"
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
    }

    if ($changed) {
        Push-Location $pDir
        try { pnpm install | Out-Null } catch {} finally { Pop-Location }
    }
}

foreach ($p in $targetPlugins) {
    $tDir = Join-Path $pluginsDir $p
    if (Test-Path $tDir) {
        Remove-Item -LiteralPath $tDir -Recurse -Force
        Write-Ok "已删除 DSH 插件目录：$p"
    }
}

Write-Step '清理 Codex / OpenCode / WorkBuddy 注入'
$agentBackupRoot = Join-Path $env:LOCALAPPDATA 'FujiangArmor\backup'
$runnerPath = Join-Path $PSScriptRoot 'scripts\lib\run-agents.mjs'
if (Test-Path $runnerPath) {
    & node $runnerPath uninstall $runnerPath $agentBackupRoot 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Warn "跨代理清理未执行成功（不影响 DSH 卸载）。" }
    else { Write-Ok "Codex / OpenCode / WorkBuddy 规则已移除，备份：$agentBackupRoot" }
}

Write-Ok "$pluginLabel 卸载完成，请重启 DSH、Codex、OpenCode 与 WorkBuddy。"
try { Read-Host 'Press Enter to exit' } catch { }
