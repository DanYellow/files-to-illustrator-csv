# Générateur de csv pour Illustrator

![](./files-to-illustrator-csv-icon.ico)

Ce script Powershell permet de générer un fichier csv à partir du dossier dans lequel il est exécuté. Le but du fichier csv généré est de remplir les variables définies via la fonctionnalité "Variables" d'Illustrator.

Le script génère les colonnes suivantes :
- nom : Concaténation de l'ensemble des noms de fichiers de la ligne
- @imageN: Chemin absolu de l'image
- #imageN_visibilite: Indique si l'image doit être affichée. La valeur sera à "False" s'il n'y a pas de fichier

[Le fichier respecte la nomenclature définie par Illustrator dans sa documentation.](https://helpx.adobe.com/fr/illustrator/using/data-driven-graphics-templates-variables.html#set-up-csv-source-file)


## Générer le fichier .exe

```ps
Invoke-PS2EXE `
    -InputFile files-to-illustrator-csv.ps1 `
    -OutputFile "Générer CSV pour Illustrator.exe" `
    -NoConsole:$false `
    -title:"Générateur de fichier csv compatible avec Illustrator"`
    -description "Génère des fichiers CSV compatibles avec Adobe Illustrator" `
    -IconFile files-to-illustrator-csv-icon.ico
```

## Exécuter le script Powershell
```ps
# .\files-to-illustrator-csv.ps1 -ColumnCount 4 -Extensions jpg,png
```

## Générer l'icône de l'exécutable

```sh
magick "files-to-illustrator-csv-icon.png" -define icon:auto-resize=16,32,48,256 files-to-illustrator-csv-icon.ico
```

## Ajouter l'exécutable au menu contextuel de Windows 

Ceci vous permettra d'accéder au script depuis partout sur votre ordinateur sans avoir besoin de déplacer l'exécutable dans chaque dossier

- Ajouter l'exécutable "Générer CSV pour Illustrator.exe" dans le dossier `C:\tools\files-to-illustrator-csv` (à créer si besoin)
- Double cliquer sur le fichier "IllustratorCSV_ContextMenu.reg"

> Note : si le fichier "IllustratorCSV_ContextMenu.reg" est amené à être mis à jour, il faudra juste remplacer celui dans le dossier `C:\tools\files-to-illustrator-csv` par la dernière version