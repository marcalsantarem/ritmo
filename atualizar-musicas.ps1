# Atualiza musicas.json automaticamente a partir dos arquivos em .\musicas\
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir = Join-Path $root 'musicas'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$exts = @('.mp3', '.m4a', '.wav', '.aac')
$items = Get-ChildItem -Path $dir -File | Where-Object { $exts -contains $_.Extension.ToLower() } | Sort-Object Name

$list = @()
foreach ($f in $items) {
  $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
  $parts = $base -split '-'
  if ($parts.Count -ge 2) {
    $artista = ($parts[-1] -creplace '([a-z])([A-Z])', '$1 $2').Trim()
    $titulo = (($parts[0..($parts.Count - 2)] -join ' ') -creplace '([a-z])([A-Z])', '$1 $2').Trim()
  } else {
    $titulo = ($base -replace '[_-]+', ' ').Trim()
    $artista = 'Biblioteca'
  }
  $list += [PSCustomObject]@{
    titulo  = $titulo
    artista = $artista
    arquivo = "musicas/$($f.Name)"
  }
}

$json = ConvertTo-Json -InputObject @($list) -Depth 3
[System.IO.File]::WriteAllText((Join-Path $root 'musicas.json'), $json, [System.Text.UTF8Encoding]::new($false))
Write-Host "musicas.json atualizado com $($list.Count) faixa(s)."
