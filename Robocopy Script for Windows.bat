@echo off
:: Check for admin privileges and request elevation
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    
setlocal enabledelayedexpansion
cls

:LANGUAGE_SELECT
echo:       ______________________________________________________________
echo:
echo:                   DJ SKIPE ROBOCOPY SCRIPT v1.1
echo:
echo:                Select your language / Seleziona la lingua:
echo:                1. English
echo:                2. Italiano
echo:       ______________________________________________________________
echo:
set /p lang_choice="Select a language (1-2): "

if "%lang_choice%"=="1" goto ENGLISH_MENU
if "%lang_choice%"=="2" goto ITALIAN_MENU
goto LANGUAGE_SELECT

:ENGLISH_MENU
cls
echo:       ______________________________________________________________
echo:
echo:                   DJ SKIPE ROBOCOPY SCRIPT v1.1
echo:
echo:                   Advanced Backup and Synchronization
echo:                   Time Selection and Detailed Options
echo:
echo:                   Developer: dj skipe
echo:
echo:               GitHub: https://github.com/djskipe
echo:       ______________________________________________________________

echo                       MAIN MENU:
echo:
echo            1. Local copy (folder to folder)
echo            2. Network drive copy (with drive mapping)
echo            3. Configure Scheduled Backup
echo            4. View Scheduled Backups
echo            5. Delete Scheduled Backup
echo            6. Exit
echo:
set /p choice="Select an option (1-6): "

if "%choice%"=="1" goto ENGLISH_LOCAL_COPY
if "%choice%"=="2" goto ENGLISH_NETWORK_COPY
if "%choice%"=="3" goto ENGLISH_CONFIGURE_BACKUP
if "%choice%"=="4" goto ENGLISH_VIEW_BACKUP
if "%choice%"=="5" goto ENGLISH_DELETE_BACKUP
if "%choice%"=="6" exit
goto ENGLISH_MENU

:ENGLISH_LOCAL_COPY
echo:
set /p source="Enter source folder path (e.g. C:\Users\Desktop): "
set /p destination="Enter destination folder path: "

echo:
echo File comparison and replacement options:
echo 1. Copy only new or modified files
echo 2. Always replace existing files
echo 3. Compare by size, date, and attributes
echo 4. Copy only if files are different
echo:
set /p comparison="Choose an option (1-4): "

echo:
echo Confirm these paths?
echo Source: %source%
echo Destination: %destination%
set /p confirm="(Y/N): "
if /i not "%confirm%"=="Y" goto ENGLISH_LOCAL_COPY

if "%comparison%"=="1" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /log:"%temp%\robocopy_log.txt"
)
if "%comparison%"=="2" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /mir /log:"%temp%\robocopy_log.txt"
)
if "%comparison%"=="3" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /is /it /log:"%temp%\robocopy_log.txt"
)
if "%comparison%"=="4" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /xx /log:"%temp%\robocopy_log.txt"
)

echo:
echo Copy completed! Log saved in %temp%\robocopy_log.txt
pause
goto ENGLISH_MENU

:ENGLISH_NETWORK_COPY
echo:
set /p drive_letter="Enter network drive letter (e.g. X): "
set /p network_path="Enter network path (e.g. \\server\share): "
set /p auth="Does the share require username and password? (Y/N): "

if /i "%auth%"=="Y" (
    set /p username="Enter username: "
    set /p password="Enter password: "
    net use %drive_letter%: "%network_path%" /user:%username% %password%
) else (
    net use %drive_letter%: "%network_path%"
)

if errorlevel 1 (
    echo Error connecting to network drive!
    pause
    goto ENGLISH_MENU
)

echo:
echo Network drive successfully mounted as %drive_letter%:
echo:
set /p source="Enter source folder path: "
set /p destination="Enter path on network drive (e.g. %drive_letter%:\MyFolder): "

echo:
echo File comparison and replacement options:
echo 1. Copy only new or modified files
echo 2. Always replace existing files
echo 3. Compare by size, date, and attributes
echo 4. Copy only if files are different
echo:
set /p comparison="Choose an option (1-4): "

echo:
echo Confirm these paths?
echo Source: %source%
echo Destination: %destination%
set /p confirm="(Y/N): "
if /i not "%confirm%"=="Y" goto ENGLISH_NETWORK_COPY

if "%comparison%"=="1" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /log:"%temp%\robocopy_network_log.txt"
)
if "%comparison%"=="2" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /mir /log:"%temp%\robocopy_network_log.txt"
)
if "%comparison%"=="3" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /is /it /log:"%temp%\robocopy_network_log.txt"
)
if "%comparison%"=="4" (
    robocopy "%source%" "%destination%" /E /ZB /r:3 /w:10 /xc /xn /xx /log:"%temp%\robocopy_network_log.txt"
)

