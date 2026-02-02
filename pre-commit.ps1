Import-Module ps2exe

Invoke-PS2EXE `
    -InputFile files-to-illustrator-csv.ps1 `
    -OutputFile "Générer CSV pour Illustrator.exe" `
    -NoConsole:$false `
    -title:"Générateur de fichier csv compatible avec Illustrator"`
    -description "Génère des fichiers CSV compatibles avec Adobe Illustrator" `
    -IconFile files-to-illustrator-csv-icon.ico