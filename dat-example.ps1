# # Define the list of remote computers
$computers = "COMPUTER1", "COMPUTER2", "COMPUTER3"

# Répértoire contenant le fichier de log
$log_dir = 'ProgramData\McAfee\DesktopProtection'

# Nom du fichier de log
$log_file = 'UpdateLog.txt'

# Obtenir la date actuelle
$current_date = Get-Date

# Faire une boucle sur chaque machine du pool
foreach ($computer in $computers)
{
    # Répértoire complet du fichier de log
    $log_path = "\\$computer\\c$\\$log_dir\\$log_file"

    # Vérifier que le fichier de log existe bien sur la machine
    if (Test-Path $log_path)
    {
        # Obtenir l'objet du fichier pour le fichier de log
        $log_file_obj = Get-ChildItem $log_path

        # Obtenir la dernière date de modification du fichier de log
        $last_modified_date = $log_file_obj.LastWriteTime

        # Vérifier que la dernière date de modification du fichier de log est inférieure à 3 jours
        if ($last_modified_date -gt $current_date.AddDays(-3))
        {
            # Lire le contenu du fichier de log
            $log_contents = Get-Content $log_path

            # Prendre la dernière ligne du fichier de log
            $last_line = $log_contents[-1]

            # Vérifier que la dernière ligne du fichier de log contient "Update Finished" or "Mise à jour terminée"
            if ($last_line -like "*Update Finished*" -or $last_line -like "*Mise à jour terminée*")
            {
                Write-Output "Log à jour sur $computer"
            }
            else
            {
                Write-Output "Log non à jour sur $computer"
            }
        }
        else
        {
            Write-Output "Log non modifié durant les 3 derniers jours sur $computer"
        }
    }
    else
    {
        Write-Output "Fichier de log introuvable sur $computer"
    }
}
pause