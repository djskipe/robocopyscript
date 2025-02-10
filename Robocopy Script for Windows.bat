@echo off
:: Verifica privilegi di amministratore e richiesta elevazione
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Richiesta dei privilegi di amministratore...
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


:MENU
echo MENU PRINCIPALE:
echo:
echo 1. Copia locale (da cartella a cartella)
echo 2. Copia su disco di rete (con montaggio unita)
echo 3. Configura Backup Programmato
echo 4. Visualizza Backup Programmati
echo 5. Elimina Backup Programmato
echo 6. Esci
echo:
set /p scelta="Seleziona un'opzione (1-6): "

if "%scelta%"=="1" goto COPIA_LOCALE
if "%scelta%"=="2" goto COPIA_RETE
if "%scelta%"=="3" goto CONFIGURA_BACKUP
if "%scelta%"=="4" goto VISUALIZZA_BACKUP
if "%scelta%"=="5" goto ELIMINA_BACKUP
if "%scelta%"=="6" exit
goto MENU

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

:: Opzioni Robocopy per diversi tipi di confronto
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
goto MENU

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
    goto MENU
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

:: Opzioni Robocopy per diversi tipi di confronto
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
goto MENU

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
    
    :: Genera orari tra ora_inizio e ora_fine
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

:: Opzioni Robocopy per diversi tipi di confronto
if "%confronto%"=="1" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn"
if "%confronto%"=="2" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /mir"
if "%confronto%"=="3" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /is /it"
if "%confronto%"=="4" set "opzioni_confronto=/E /ZB /r:3 /w:10 /xc /xn /xx"

:: Creazione task con orari multipli
for %%o in (%orari%) do (
    schtasks /create /tn "Backup_%nome_backup%_%%o" /tr "robocopy \""%origine%\"" \""%destinazione%\"" !opzioni_confronto! /log:\"%temp%\backup_%nome_backup%_%%o_log.txt\"" /sc weekly %tipo_backup% /st %%o
)

echo Backup programmato creato con successo!
echo Log dei backup saranno salvati in %temp%
pause
goto MENU

:VISUALIZZA_BACKUP
schtasks /query /fo list /v | findstr /C:"Backup_"
pause
goto MENU

:ELIMINA_BACKUP
echo:
set /p nome_backup="Inserisci il nome del backup da eliminare: "
schtasks /delete /tn "Backup_%nome_backup%" /f
echo Backup eliminato!
pause
goto MENU

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