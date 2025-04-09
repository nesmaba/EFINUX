#!/bin/bash

# Script para configurar el PC del PROFESOR

# Variables
PROFESOR_GROUP="profesorado"
ALUMNO_GROUP="alumnado"  # Este grupo solo existe en los PCs de los alumnos
MOUNT_POINT="/mnt/compartido"
CARPETA_PROFESORADO="$MOUNT_POINT/CompartidoProfesorado"
CARPETA_ALUMNADO="$MOUNT_POINT/CompartidoAlumnado"
SMB_CONF="/etc/samba/smb.conf"

sudo apt install -y samba smbclient cifs-utils

# Crear archivo de configuración si no existe
if [ ! -f "$SMB_CONF" ]; then
    echo "Creando archivo de configuración de Samba..."
    sudo mkdir -p /etc/samba
    echo "[global]" | sudo tee $SMB_CONF > /dev/null
fi

# Crear punto de montaje y carpetas compartidas
sudo mkdir -p "$CARPETA_PROFESORADO"
sudo mkdir -p "$CARPETA_ALUMNADO"

# Asignar permisos
sudo chown root:$PROFESOR_GROUP "$MOUNT_POINT"
sudo chmod 770 "$MOUNT_POINT"

sudo chown root:$PROFESOR_GROUP "$CARPETA_PROFESORADO"
sudo chmod 770 "$CARPETA_PROFESORADO"

sudo chown root:$PROFESOR_GROUP "$CARPETA_ALUMNADO"
sudo chmod 770 "$CARPETA_ALUMNADO"

# Configurar Samba
sudo bash -c "cat >> $SMB_CONF" <<EOL

[CompartidoProfesorado]
   path = $CARPETA_PROFESORADO
   browseable = yes
   read only = yes
   guest ok = no
   valid users = @$PROFESOR_GROUP
   write list = @$PROFESOR_GROUP
   create mask = 0664
   directory mask = 0775

[CompartidoAlumnado]
   path = $CARPETA_ALUMNADO
   browseable = yes
   read only = yes
   guest ok = no
   # Los alumnos no pueden escribir desde el PC del profesor directamente
   valid users = @$PROFESOR_GROUP  # Los profesores tienen acceso de lectura y escritura
   write list = @$PROFESOR_GROUP  # Los profesores tienen permisos de escritura
   create mask = 0664
   directory mask = 0775
   # En los PCs de los alumnos, se montarán con el grupo 'alumnado'
   valid users = @$PROFESOR_GROUP, @$ALUMNO_GROUP  # El grupo 'alumnado' existe solo en PCs de los alumnos
   write list = @$PROFESOR_GROUP, @$ALUMNO_GROUP  # Los alumnos podrán escribir en sus PCs

EOL

# Reiniciar Samba con el servicio correcto
if systemctl list-units --full -all | grep -q "smbd.service"; then
    sudo systemctl restart smbd
elif systemctl list-units --full -all | grep -q "samba.service"; then
    sudo systemctl restart samba
else
    echo "Error: No se pudo encontrar el servicio Samba. Verifique la instalación."
    exit 1
fi

# Mensaje final
echo "Configuración completada en el PC del PROFESOR. Las carpetas están accesibles en $MOUNT_POINT."
