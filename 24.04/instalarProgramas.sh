#!/bin/bash
set -eu
################# INSTALACIÓN DE PROGRAMAS #####################

# Definir la ruta donde están los programas
RUTA_SCRIPT=$(dirname "$(realpath "$0")")
RUTA_SCRIPT_APPS="$(dirname "$(realpath "$0")")/Aplicaciones"
RUTA_APPS="/opt/Aplicaciones"  # Hacer accesibles los AppImage para todos los usuarios
RUTA_ICONOS="$RUTA_APPS"
RUTA_DESKTOP="/usr/share/applications"

# Crear la carpeta Aplicaciones en /opt si no existe
sudo mkdir -p "$RUTA_APPS"
sudo chmod 777 "$RUTA_APPS"  # Dar permisos para que cualquier usuario pueda usarla

# Función para instalar un AppImage
instalar_appimage() {
    local archivo="$1"
    local destino="$RUTA_APPS/$(basename "$archivo")"

    if [ -f "$RUTA_SCRIPT_APPS/$archivo" ]; then
        echo "Instalando $archivo..."
        sudo cp "$RUTA_SCRIPT_APPS/$archivo" "$destino"
        sudo chmod +x "$destino"
        echo "$archivo instalado en $RUTA_APPS"
    else
        echo "ERROR: No se encontró $archivo en $RUTA_SCRIPT_APPS"
    fi
}

# Función para instalar un paquete .deb
instalar_deb() {
    local archivo="$1"

    if [ -f "$RUTA_SCRIPT_APPS/$archivo" ]; then
        echo "Instalando $archivo..."
        sudo dpkg -i "$RUTA_SCRIPT_APPS/$archivo"
        sudo apt-get install -f -y  # Resolver dependencias
        sudo apt install --fix-broken -y # Resolver dependencias
        echo "$archivo instalado correctamente"
    else
        echo "ERROR: No se encontró $archivo en $RUTA_SCRIPT_APPS"
    fi
}

# Función para crear acceso directo en el lanzador de Ubuntu
crear_acceso_directo() {
    local nombre="$1"
    local ejecutable="$RUTA_APPS/$2"
    local icono="$RUTA_ICONOS/$3"
    local desktop_file="$RUTA_DESKTOP/$1.desktop"

    echo "Creando acceso directo para $nombre..."

    sudo bash -c "cat > $desktop_file" <<EOF
[Desktop Entry]
Name=$nombre
Exec=$ejecutable
Icon=$icono
Terminal=false
Type=Application
Categories=Development;
EOF

    sudo chmod 644 "$desktop_file"
    echo "Acceso directo para $nombre creado en $RUTA_DESKTOP"
}

preparar_instalacion_packettracer(){
    # Preparo instalacion para Packet Tracer
    instalar_deb libgl1-mesa-glx_23.0.4-0ubuntu1~22.04.1_amd64.deb
    instalar_deb dialog_1.3-20240101-1_amd64.deb
    instalar_deb libxcb-xinerama0-dev_1.15-1ubuntu2_amd64.deb
}

instala_programas_eso(){
    # Instalar AppImages
    instalar_appimage "Arduino.AppImage"
    instalar_appimage "GDevelop.AppImage"
    instalar_appimage "UltiMakerCura.AppImage"
    instalar_appimage "MuseScore.AppImage"

    # Copiar iconos a la ruta de aplicaciones
    echo "Copiando iconos..."
    sudo cp "$RUTA_SCRIPT_APPS/arduino.png" "$RUTA_ICONOS/"
    sudo cp "$RUTA_SCRIPT_APPS/cura.png" "$RUTA_ICONOS/"
    sudo cp "$RUTA_SCRIPT_APPS/gdevelop.png" "$RUTA_ICONOS/"
    sudo cp "$RUTA_SCRIPT_APPS/musescore.png" "$RUTA_ICONOS/"

    # Crear accesos directos
    crear_acceso_directo "ArduinoIDE" "Arduino.AppImage --no-sandbox" "arduino.png"
    crear_acceso_directo "GDevelop" "GDevelop.AppImage --no-sandbox" "gdevelop.png"
    crear_acceso_directo "UltiMakerCura" "UltiMakerCura.AppImage" "cura.png"
    crear_acceso_directo "MuseScore" "MuseScore.AppImage" "musescore.png"

    instala_programas_fp
}


instala_programas_fp(){
    preparar_instalacion_packettracer

    # Instalar paquetes .deb
    instalar_deb "PacketTracer.deb"
    instalar_deb "VirtualBox.deb"
    instalar_deb "VSCode.deb"

}


instalar_programas(){
    
    echo "Empezamos a INSTALAR APLICACIONES..."
    # Instalar Wireshark
    sudo apt install -y wireshark

    echo "Seleccione el tipo de instalación:"
    echo "1) ESO-BCH"
    echo "2) FP"
    read -p "Ingrese una opción (1 o 2): " opcionESO_FP


    # Configuración específica según la opción elegida
    if [[ "$opcionESO_FP" == "1" ]]; then
        instala_programas_eso
    else
        instala_programas_fp
    fi


    sudo apt autoclean
    sudo apt autoremove -y

    echo "Todas las aplicaciones y accesos directos han sido instalados correctamente."
  

}

instalar_programas

