param([string]$Root)
$skip = @('node_modules','test-results','playwright-report','.git','blob-report')
function Show($dir, $prefix) {
  $items = Get-ChildItem -LiteralPath $dir -Force | Where-Object { $skip -notcontains $_.Name } |
    Sort-Object @{e={-not $_.PSIsContainer}}, Name
  for ($i = 0; $i -lt $items.Count; $i++) {
    $last = ($i -eq $items.Count - 1)
    $branch = if ($last) { '\-- ' } else { '+-- ' }
    $name = if ($items[$i].PSIsContainer) { $items[$i].Name + '/' } else { $items[$i].Name }
    Write-Host ($prefix + $branch + $name)
    if ($items[$i].PSIsContainer) {
      $next = if ($last) { $prefix + '    ' } else { $prefix + '|   ' }
      Show $items[$i].FullName $next
    }
  }
}
Write-Host ((Split-Path $Root -Leaf) + '/')
Show $Root ''
Write-Host ''
Write-Host '(node_modules/ is installed but hidden from this view)'
