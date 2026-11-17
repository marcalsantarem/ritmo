# Atualiza musicas.json automaticamente a partir dos arquivos em .\musicas\
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir = Join-Path $root 'musicas'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$knownArtists = @(
  @{ Suffix = '-Red-Hot-Chili-Peppers'; Artist = 'Red Hot Chili Peppers' },
  @{ Suffix = '-Foo-Fighters';          Artist = 'Foo Fighters' },
  @{ Suffix = '-Led-Zeppelin';          Artist = 'Led Zeppelin' },
  @{ Suffix = '-Jack-Johnson';          Artist = 'Jack Johnson' },
  @{ Suffix = '-Pearl-Jam';             Artist = 'Pearl Jam' },
  @{ Suffix = '-PearlJam';              Artist = 'Pearl Jam' },
  @{ Suffix = '-Arcade-Icon';           Artist = 'Arcade Icon' },
  @{ Suffix = '-ArcadeIcon';            Artist = 'Arcade Icon' },
  @{ Suffix = '-ACDC';                  Artist = 'AC/DC' }
)

$titleFixes = @{
  'Cant Stop'           = "Can't Stop"
  'Dont Stop Believin'  = "Don't Stop Believin'"
  'TNT'                 = 'T.N.T.'
}

$exts = @('.mp3', '.m4a', '.wav', '.aac', '.ogg')
$items = Get-ChildItem -Path $dir -File | Where-Object { $exts -contains $_.Extension.ToLower() } | Sort-Object Name

$list = @()
foreach ($f in $items) {
  $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
  $artista = $null
  $tituloRaw = $null

  foreach ($ka in $knownArtists) {
    if ($base.EndsWith($ka.Suffix, [System.StringComparison]::OrdinalIgnoreCase)) {
      $artista = $ka.Artist
      $tituloRaw = $base.Substring(0, $base.Length - $ka.Suffix.Length)
      break
    }
  }

  if (-not $artista) {
    $parts = $base -split '-'
    if ($parts.Count -ge 2) {
      $artista = ($parts[-1] -creplace '([a-z])([A-Z])', '$1 $2').Trim()
      $tituloRaw = ($parts[0..($parts.Count - 2)] -join ' ')
    } else {
      $tituloRaw = $base
      $artista = 'Biblioteca'
    }
  }

  $titulo = (($tituloRaw -replace '[_-]+', ' ') -creplace '([a-z])([A-Z])', '$1 $2').Trim()
  if ($titleFixes.ContainsKey($titulo)) {
    $titulo = $titleFixes[$titulo]
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
