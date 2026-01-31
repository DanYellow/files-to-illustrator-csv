# Générateur de csv pour Illustrator

Ce script Powershell permet de générer un fichier csv à partir du dossier dans lequel il est exécuté. Le but du csv généré est remplacer les fichiers liés via la fonctionnalité "Variables" d'Illustrator.


## Générer le fichier .exe

```ps
Invoke-PS2EXE `
    -InputFile files-to-illustrator-csv.ps1 `
    -OutputFile generation-csv-illustrator.exe `
    -NoConsole:$true `
    -title:Générateur de fichier csv compatible avec Illustrator`
    -IconFile files-to-illustrator-csv-icon.ico
```

```ps
# .\script.ps1 -ColumnCount 4 -Extensions jpg,png
```