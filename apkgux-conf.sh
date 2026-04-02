#!/bin/zsh

# ================================================= #
# APKGUX-KONFIGURATIONSSKRIPT
# ================================================= #

CONFIG_FILE="$(dirname "$0")/apkgux.cfg"

# Prüfen, ob die Konfigurationsdatei existiert
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Fehler: $CONFIG_FILE nicht gefunden"
    exit 1
fi

# Aktuelle Konfiguration laden
source "$CONFIG_FILE"

clear
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║        APKGUX-KONFIGURATION                              ║"
echo "║   Bearbeiten Sie den Wert oder drücken Sie Enter         ║"
echo "║      zum Beibehalten der aktuellen Einstellung           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Función para manejar cancelación con ESC
trap_cancel() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║  Konfiguration abgebrochen (ESC gedrückt)               ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    exit 0
}

# Trap para ESC (SIGINT)
trap trap_cancel INT

# Konfigurationsvariablen
CONF_PATH="$PATH"
CONF_HOME="$HOME"
CONF_AUTOPKG_CACHE="$AUTOPKG_CACHE"
CONF_MNTPO="$MNTPO"
CONF_REPOS="$REPOS"
CONF_OVERR="$OVERR"
CONF_LISTA="$LISTA"
CONF_LOGFI="$LOGFI"
CONF_SMTP_SRVR="$SMTP_SRVR"
CONF_SMTP_PORT="$SMTP_PORT"
CONF_SMTP_USER="$SMTP_USER"
CONF_SMTP_PASS="$SMTP_PASS"
CONF_FROM_EMAIL="$FROM_EMAIL"
CONF_TO_EMAIL="$TO_EMAIL"
CONF_SUBJECT="$SUBJECT"

# Werte mit vared bearbeiten

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  SYSTEM VARIABEL"
echo "═══════════════════════════════════════════════════════════"
echo ""
vared -p "▶ System-PATH: " CONF_PATH
vared -p "▶ HOME-Verzeichnis: " CONF_HOME

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  AUTOPKG VARIABEL"
echo "═══════════════════════════════════════════════════════════"
echo ""
vared -p "▶ AutoPkg-Zwischenspeicher: " CONF_AUTOPKG_CACHE
vared -p "▶ Container-Bereitstellungspunkt: " CONF_MNTPO
vared -p "▶ Rezeptrepositorium-Pfade: " CONF_REPOS
vared -p "▶ Rezept-Override-Pfade: " CONF_OVERR
vared -p "▶ Rezeptlistenpfad zum Ausführen: " CONF_LISTA
vared -p "▶ Ergebnis-Protokolldatei: " CONF_LOGFI

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  EMAIL EINSTELLUNGEN"
echo "═══════════════════════════════════════════════════════════"
echo ""
vared -p "▶ SMTP-Server: " CONF_SMTP_SRVR
vared -p "▶ SMTP-Port: " CONF_SMTP_PORT
vared -p "▶ SMTP-Benutzer: " CONF_SMTP_USER
vared -p "▶ SMTP-Passwort: " CONF_SMTP_PASS
vared -p "▶ Absender-E-Mail: " CONF_FROM_EMAIL
vared -p "▶ Empfänger-E-Mail: " CONF_TO_EMAIL
vared -p "▶ E-Mail-Betreff: " CONF_SUBJECT

echo ""

# Sicherung der ursprünglichen Datei erstellen
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
    echo "✓ Sicherung erstellt: ${CONFIG_FILE}.bak"
fi

# Neue Konfiguration speichern
cat > "$CONFIG_FILE" << 'EOF'
# ================================================= #
# APKGUX-KONFIGURATIONSDATEI
# ================================================= #

# ================================================= #
# SYSTEM VARIABEL
# ================================================= #

EOF

echo "export PATH=\"$CONF_PATH\"" >> "$CONFIG_FILE"
echo "export HOME=\"$CONF_HOME\"" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "# ================================================= #" >> "$CONFIG_FILE"
echo "# AUTOPKG VARIABEL" >> "$CONFIG_FILE"
echo "# ================================================= #" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "export AUTOPKG_CACHE=\"$CONF_AUTOPKG_CACHE\"" >> "$CONFIG_FILE"
echo "export MNTPO=\"$CONF_MNTPO\"" >> "$CONFIG_FILE"
echo "export REPOS=\"$CONF_REPOS\"" >> "$CONFIG_FILE"
echo "export OVERR=\"$CONF_OVERR\"" >> "$CONFIG_FILE"
echo "export LISTA=\"$CONF_LISTA\"" >> "$CONFIG_FILE"
echo "export LOGFI=\"$CONF_LOGFI\"" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "# ================================================= #" >> "$CONFIG_FILE"
echo "# EMAIL EINSTELLUNGEN" >> "$CONFIG_FILE"
echo "# ================================================= #" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "export SMTP_SRVR=\"$CONF_SMTP_SRVR\"" >> "$CONFIG_FILE"
echo "export SMTP_PORT=\"$CONF_SMTP_PORT\"" >> "$CONFIG_FILE"
echo "export SMTP_USER=\"$CONF_SMTP_USER\"" >> "$CONFIG_FILE"
echo "export SMTP_PASS=\"$CONF_SMTP_PASS\"" >> "$CONFIG_FILE"
echo "export FROM_EMAIL=\"$CONF_FROM_EMAIL\"" >> "$CONFIG_FILE"
echo "export TO_EMAIL=\"$CONF_TO_EMAIL\"" >> "$CONFIG_FILE"
echo "export SUBJECT=\"$CONF_SUBJECT\"" >> "$CONFIG_FILE"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║      ✓ KONFIGURATION ERFOLGREICH GESPEICHERT             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Datei aktualisiert: $CONFIG_FILE"
echo ""

