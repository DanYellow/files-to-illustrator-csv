param (
    [ValidateRange(1,1000)]
    [int]$ColumnCount = 3,
    [string[]]$Extensions = @(".jpg", ".png", ".pdf", ".ai")
)

function Convert-ToSlug {
    param ([string]$Text)

    $slug = $Text.ToLower()
    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug = $slug -replace '-{2,}', '-'
    $slug = $slug.Trim('-')

    return $slug
}

$host.UI.RawUI.WindowTitle = "Générateur de fichier CSV compatible avec Illustrator"

Clear-Host

$appName = "Générateur de fichier CSV pour Illustrator"
$currentPath = Get-Location

Write-Host "==================================================" -ForegroundColor DarkGray
Write-Host " $appName" -ForegroundColor Cyan
Write-Host " Dossier courant : $currentPath" -ForegroundColor Yellow
Write-Host " "
Write-Host " **Rappel : Il ne doit pas avoir d'espace ni dans le nom du fichier, ni dans le nom des dossiers**" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor DarkGray
Write-Host ""

# Get files in the current directory (no folders)
$files = Get-ChildItem -File |
Where-Object { $Extensions -contains $_.Extension } |
Select-Object -ExpandProperty FullName

if (-not $files -or $files.Count -eq 0) {
    Write-Host ""
    Write-Host " [X] Aucun fichier trouvé avec les extensions suivantes :" -ForegroundColor Red
    Write-Host " $($Extensions -join ', ')" -ForegroundColor Yellow
    Write-Host " Dossier : $(Get-Location)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Appuyez sur une touche pour fermer…" -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null

    exit
}

do {
    $inputColumns = Read-Host "Nombre d'images à remplacer dans le gabarit du fichier Illustrator ? (valeur entre 1 et 1000 inclus)"
} while (-not ($inputColumns -as [int]) -or [int]$inputColumns -le 0 -or [int]$inputColumns -gt 1000)

$currentDirName = Split-Path -Leaf (Get-Location)
$slugDirName = Convert-ToSlug $currentDirName

$ColumnCount = [int]$inputColumns

# if (-not ($ColumnCount -is [int]) -or [int]$inputColumns -le 0 -or [int]$inputColumns -gt 1000) {
#     Write-Host "[X] ColumnCount must be a positive number." -ForegroundColor Red
#     Start-Sleep -Seconds 3
#     exit
# }

$timestamp = Get-Date -Format "dd-MM-yyyy_HHmm"
$OutputCsv = "$timestamp`_$slugDirName.csv"

$Extensions = $Extensions | ForEach-Object {
    if ($_ -notmatch '^\.') { ".$_" } else { $_ }
}

$rows = @()

# Loop over files in chunks of ColumnCount
for ($i = 0; $i -lt $files.Count; $i += $ColumnCount) {
    $currentRow = [ordered]@{}
    $nameCol = "nom"
    $currentRow[$nameCol] = @()

    for ($j = 0; $j -lt $ColumnCount; $j++) {
        $fileIndex = $i + $j
        $imageCol = "@image$($j + 1)"
        
        $visibilityCol = "#image$($j + 1)_visibilite"
        
        if ($fileIndex -lt $files.Count) {
            $currentRow[$nameCol] += Convert-ToSlug((Get-Item $files[$fileIndex]).BaseName)
            $currentRow[$imageCol] = $files[$fileIndex]
            $currentRow[$visibilityCol] = $true
        } else {
            $currentRow[$imageCol] = ""
            $currentRow[$visibilityCol] = $false
        }
    }

    $currentRow[$nameCol] = $currentRow[$nameCol] -join "__"

    $rows += [PSCustomObject]$currentRow
}

# Export to CSV
try {
    $rows | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
    Write-Host "[✔] Fichier CSV généré avec succès: $OutputCsv" -ForegroundColor Green
    Start-Sleep -Seconds 3

    exit 0
} catch {
    Write-Host "[X] Une erreur est survenue: $_" -ForegroundColor Red
    Write-Host $_
    Write-Host "Appuyez sur une touche pour fermer…"
    [Console]::ReadKey($true) | Out-Null

    exit 1
}
