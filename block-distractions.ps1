# Dev-Execution host block for Windows. Run PowerShell as Administrator.
# Edit $domains first. Friction tool, not a security control.
param([string]$HostsFile = "$env:SystemRoot\System32\drivers\etc\hosts", [switch]$Unblock)
$start = "# >>> dev-execution-block >>>"
$end = "# <<< dev-execution-block <<<"
$domains = "twitter.com","x.com","reddit.com","news.ycombinator.com","facebook.com","instagram.com","youtube.com"
$pattern = "(?s)" + [regex]::Escape($start) + ".*?" + [regex]::Escape($end) + "\r?\n?"
$content = ((Get-Content $HostsFile -Raw) -replace $pattern, "").TrimEnd()
if (-not $Unblock) {
  $rows = foreach ($d in $domains) { "127.0.0.1 $d"; "127.0.0.1 www.$d" }
  $content += "`r`n" + ((@($start) + $rows + @($end)) -join "`r`n")
}
Set-Content -Path $HostsFile -Value $content -Encoding ascii
ipconfig /flushdns | Out-Null
if ($Unblock) { "Block removed." } else { "Dev-Execution block active." }
