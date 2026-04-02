#!/bin/bash

# ================================================= #
# KONFIGURATION LADEN: ----------------------- #
# ================================================= #

CONFIG_FILE="$(dirname "$0")/apkgux.cfg"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Fehler: Konfigurationsdatei $CONFIG_FILE nicht gefunden"
    echo "Führen Sie aus: $(dirname "$0")/apkgux-conf.sh"
    exit 1
fi

source "$CONFIG_FILE"

# LOGFI-Override durch Parameter ermöglichen
if [ -n "$1" ]; then
    LOGFI="/dev/stdout"
    clear
fi

echo ">= STARTZEIT: =>" > "$LOGFI"
date >> "$LOGFI"
echo               

# ================================================= #
# AUSFÜHRUNGSFUNKTION: ----------------------------- #
# ================================================= #

_RUNNER_() {

echo ">======== AKTUALISIERE REPOSITORIEN: ====================>>" >> "$LOGFI"
echo >> "$LOGFI"
autopkg repo-update $REPOS 2>&1 | \
sed 's|Attempting git pull for .*/RecipeRepos/||' >> "$LOGFI"

echo ">======== AKTUALISIERE VERTRAUENSINFORMATIONEN: ========>>" >> "$LOGFI"
echo >> "$LOGFI"
autopkg update-trust-info $OVERR 2>&1 | \
sed 's|^Wrote updated .*RecipeOverrides/||' >> "$LOGFI"

echo >> "$LOGFI"

echo ">======== FÜHRE REZEPTLISTE AUS: ====================>>" >> "$LOGFI"
echo >> "$LOGFI"
echo ">------------ $LISTA ==============>>" >> "$LOGFI"
autopkg run -l "$LISTA" >> "$LOGFI" 2>&1

echo >> "$LOGFI"
echo ">= ENDZEIT: =>" >> "$LOGFI"
date >> "$LOGFI"

}


# ================================================= #
# VERSANDFUNKTION: -------------------------------- #
# ================================================= #

_SENDER_() {

BODY_TEXT=$(cat "$LOGFI")

curl \
    --url "smtps://$SMTP_SRVR:$SMTP_PORT" \
    --ssl-reqd \
    --user "$SMTP_USER:$SMTP_PASS" \
    --mail-from "$SMTP_USER" \
    --mail-rcpt "$TO_EMAIL" \
    --upload-file - \
    <<< "From: $FROM_EMAIL
To: $TO_EMAIL
Subject: $SUBJECT
Content-Type: text/plain; charset=\"UTF-8\"

$BODY_TEXT"

}


# ================================================= #
# HAUPTPROGRAMM: ----------------------------------- #
# ================================================= #

echo >> "$LOGFI"
echo ">======== ÜBERPRÜFE MUNKI-CONTAINER: =================>>" >> "$LOGFI"
echo >> "$LOGFI"

if mount | grep -q "$MNTPO"; then
    echo ">--------------- VORHANDEN ✓ ------------------>>" >> "$LOGFI"
    echo >> "$LOGFI"
else
    echo ">--------------- FEHLT - Bereitstellung läuft... -->>" >> "$LOGFI"
    echo >> "$LOGFI"
    
    rm -rf "$MNTPO"
    mkdir -p "$MNTPO" || { echo "Fehler: Konnte $MNTPO nicht erstellen" >> "$LOGFI"; exit 1; }

    if [ ! -f /etc/apkgu.key ]; then
        echo "Fehler: /etc/apkgu.key nicht gefunden" >> "$LOGFI"
        exit 1
    fi
    
    USER=$(grep '^username=' /etc/apkgu.key | cut -d= -f2)
    PASS=$(grep '^password=' /etc/apkgu.key | cut -d= -f2)
    
    if mount_smbfs "//$USER:$PASS@ideploy.arch.kit.edu/container" "$MNTPO"; then
        echo ">--------------- BEREITGESTELLT ✓ ------------>>" >> "$LOGFI"
        echo >> "$LOGFI"
    else
        echo "Fehler: Konnte SMB-Container nicht bereitstellen" >> "$LOGFI"
        exit 1
    fi
fi

_RUNNER_
_SENDER_
exit 0
