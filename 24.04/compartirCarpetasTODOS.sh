#!/bin/bash

# Script para configurar el PC del PROFESOR

# Variables
PROFESOR_GROUP="profesorado"
ALUMNO_GROUP="alumnado"  # Este grupo solo existe en los PCs de los alumnos
CARPETA="/mnt/compartido"

SMB_CONF="/etc/samba/smb.conf"

sudo apt install -y samba smbclient cifs-utils

# Crear punto de montaje y carpetas compartidas
sudo mkdir -p "$CARPETA"

sudo chmod 777 "$CARPETA"
sudo chown nobody:nogroup "$CARPETA"

sudo echo -e "[CompartidoAbierto]\n   path = /mnt/compartido\n   browseable = yes\n   read only = no\n   guest ok = yes\n   public = yes\n   create mask = 0777\n   directory mask = 0777\n   force user = nobody\n   force group = nogroup" | sudo tee -a /etc/samba/smb.conf > /dev/null

sudo systemctl restart smbd.service

# Mensaje final
echo "Configuración completada SAMBA en el PC del PROFESOR. Las carpetas están accesibles en $CARPETA."