echo:
echo Copy completed! Log saved in %temp%\robocopy_network_log.txt

echo:
set /p disconnect="Do you want to disconnect the network drive? (Y/N): "
if /i "%disconnect%"=="Y" net use %drive_letter%: /delete

pause
goto ENGLISH_MENU

:ENGLISH_CONFIGURE_BACKUP
echo:
echo SCHEDULED BACKUP CONFIGURATION
echo:
set /p backup_name="Enter a name for this backup (no spaces): "
set /p source="Enter source folder path: "
set /p destination="Enter destination folder path: "

echo:
echo File comparison and replacement options:
echo 1. Copy only new or modified files
echo 2. Always replace existing files
echo 3. Compare by size, date, and attributes
echo 4. Copy only if files are different
echo:
set /p comparison="Choose an option (1-4): "

echo:
echo Select backup frequency:
echo 1. Daily
echo 2. Weekly
echo 3. Monthly
echo 4. Specific days
echo:
set /p frequency="Choose an option (1-4): "

:ENGLISH_TIME_SELECTION
echo:
echo BACKUP TIME SELECTION
echo:
echo Choose how to set the time:
echo 1. Specific time (HH:MM)
echo 2. Multiple times per day
echo 3. Time interval
echo:
set /p time_choice="Select an option (1-3): "

if "%time_choice%"=="1" (
    set /p time="Enter time (HH:MM format, 24h): "
    set "times=%time%"
)

if "%time_choice%"=="2" (
    set "times="
    :ENGLISH_ADD_TIMES
    set /p new_time="Enter time (HH:MM, 24h) or press ENTER to finish: "
    if "!new_time!"=="" goto ENGLISH_END_TIMES
    set "times=!times! !new_time!"
    goto ENGLISH_ADD_TIMES
    :ENGLISH_END_TIMES
)

if "%time_choice%"=="3" (
    set /p start_time="Enter start time (HH:MM, 24h): "
    set /p end_time="Enter end time (HH:MM, 24h): "
    set /p interval="Enter interval in minutes: "
    
    call :GENERATE_INTERVALS "!start_time!" "!end_time!" !interval!
)

if "%frequency%"=="1" set "backup_type=/mo daily"
if "%frequency%"=="2" set "backup_type=/mo weekly /d *"
if "%frequency%"=="3" set "backup_type=/mo monthly /d 1"
if "%frequency%"=="4" (
    echo Enter days (MON, TUE, WED, THU, FRI, SAT, SUN separated by comma):
    set /p specific_days="Days: "
    set "backup_type=/mo weekly /d !specific_days!"
)

if "%comparison%"=="1" set "comparison_options=/E /ZB /r:3 /w:10 /xc /xn"
if "%comparison%"=="2" set "comparison_options=/E /ZB /r:3 /w:10 /xc /xn /mir"
if "%comparison%"=="3" set "comparison_options=/E /ZB /r:3 /w:10 /xc /xn /is /it"
if "%comparison%"=="4" set "comparison_options=/E /ZB /r:3 /w:10 /xc /xn /xx"

for %%t in (%times%) do (
    schtasks /create /tn "Backup_%backup_name%_%%t" /tr "robocopy \""%source%\"" \""%destination%\"" !comparison_options! /log:\"%temp%\backup_%backup_name%_%%t_log.txt\"" /sc weekly %backup_type% /st %%t
)

echo Scheduled backup created successfully!
echo Logs will be saved in %temp%
pause
goto ENGLISH_MENU

:ENGLISH_VIEW_BACKUP
schtasks /query /fo list /v | findstr /C:"Backup_"
pause
goto ENGLISH_MENU

:ENGLISH_DELETE_BACKUP
echo:
set /p backup_name="Enter the name of the backup to delete: "
schtasks /delete /tn "Backup_%backup_name%" /f
echo Backup deleted!
pause
goto ENGLISH_MENU

:ITALIAN_MENU
cls
echo:       ______________________________________________________________
echo:
echo:                   DJ SKIPE ROBOCOPY SCRIPT v1.0
echo:
echo:               Backup e Sincronizzazione Avanzata  
echo:             Selezione Orario e Opzioni Dettagliate 
echo:
echo:                   Sviluppatore: dj skipe
echo:
echo:               GitHub: https://github.com/djskipe
echo:       ______________________________________________________________

echo                       MENU PRINCIPALE:
echo:
echo            1. Copia locale (da cartella a cartella)
echo            2. Copia su disco di rete (con montaggio unita)
echo            3. Configura Backup Programmato
echo            4. Visualizza Backup Programmati
echo            5. Elimina Backup Programmato
echo            6. Esci
echo:
set /p scelta="Seleziona un'opzione (1-6): "

