# Générateur de csv pour Illustrator

![](./files-to-illustrator-csv-icon.ico)

Ce script Powershell permet de générer un fichier csv à partir du dossier dans lequel il est exécuté. Le but du csv généré est remplacer les fichiers liés via la fonctionnalité "Variables" d'Illustrator.

Le script génère les colonnes suivantes :
- nom : Concaténation de l'ensemble des noms de fichiers de la ligne
- @imageN: Chemin absolu de l'image
- #imageN_visibilite: Indique si l'image doit être affiché

[Le fichier respecte la nomenclature définie par Illustrator dans sa documentation.](https://helpx.adobe.com/fr/illustrator/using/data-driven-graphics-templates-variables.html#set-up-csv-source-file)


## Générer le fichier .exe

```ps
Invoke-PS2EXE `
    -InputFile files-to-illustrator-csv.ps1 `
    -OutputFile generation-csv-illustrator.exe `
    -NoConsole:$false `
    -title:"Générateur de fichier csv compatible avec Illustrator"`
    -IconFile files-to-illustrator-csv-icon.ico
```

```ps
# .\script.ps1 -ColumnCount 4 -Extensions jpg,png
```