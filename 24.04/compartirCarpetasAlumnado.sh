#!/bin/bash

# Script para montar las carpetas compartidas en el PC del ALUMNO

# Variables
PROFESOR_IP="192.168.1.100"  # Cambia esta IP por la IP real del PC del profesor
MOUNT_POINT="/mnt/compartido"
CARPETA_PROFESORADO="$MOUNT_POINT/CompartidoProfesorado"
CARPETA_ALUMNADO="$MOUNT_POINT/CompartidoAlumnado"
ALUMNO_GROUP="alumnado"

# Crear punto de montaje si no existe
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# Montar la carpeta CompartidoProfesorado (solo lectura para los alumnos)
if ! mount | grep -q "$CARPETA_PROFESORADO"; then
    sudo mount -t cifs //$PROFESOR_IP/CompartidoProfesorado "$CARPETA_PROFESORADO" -o username=usuario,domain=lapuri.com,vers=3.0
    echo "Carpeta CompartidoProfesorado montada en $CARPETA_PROFESORADO"
else
    echo "La carpeta CompartidoProfesorado ya está montada."
fi

# Montar la carpeta CompartidoAlumnado (lectura y escritura para alumnos)
if ! mount | grep -q "$CARPETA_ALUMNADO"; then
    sudo mount -t cifs //$PROFESOR_IP/CompartidoAlumnado "$CARPETA_ALUMNADO" -o username=usuario,domain=lapuri.com,vers=3.0
    echo "Carpeta CompartidoAlumnado montada en $CARPETA_ALUMNADO"
else
    echo "La carpeta CompartidoAlumnado ya está montada."
fi

# Crear los directorios si no existen y asignar permisos
if [ ! -d "$CARPETA_PROFESORADO" ]; then
    sudo mkdir -p "$CARPETA_PROFESORADO"
    sudo chown root:$ALUMNO_GROUP "$CARPETA_PROFESORADO"
    sudo chmod 775 "$CARPETA_PROFESORADO"
fi

if [ ! -d "$CARPETA_ALUMNADO" ]; then
    sudo mkdir -p "$CARPETA_ALUMNADO"
    sudo chown root:$ALUMNO_GROUP "$CARPETA_ALUMNADO"
    sudo chmod 775 "$CARPETA_ALUMNADO"
fi

echo "Las carpetas se han montado correctamente en el PC del alumno."