if "%scelta%"=="1" goto COPIA_LOCALE
if "%scelta%"=="2" goto COPIA_RETE
if "%scelta%"=="3" goto CONFIGURA_BACKUP
if "%scelta%"=="4" goto VISUALIZZA_BACKUP
if "%scelta%"=="5" goto ELIMINA_BACKUP
if "%scelta%"=="6" exit
goto ITALIAN_MENU

:COPIA_LOCALE
echo:
set /p origine="Inserisci il percorso della cartella di origine (es. C:\Users\Desktop): "
set /p destinazione="Inserisci il percorso della cartella di destinazione: "

echo:
echo Opzioni di confronto e sostituzione file:
echo 1. Copia solo file nuovi o modificati
echo 2. Sostituisci sempre i file esistenti
echo 3. Confronta per dimensione, data e attributi
echo 4. Copia solo se i file sono diversi
echo:
set /p confronto="Scegli un'opzione (1-4): "

echo:
echo Confermi questi percorsi?
echo Origine: %origine%
echo Destinazione: %destinazione%
set /p conferma="(S/N): "
if /i not "%conferma%"=="S" goto COPIA_LOCALE

if "%confronto%"=="1" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /log:"%temp%\robocopy_log.txt"
)
if "%confronto%"=="2" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /mir /log:"%temp%\robocopy_log.txt"
)
if "%confronto%"=="3" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /is /it /log:"%temp%\robocopy_log.txt"
)
if "%confronto%"=="4" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /xx /log:"%temp%\robocopy_log.txt"
)

echo:
echo Copia completata! Log salvato in %temp%\robocopy_log.txt
pause
goto ITALIAN_MENU

:COPIA_RETE
echo:
set /p lettere="Inserisci la lettera per il disco di rete (es. X): "
set /p percorso="Inserisci il percorso di rete (es. \\server\share): "
set /p auth="La condivisione richiede username e password? (S/N): "

if /i "%auth%"=="S" (
    set /p username="Inserisci username: "
    set /p password="Inserisci password: "
    net use %lettere%: "%percorso%" /user:%username% %password%
) else (
    net use %lettere%: "%percorso%"
)

if errorlevel 1 (
    echo Errore nella connessione al disco di rete!
    pause
    goto ITALIAN_MENU
)

echo:
echo Disco di rete montato correttamente come %lettere%:
echo:
set /p origine="Inserisci il percorso della cartella di origine: "
set /p destinazione="Inserisci il percorso sul disco di rete (es. %lettere%:\MiaCartella): "

echo:
echo Opzioni di confronto e sostituzione file:
echo 1. Copia solo file nuovi o modificati
echo 2. Sostituisci sempre i file esistenti
echo 3. Confronta per dimensione, data e attributi
echo 4. Copia solo se i file sono diversi
echo:
set /p confronto="Scegli un'opzione (1-4): "

echo:
echo Confermi questi percorsi?
echo Origine: %origine%
echo Destinazione: %destinazione%
set /p conferma="(S/N): "
if /i not "%conferma%"=="S" goto COPIA_RETE

if "%confronto%"=="1" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /log:"%temp%\robocopy_network_log.txt"
)
if "%confronto%"=="2" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /mir /log:"%temp%\robocopy_network_log.txt"
)
if "%confronto%"=="3" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /is /it /log:"%temp%\robocopy_network_log.txt"
)
if "%confronto%"=="4" (
    robocopy "%origine%" "%destinazione%" /E /ZB /r:3 /w:10 /xc /xn /xx /log:"%temp%\robocopy_network_log.txt"
)

echo:
echo Copia completata! Log salvato in %temp%\robocopy_network_log.txt

echo:
set /p disconnetti="Vuoi disconnettere il disco di rete? (S/N): "
if /i "%disconnetti%"=="S" net use %lettere%: /delete

pause
goto ITALIAN_MENU

:CONFIGURA_BACKUP
echo:
echo CONFIGURAZIONE BACKUP PROGRAMMATO
echo:
set /p nome_backup="Inserisci un nome per questo backup (senza spazi): "
set /p origine="Inserisci il percorso della cartella di origine: "
set /p destinazione="Inserisci il percorso della cartella di destinazione: "

echo:
echo Opzioni di confronto e sostituzione file:
echo 1. Copia solo file nuovi o modificati
echo 2. Sostituisci sempre i file esistenti
echo 3. Confronta per dimensione, data e attributi
echo 4. Copia solo se i file sono diversi
echo:
set /p confronto="Scegli un'opzione (1-4): "

echo:
echo Seleziona la frequenza di backup:
echo 1. Giornaliero
echo 2. Settimanale
echo 3. Mensile
echo 4. Giorni specifici
echo:
set /p frequenza="Scegli un'opzione (1-4): "

