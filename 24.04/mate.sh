#!/bin/bash

echo "========================================="
echo " MATE ULTRA-AULA – MEGA SCRIPT FINAL"
echo "========================================="

# -------------------------------
# 0️⃣ Instalar MATE si no está
# -------------------------------
echo "→ Comprobando MATE..."
if ! dpkg -l | grep -q mate-desktop-environment; then
    echo "   • MATE no instalado. Instalando..."
    apt update
    apt install -y mate-desktop-environment mate-desktop-environment-extra
else
    echo "   • MATE ya instalado."
fi

# -------------------------------
# 1️⃣ Eliminar GNOME / Ubuntu / Wayland
# -------------------------------
echo "→ Eliminando GNOME y Wayland..."
apt purge -y ubuntu-desktop gnome-shell gdm3 gnome-session gnome-session-bin gnome-session-common # gnome-session-wayland NO EXISTE DICHO PAQUETE Y PETA
apt autoremove -y --purge

# -------------------------------
# 2️⃣ Forzar MATE en LightDM
# -------------------------------
echo "→ Configurando LightDM para usar MATE por defecto..."
mkdir -p /etc/lightdm/lightdm.conf.d
cat > /etc/lightdm/lightdm.conf.d/99-mate.conf <<EOF
[Seat:*]
user-session=mate
greeter-session=lightdm-gtk-greeter
EOF

# -------------------------------
# 3️⃣ Machacar fondo de MATE
# -------------------------------
FONDO="/usr/share/backgrounds/warty-final-ubuntu.png"
MATE_DEFAULT="/usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo.png"

echo "→ Sobrescribiendo fondo de MATE..."
if [ ! -f "${MATE_DEFAULT}.bak" ]; then
    cp "$MATE_DEFAULT" "${MATE_DEFAULT}.bak"
fi
cp "$FONDO" "$MATE_DEFAULT"

# -------------------------------
# 4️⃣ Aplicar fondo bloqueado a todos los usuarios existentes
# -------------------------------
echo "→ Aplicando fondo bloqueado a usuarios existentes..."
for home in /home/*; do
    [ -d "$home" ] || continue
    USERNAME=$(basename "$home")
    echo "   • Usuario: $USERNAME"

    # Forzar MATE
    cat > "$home/.dmrc" <<EOF
[Desktop]
Session=mate
Language=es_ES.UTF-8
EOF
    chown "$USERNAME:$USERNAME" "$home/.dmrc"
    chmod 644 "$home/.dmrc"

    # Aplicar fondo
    sudo -u "$USERNAME" dbus-launch dconf write /org/mate/desktop/background/picture-filename "'$MATE_DEFAULT'"

    # Hacer el archivo de configuración inmutable
    DCONF_USER_FILE="$home/.config/dconf/user"
    if [ -f "$DCONF_USER_FILE" ]; then
        chattr +i "$DCONF_USER_FILE"
    fi
done

# -------------------------------
# 5️⃣ Preparar hook para usuarios nuevos SSO
# -------------------------------
HOOK_DIR="/usr/local/bin/mate_sso_hook"
mkdir -p "$HOOK_DIR"
cat > "$HOOK_DIR/force_mate_new.sh" <<'EOF'
#!/bin/bash
USERNAME="$1"
HOME_DIR="/home/$USERNAME"
MATE_DEFAULT="/usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo.png"

if [ -d "$HOME_DIR" ]; then
    # Forzar MATE
    cat > "$HOME_DIR/.dmrc" <<DMRC
[Desktop]
Session=mate
Language=es_ES.UTF-8
DMRC
    chown "$USERNAME:$USERNAME" "$HOME_DIR/.dmrc"
    chmod 644 "$HOME_DIR/.dmrc"

    # Aplicar fondo
    sudo -u "$USERNAME" dbus-launch dconf write /org/mate/desktop/background/picture-filename "'$MATE_DEFAULT'"

    # Bloquear dconf del usuario
    DCONF_USER_FILE="$HOME_DIR/.config/dconf/user"
    if [ -f "$DCONF_USER_FILE" ]; then
        chattr +i "$DCONF_USER_FILE"
    fi
fi
EOF
chmod +x "$HOOK_DIR/force_mate_new.sh"

echo
echo "→ Para nuevos usuarios SSO, ejecutar después:"
echo "   sudo /usr/local/bin/mate_sso_hook/force_mate_new.sh NUEVO_USUARIO"
echo

# -------------------------------
# 6️⃣ Reiniciar sistema
# -------------------------------
echo "✅ SCRIPT COMPLETO"
echo "• MATE instalado y único entorno"
echo "• Fondo de escritorio bloqueado aplicado a todos los usuarios existentes"
echo "• Hook preparado para usuarios nuevos SSO"
echo "• GNOME/Wayland eliminados"
echo
echo "⚠️ Se reiniciará el sistema en 10 segundos..."
sleep 10
reboot

