#!/bin/bash

# Verificar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
  echo "Por favor, ejecuta el script con sudo."
  exit
fi

echo "Iniciando configuración de fondo bloqueado para MATE..."

# 1. Crear perfil de dconf si no existe
mkdir -p /etc/dconf/profile
if [ ! -f /etc/dconf/profile/user ]; then
    echo -e "user-db:user\nsystem-db:local" > /etc/dconf/profile/user
    echo "[OK] Perfil dconf creado."
fi

# 2. Crear directorios de la base de datos local
mkdir -p /etc/dconf/db/local.d/locks

# 3. Configurar el fondo de pantalla
cat <<EOF > /etc/dconf/db/local.d/00-background
[org/mate/desktop/background]
picture-filename='/usr/share/backgrounds/warty-final-ubuntu.png'
picture-options='zoom'
primary-color='#000000'
EOF

# 4. Bloquear la configuración para que los usuarios no puedan cambiarla
cat <<EOF > /etc/dconf/db/local.d/locks/00-background
/org/mate/desktop/background/picture-filename
/org/mate/desktop/background/picture-options
EOF

# 5. Asegurar permisos de la imagen (por si acaso)
chmod 644 /usr/share/backgrounds/warty-final-ubuntu.png

# 6. Actualizar la base de datos de dconf
dconf update

echo "-------------------------------------------------------"
echo "¡Hecho! El fondo de MATE ha sido configurado y bloqueado."
echo "Nota: Los usuarios actuales deberán reiniciar sesión para ver los cambios."