:SELEZIONE_ORARIO
echo:
echo SELEZIONE ORARIO DI BACKUP
echo:
echo Scegli come impostare l'orario:
echo 1. Ora specifica (HH:MM)
echo 2. Multipli orari nel giorno
echo 3. Intervallo orario
echo:
set /p scelta_orario="Seleziona un'opzione (1-3): "

if "%scelta_orario%"=="1" (
    set /p ora="Inserisci l'ora (formato HH:MM, 24h): "
    set "orari=%ora%"
)

if "%scelta_orario%"=="2" (
    set "orari="
    :AGGIUNGI_ORARI
    set /p nuovo_orario="Inserisci orario (HH:MM, 24h) o premi INVIO per terminare: "
    if "!nuovo_orario!"=="" goto FINE_ORARI
    set "orari=!orari! !nuovo_orario!"
    goto AGGIUNGI_ORARI
    :FINE_ORARI
)

if "%scelta_orario%"=="3" (
    set /p ora_inizio="Inserisci ora inizio (HH:MM, 24h): "
    set /p ora_fine="Inserisci ora fine (HH:MM, 24h): "
    set /p intervallo="Inserisci intervallo in minuti: "
    
    call :GENERA_INTERVALLI "!ora_inizio!" "!ora_fine!" !intervallo!
)

if "%frequenza%"=="1" set "tipo_backup=/mo daily"
if "%frequenza%"=="2" set "tipo_backup=/mo weekly /d *"
if "%frequenza%"=="3" set "tipo_backup=/mo monthly /d 1"
if "%frequenza%"=="4" (
    echo Inserisci i giorni (LUN, MAR, MER, GIO, VEN, SAB, DOM separati da virgola):
    set /p giorni_specifici="Giorni: "
    set "tipo_backup=/mo weekly /d !giorni_specifici!"
)

if "%confronto%"=="1" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn"
if "%confronto%"=="2" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /mir"
if "%confronto%"=="3" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /is /it"
if "%confronto%"=="4" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /xx"

for %%o in (%orari%) do (
    schtasks /create /tn "Backup_%nome_backup%_%%o" /tr "robocopy \""%origine%\"" \""%destinazione%\"" !opzioni_confronto! /log:\"%temp%\backup_%nome_backup%_%%o_log.txt\"" /sc weekly %tipo_backup% /st %%o
)

echo Backup programmato creato con successo!
echo Log dei backup saranno salvati in %temp%
pause
goto ITALIAN_MENU

:VISUALIZZA_BACKUP
schtasks /query /fo list /v | findstr /C:"Backup_"
pause
goto ITALIAN_MENU

:ELIMINA_BACKUP
echo:
set /p nome_backup="Inserisci il nome del backup da eliminare: "
schtasks /delete /tn "Backup_%nome_backup%" /f
echo Backup eliminato!
pause
goto ITALIAN_MENU

:GENERA_INTERVALLI
setlocal
set "start=%~1"
set "end=%~2"
set "step=%~3"

:: Converte ore in minuti
for /f "tokens=1,2 delims=:" %%a in ("%start%") do (
    set /a start_min=(%%a*60)+%%b
)
for /f "tokens=1,2 delims=:" %%a in ("%end%") do (
    set /a end_min=(%%a*60)+%%b
)

set "orari="
set /a current_min=start_min
:LOOP_INTERVALLI
if %current_min% LEQ %end_min% (
    set /a ore=current_min/60
    set /a minuti=current_min%%60
    if !ore! LSS 10 set "ore=0!ore!"
    if !minuti! LSS 10 set "minuti=0!minuti!"
    set "orari=!orari! !ore!:!minuti!"
    set /a current_min+=step
    goto LOOP_INTERVALLI
)

endlocal & set "orari=%orari%"
exit /b

:GENERATE_INTERVALS
setlocal
set "start=%~1"
set "end=%~2"
set "step=%~3"

:: Convert hours to minutes
for /f "tokens=1,2 delims=:" %%a in ("%start%") do (
    set /a start_min=(%%a*60)+%%b
)
for /f "tokens=1,2 delims=:" %%a in ("%end%") do (
    set /a end_min=(%%a*60)+%%b
)

set "times="
set /a current_min=start_min
:INTERVAL_LOOP
if %current_min% LEQ %end_min% (
    set /a hours=current_min/60
    set /a minutes=current_min%%60
    if !hours! LSS 10 set "hours=0!hours!"
    if !minutes! LSS 10 set "minutes=0!minutes!"
    set "times=!times! !hours!:!minutes!"
    set /a current_min+=step
    goto INTERVAL_LOOP
)

endlocal & set "times=%times%"
exit /b