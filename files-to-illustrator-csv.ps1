param (
    [ValidateRange(1,1000)]
    [int]$ColumnCount = 3,
    [string[]]$Extensions = @(".jpg", ".png", ".pdf")
)

function Convert-ToSlug {
    param ([string]$Text)

    $slug = $Text.ToLower()
    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug = $slug -replace '-{2,}', '-'
    $slug = $slug.Trim('-')

    return $slug
}

do {
    $inputColumns = Read-Host "Nombre d'images à remplacer dans le gabarit ?"
} while (-not ($inputColumns -as [int]) -or [int]$inputColumns -le 0)

$currentDirName = Split-Path -Leaf (Get-Location)
$slugDirName = Convert-ToSlug $currentDirName

$ColumnCount = [int]$inputColumns

$timestamp = Get-Date -Format "dd-MM-yyyy_HHmm"
$OutputCsv = "$slugDirName`_$timestamp.csv"

$Extensions = $Extensions | ForEach-Object {
    if ($_ -notmatch '^\.') { ".$_" } else { $_ }
}

# Get files in the current directory (no folders)
$files = Get-ChildItem -File |
Where-Object { $Extensions -contains $_.Extension } |
Select-Object -ExpandProperty FullName

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

    $currentRow[$nameCol] = $currentRow[$nameCol] -join "_"

    $rows += [PSCustomObject]$currentRow
}

# Export to CSV
try {
    $rows | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
    Write-Host "✅ Fichier CSV généré avec succès: $OutputCsv" -ForegroundColor Green
} catch {
    Write-Host "❌ Une erreur est survenue: $_" -ForegroundColor Red
}
