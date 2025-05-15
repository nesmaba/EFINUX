#!/bin/bash

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

# Función para crear un usuario y contraseña
crear_usuario() {
    local USUARIO="$1"
    local CONTRASENA="$2"

    if id "$USUARIO" &>/dev/null; then
        echo "⚠️  El usuario '$USUARIO' ya existe."
        return 1
    fi

    # Crear el usuario con su home y shell por defecto
    sudo useradd -m -s /bin/bash "$USUARIO"

    # Asignar la contraseña
    echo "$USUARIO:$CONTRASENA" | sudo chpasswd

    # (Opcional) Añadir al grupo sudo
    # sudo usermod -aG sudo "$USUARIO"

    echo "✅ Usuario '$USUARIO' creado correctamente."
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

preparar_instalacion_abconnector(){
    sudo apt install python3 python3-tk python3-serial python-is-python3
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
    # Instalar Wireshark
    sudo apt install -y wireshark
	
    preparar_instalacion_packettracer
    preparar_instalacion_abconnector

    # Instalar paquetes .deb
    instalar_deb "PacketTracer.deb"
    instalar_deb "VirtualBox.deb"
    instalar_deb "VSCode.deb"
    instalar_deb "abconnector_v5_4_linux64.deb"
    
}


instalar_programas(){
    
    echo "Empezamos a INSTALAR APLICACIONES..."
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

obtener_opcion() {
    while true; do
        echo "Seleccione el tipo de alumnado:"
        echo "1) Primaria/Secundaria/Bachillerato"
        echo "2) FP"
        read -p "Opción (1 o 2): " opcion

        if [ "$opcion" == "1" ] || [ "$opcion" == "2" ]; then
            break
        else
            echo "Opción no válida. Por favor, elija 1 o 2."
        fi
    done
}

# Función para solicitar la IP del servidor
obtener_ip_servidor() {
    while true; do
        read -p "Introduce la IP del servidor (PC del profesor): " ip_servidor
        if [[ $ip_servidor =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        else
            echo "IP no válida. Por favor, introduce una IP en formato correcto (ejemplo: 192.168.1.1)."
        fi
    done
}

sssd_profesorado(){
	# Crear el archivo sssd.conf
	sudo bash -c 'cat <<EOF > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
domains = lapurisimavalencia.com

[domain/lapurisimavalencia.com]
cache_credentials = true
ldap_tls_cert = /var/Google_2028_03_31_28472.crt
ldap_tls_key = /var/Google_2028_03_31_28472.key
ldap_uri = ldaps://ldap.google.com:636
ldap_search_base = dc=lapurisimavalencia,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
override_gid = 100 
ldap_group_search_base = OU=PROFESORADO   

EOF'

}

sssd_alumnado(){
	# Crear el archivo sssd.conf
	sudo bash -c 'cat <<EOF > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
domains = lapurisimavalencia.com, alu.lapurisimavalencia.com

[domain/lapurisimavalencia.com]
cache_credentials = true
ldap_tls_cert = /var/Google_2028_03_31_28472.crt
ldap_tls_key = /var/Google_2028_03_31_28472.key
ldap_uri = ldaps://ldap.google.com:636
ldap_search_base = dc=lapurisimavalencia,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
override_gid = 100 
ldap_group_search_base = OU=PROFESORADO   

[domain/alu.lapurisimavalencia.com]
cache_credentials = true
ldap_tls_cert = /var/Google_2028_03_31_28472.crt
ldap_tls_key = /var/Google_2028_03_31_28472.key
ldap_uri = ldaps://ldap.google.com:636
ldap_search_base = dc=alu.lapurisimavalencia,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
override_gid = 100
ldap_group_search_base = OU=ALUMNADO
EOF'

}

compartir_carpetas(){
	CARPETA="/mnt/compartido"

	sudo apt install -y samba smbclient cifs-utils

	# Crear punto de montaje y carpetas compartidas
	sudo mkdir -p "$CARPETA"

	sudo chmod 777 "$CARPETA"
	sudo chown nobody:nogroup "$CARPETA"

	sudo echo -e "[CompartidoAbierto]\n   path = /mnt/compartido\n   browseable = yes\n   read only = no\n   guest ok = yes\n   public = yes\n   create mask = 0777\n   directory mask = 0777\n   force user = nobody\n   force group = nogroup" | sudo tee -a /etc/samba/smb.conf > /dev/null

	sudo systemctl restart smbd.service

	# Mensaje final
	echo "Configuración completada SAMBA en el PC del PROFESOR. Las carpetas están accesibles en $CARPETA."

}

bloquear_fondo_pantalla(){

	# Ruta del fondo de pantalla
	FONDO="/usr/share/backgrounds/warty-final-ubuntu.png"

	echo "📌 Configurando el fondo de pantalla predeterminado..."
	gsettings set org.gnome.desktop.background picture-uri "file://$FONDO"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$FONDO"

	echo "📌 Creando script de restablecimiento de fondo..."
cat <<EOL | sudo tee /usr/local/bin/force-wallpaper.sh > /dev/null
#!/bin/bash

# Esperar 5 segundos para asegurarnos de que la sesión está iniciada
sleep 5

# Aplicar el fondo de pantalla
gsettings set org.gnome.desktop.background picture-uri "file://$FONDO"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$FONDO"
EOL

	# Hacer el script ejecutable
	sudo chmod +x /usr/local/bin/force-wallpaper.sh

	echo "📌 Creando entrada en autostart..."
	mkdir -p ~/.config/autostart
cat <<EOL > ~/.config/autostart/force-wallpaper.desktop
[Desktop Entry]
Type=Application
Exec=/usr/local/bin/force-wallpaper.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Force Wallpaper
Comment=Aplica el fondo de pantalla al iniciar sesión
EOL

	echo "📌 Aplicando configuración para todos los usuarios..."
	sudo mv ~/.config/autostart/force-wallpaper.desktop /etc/xdg/autostart/

}

inicio() {
	# Actualizamos todo antes 
	sudo apt update -y
	sudo apt upgrade -y

	# Instalar el paquete net-tools (para usar el arp para averiguar las ips de los clientes conectados a la lan)
	sudo apt install -y net-tools

	# Instalar paquete ssh para poder realizar conexiones remotas profesor > alumno
	sudo apt install -y ssh

	# Configuramos el sssd (conexión LDAP de Google)
	sudo apt install -y sssd sssd-tools

	# Copiamos los ficheros necesarios para el login con cuentas Google Workspace del cole

	sudo cp "Google_2028_03_31_28472.crt" "/var/"
	sudo chmod a+r /var/Google_2028_03_31_28472.crt

	sudo cp "Google_2028_03_31_28472.key" "/var/"
	sudo chmod a+r /var/Google_2028_03_31_28472.key

	# Crear el archivo sssd.conf
    if [ "$1" -eq 1 ]; then
		sssd_profesorado
	else
		sssd_alumnado
	fi

	# Cambiar los permisos del archivo sssd.conf
	sudo chmod 600 /etc/sssd/sssd.conf
	
	# Reiniciar el servicio sssd para aplicar los cambios. Con el reboot del final sobra, sino se corta el script 
	# sudo systemctl restart sssd

	echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0022" | sudo tee -a /etc/pam.d/common-auth

	# FIN sssd 

	# Instalar dependencias para ejecutar appimages
	sudo apt-get install -y fuse libfuse2

	# Crear usuario "arduino" con contraseña "domotica123" MEJOR LO AÑADO AL GRUPO dialout
	# sudo useradd -m arduino -p $(openssl passwd -1 domotica123)

	# Configurar Ubuntu para usar X11 en lugar de Wayland UBUNTU 24 PIDE WAYLAND. UBUNTU 22 X11
	# echo -e "[daemon]\nWaylandEnable=false" | sudo tee -a /etc/gdm3/custom.conf

	# Con el reboot del final sobra, sino se corta el script 
	# sudo systemctl restart gdm

	echo "Ahora tendrás que seleccionar lightdm"
	read
	echo "Continuamos configurando el equipo"

	# Habilitar sesión de invitado con lightdm
	sudo apt-get install -y lightdm
	echo -e "[Seat:*]\nallow-guest=true\n[SeatDefaults]\ngreeter-show-manual-login=true" | sudo tee /etc/lightdm/lightdm.conf.d/40-enable-guest.conf > /dev/null


	# Instalar lightdm-gtk-greeter y configurarlo
	sudo apt install -y lightdm-gtk-greeter
	echo -e "[Seat:*]\ngreeter-session=lightdm-gtk-greeter" | sudo tee -a /etc/lightdm/lightdm.conf.d/greeter.conf
	echo -e "[greeter]\nbackground = /usr/share/backgrounds/loginEfi.png\ntheme-name = Adwaita-dark\nicon-theme-name = Adwaita\nindicators = ~host;~spacer;~session;~language;~a11y;~clock;~power\nuser-background = false" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf

	# Cambiar fondo de la pantalla de login
	sudo cp loginEfi.png /usr/share/backgrounds/
	sudo chmod a+r /usr/share/backgrounds/loginEfi.png

	# Cambiar fondo de pantalla de todas las sesiones
	sudo cp warty-final-ubuntu.png /usr/share/backgrounds/
	sudo chmod a+r /usr/share/backgrounds/warty-final-ubuntu.png
	bloquear_fondo_pantalla

	# Ruta del fichero pam-configs/my_groups
	pam_configs_file="/usr/share/pam-configs/my_groups"

	# Contenido a añadir al fichero pam-configs/my_groups
	pam_configs_content="Name: activate /etc/security/group.conf
Default: yes

Priority: 900
Auth-Type: Primary
Auth: required pam_group.so"

	# Ruta del fichero common-auth
	common_auth_file="/etc/pam.d/common-auth"

	# Contenido a añadir al fichero common-auth
	common_auth_content="auth    required     pam_group.so"

	# Añadir contenido al fichero pam-configs/my_groups
	echo "$pam_configs_content" | sudo tee "$pam_configs_file" > /dev/null

	# Añadir contenido al fichero common-auth antes de la configuración de pam_ldap y pam_krb5
	sudo sed -i -e "/^auth.*pam_ldap.so/ i $common_auth_content" "$common_auth_file"

	echo "Ahora selecciona todas las opciones"
	read
	sudo pam-auth-update

	# Solucionar problemas
	sudo apt install -y gnome-control-center
	sudo apt-get install -y --reinstall ubuntu-desktop

	# Desinstalar juegos y otras apps preinstaladas
	sudo apt purge -y thunderbird* rhythmbox aisleriot gnome-mahjongg gnome-mines gnome-sudoku remmina transmission-gtk
	sudo apt autoremove -y

	# Eliminar Firefox
	sudo apt remove -y firefox
	sudo rm -Rf /usr/bin/firefox
	sudo rm -Rf /usr/loca/firefox
	# Realmente firefox en Ubuntu está instalado a través de snap
	sudo snap remove firefox
	sudo snap remove thunderbird
	
	# Instalar VirtualBox y Arduino IDE
	# ... (coloca aquí el código para instalar VirtualBox y Arduino IDE)

	# Instala fusioninventory para inventariar el equipo OBSOLETO
	# sudo apt install fusioninventory-agent -y
	# Añadir la línea al archivo de configuración
	# sudo sed -i '/^server =/d' /etc/fusioninventory/agent.cfg # Elimina la línea existente si existe
	# echo "server = http://10.10.100.23:8080/plugins/fusioninventory/" | sudo tee -a /etc/fusioninventory/agent.cfg
	# Reiniciar el servicio para que los cambios surtan efecto
	# sudo systemctl restart fusioninventory-agent

	# En lugar de fusioninventory instalamos GLPI agent. La versión 1.10 pero hay que cambiar el nombre del archivo a glpi-agent.pl
	sudo perl glpi-agent.pl --server=10.10.100.23:8080

	# Instala Google Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	sudo apt-get install -y -f

	# Configurar Google Chrome
	# ... (coloca aquí el código para instalar y configurar Chrome)
	# sudo apt install -y virtualbox
	# sudo apt install -y arduino
	# sudo apt install -y openjdk-17-jdk
	sudo apt install -y kwrite

	# Configurar Chrome para evitar problemas de sesión
	sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop
	sudo sed -i 's|Exec=/usr/bin/google-chrome-stable --incognito|Exec=/usr/bin/google-chrome-stable --incognito --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop

	# Nombre del archivo que se va a crear para eliminar los archivos de bloqueo de Google Chrome
	SCRIPT_PATH="/etc/profile.d/chrome_fix.sh"

	# Contenido del script que eliminará los archivos bloqueantes de Chrome
	SCRIPT_CONTENT='#!/bin/bash
# Elimina archivos bloqueantes de Google Chrome al iniciar sesión
rm -f "$HOME/.config/google-chrome/SingletonLock" \
      "$HOME/.config/google-chrome/SingletonCookie" \
      "$HOME/.config/google-chrome/SingletonSocket"
'

	# Crear el archivo con el contenido especificado (requiere sudo)
	echo "$SCRIPT_CONTENT" | sudo tee "$SCRIPT_PATH" > /dev/null

	# Asignar permisos de ejecución (requiere sudo)
	sudo chmod +x "$SCRIPT_PATH"
	echo "Script creado correctamente para evitar bloqueos de Google Chrome."

	# Cambiamos el fondo de pantalla al iniciar y apagar el PC
	# Instalamos el tema spinner necesario para cambiar el fondo al iniciar/reset/apagar el PC
	sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/spinner/spinner.plymouth 100

	# Seleccionamos la opción que sea el tema spinner
	echo "Selecciona el tema SPINNER"
	read
	sudo update-alternatives --config default.plymouth
	sudo echo 'GRUB_GFXPAYLOAD_LINUX=keep' | sudo tee -a /etc/default/grub > /dev/null
	sudo update-grub
	
	echo "Continuamos configurando el equipo"

	# Cambiamos el fondo de pantalla al hacer reset/reboot/shutdown
	sudo cp efinux.png /usr/share/plymouth/themes/spinner/background-tile.png
	sudo chmod a+r /usr/share/plymouth/themes/spinner/background-tile.png

	# Eliminamos el logo del fabricante del PC al iniciar o apagar el PC.
	# Archivo de configuración donde aparece si mostramos el logo del fabricante del PC
	config_file="/usr/share/plymouth/themes/bgrt/bgrt.plymouth"

	# Verificar si el archivo de configuración existe
	if [ -e "$config_file" ]; then
		# Realizar el cambio en el archivo
		sudo sed -i 's/UseFirmwareBackground=true/UseFirmwareBackground=false/g' "$config_file"

		echo "Se han cambiado todas las instancias de UseFirmwareBackground=true a UseFirmwareBackground=false en $config_file."
	else
		echo "El archivo de configuración $config_file no existe."
	fi

	# Eliminamos el logo pequeño de Ubuntu situado en la parte baja
	sudo mv /usr/share/plymouth/themes/spinner/watermark.png /usr/share/plymouth/themes/spinner/watermark.png.bak
	sudo cp efinux.png /usr/share/plymouth/themes/spinner/watermark.png
	sudo chmod a+r /usr/share/plymouth/themes/spinner/watermark.png

	# Me cargo la imagen de Ubuntu al iniciar y apagar sino aparece un segundo y luego la de EFINUX.
	sudo mv /usr/share/plymouth/ubuntu-logo.png /usr/share/plymouth/ubuntu-logo.png.bak
	sudo cp efinux.png /usr/share/plymouth/ubuntu-logo.png
	sudo chmod a+r /usr/share/plymouth/ubuntu-logo.png
	# Actualizo todos los cambios referentes al cambio de imagen reiniciar, apagar, encender...
	sudo update-initramfs -u

	# Generar machine-id único
	sudo rm /etc/machine-id /var/lib/dbus/machine-id
	sudo systemd-machine-id-setup

	# Limpio todo
	sudo apt autoclean -y 
	sudo apt autoremove -y 
	sudo apt purge -y

}

fin(){
	# Si ejecuto la siguiente instrucción se sale de todo, entonces prefiero hacerlo con el reboot.
	# sudo systemctl restart lightdm
	echo "Tareas automatizadas completadas con éxito!"
	echo "Reiniciando el sistema en 5 segundos..."
	sleep 5

	# Reiniciamos
	sudo reboot
}

# INICIO DEL SCRIPT

# Comprobar conexión a Internet
if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
    echo "Conexión a Internet detectada."
else
    echo "Sin conexión a Internet. Saliendo del script."
    exit 1
fi

echo "Seleccione el tipo de instalación:"
echo "1) Profesorado"
echo "2) Alumnado"
read -p "Ingrese una opción (1 o 2): " opcionProfeAlum

# Configuración específica según la opción elegida
if [ "$opcionProfeAlum" == "1" ]; then
	inicio 1
	# PROFESORADO
	sudo groupadd profesorado
	sudo groupadd vboxusers
	sudo groupadd epoptes
	sudo groupadd wireshark

	# Agregar usuarios a grupos
	sudo usermod -aG vboxusers,dialout,epoptes,wireshark,profesorado $USER

	# Configurar pam para agregar usuarios a grupos al inicio
	echo "*;*;*;Al0000-2400;users,dialout,vboxusers,epoptes,wireshark,profesorado" | sudo tee -a /etc/security/group.conf

	# NO ME FUNCIONA LO SIGUIENTE Agregar las nuevas reglas para asignación de grupos basada en dominios
	echo "# Archivo de configuración para asignación de grupos basada en dominios" | sudo tee -a /etc/security/group.conf
	echo "# Reglas para asignar el grupo 'profesorado' a los usuarios del dominio lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "+ : profesorado : @lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "# Reglas para asignar el grupo 'alumnado' a los usuarios del dominio alu.lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "+ : alumnado : @alu.lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf

	echo "Reglas añadidas correctamente al archivo /etc/security/group.conf"

	# Instalar nmap para poder realizar el cssh a todos los clientes 
	sudo apt install -y nmap

	# Instalar el paquete clusterssh (cssh para conectarse a los diferentes clientes y poder lanzar un comando a la vez en varios clientes). 
	sudo apt install -y clusterssh

	sudo apt-get install -y epoptes
	sudo apt install python3-pip

	# Creo una carpeta compartida para colgar ISOs etc etc
	compartir_carpetas

	# Copiar el archivo conectarmeClientesAula.sh al Escritorio del usuario
	# Obtener el nombre del usuario que ejecuta el script
	usuario=$(whoami)

	# Directorio del archivo fuente
	archivo_fuente="conectarmeClientesAula.sh"

	# Determinar el directorio del Escritorio (Desktop o Escritorio)
	if [ -d "/home/$usuario/Desktop" ]; then
	    directorio_escritorio="/home/$usuario/Desktop"
	elif [ -d "/home/$usuario/Escritorio" ]; then
	    directorio_escritorio="/home/$usuario/Escritorio"
	else
	    echo "No se encontró un directorio de Escritorio."
	    exit 1
	fi

	# Verificar si el archivo fuente existe
	if [ -f "$archivo_fuente" ]; then
	    # Crear el directorio del Escritorio si no existe
	    mkdir -p "$directorio_escritorio"

	    # Copiar el archivo al Escritorio
	    cp "$archivo_fuente" "$directorio_escritorio/"
	    
	    echo "Archivo $archivo_fuente copiado a $directorio_escritorio."
	else
	    echo "El archivo $archivo_fuente no se encontró en el directorio actual."
	fi

	# Damos permisos de ejecución solo a root y propietario. grupo y otros solo tienen permisos de lectura.
	sudo chmod 744 "$directorio_escritorio/$archivo_fuente"

	# Configuro la IP estática para el profesorado

	# Solicitar la IP estática al usuario

	read -p "Introduce la IP estática (por ejemplo, 192.168.1.100): " ip_estatica

	# Calcular la dirección del gateway (el último byte de la IP será .10)
	gateway=$(echo $ip_estatica | sed 's/\.[0-9]\+$/\.10/')

	# Obtener el nombre de la interfaz de red (excluyendo la interfaz loopback lo)
	interface=$(ip -o -4 addr show up primary scope global | awk '{print $2}' | head -n 1)

	if [ -z "$interface" ]; then
	    echo "No se pudo detectar una interfaz de red activa."
	    exit 1
	fi

	# Crear el archivo de configuración de netplan
	sudo tee "/etc/netplan/01-netcfg-efi.yaml" > /dev/null <<EOF
network:
   version: 2
   ethernets:
    $interface:
      dhcp4: no
      addresses:
        - $ip_estatica/24
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

	# Aplicar la configuración de netplan
	sudo netplan apply

	# VERSION BORRANDO EL FICHERO YAML Y CREANDO UNO NUEVO
	# Buscar el archivo de configuración de Netplan
	# netplan_file=$(sudo ls /etc/netplan/*.yaml 2>/dev/null | head -n 1)

	# if [ -z "$netplan_file" ]; then
	#     echo "No se encontró ningún archivo de configuración de Netplan. Creando uno nuevo..."
	#     netplan_file="/etc/netplan/01-netcfg.yaml"
	# else
	    # Hacer una copia de seguridad del archivo original
	#     sudo cp "$netplan_file" "${netplan_file}.bak"
	# fi

	# Crear o modificar el archivo de configuración de netplan
	# sudo tee "$netplan_file" > /dev/null <<EOF
	# Y AQUI PONDRIA YA EL CONTENIDO DEL FICHERO CONFIGURACION YAML
	
	instalar_programas

	fin

elif [ "$opcionProfeAlum" == "2" ]; then
	inicio 2
	#ALUMNADO
	sudo groupadd alumnado
	sudo groupadd vboxusers
	sudo groupadd epoptes
	sudo groupadd wireshark

	# Agregar usuarios a grupos
	sudo usermod -aG vboxusers,dialout,epoptes,wireshark,alumnado $USER

	# Configurar pam para agregar usuarios a grupos al inicio
	echo "*;*;*;Al0000-2400;users,dialout,vboxusers,epoptes,wireshark,alumnado" | sudo tee -a /etc/security/group.conf

	# NO ME FUNCIONA LO SIGUIENTE Agregar las nuevas reglas para asignación de grupos basada en dominios
	echo "# Archivo de configuración para asignación de grupos basada en dominios" | sudo tee -a /etc/security/group.conf
	echo "# Reglas para asignar el grupo 'profesorado' a los usuarios del dominio lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "+ : profesorado : @lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "# Reglas para asignar el grupo 'alumnado' a los usuarios del dominio alu.lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf
	echo "+ : alumnado : @alu.lapurisimavalencia.com" | sudo tee -a /etc/security/group.conf

	echo "Reglas añadidas correctamente al archivo /etc/security/group.conf"

	# Instalar epoptes-client y configurarlo
	sudo apt-get install -y --install-recommends epoptes-client

	# Añado la IP del server/PC del profesor. 
	########## MODIFICAR CAMBIA LA IP A LA QUE CORRESPONDA ##########
	# echo "10.2.122.21  server" | sudo tee -a /etc/hosts > /dev/null
	# Llamar a la función para obtener la IP del servidor
	obtener_ip_servidor

	# Añadir la IP del servidor al archivo /etc/hosts
	echo "$ip_servidor  server" | sudo tee -a /etc/hosts > /dev/null
	
	# Configuramos epoptes-client con el server
	sudo epoptes-client -c

	# Registramos los navegadores para que estén administrados
	sudo mkdir /etc/opt/chrome
	sudo mkdir /etc/opt/chrome/policies
	sudo mkdir /etc/opt/chrome/policies/enrollment
	# Las rutas anteriores parece que son las antiguas pero las creamos por si acaso.
	sudo mkdir /opt/google/chrome/policies
	sudo mkdir /opt/google/chrome/policies/enrollment


	# Llamar a la función obtener_opcion, está al inicio del script, para obtener la opción del usuario
	obtener_opcion

	# Realizar las acciones basadas en la opción seleccionada
	if [ "$opcion" == "1" ]; then
	    # Alumnado Primaria, ESO y Bachillerato
	    sudo cp PRIM_ESO_BCHCloudManagementEnrollmentToken /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken
	    sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken

	    sudo cp PRIM_ESO_BCHCloudManagementEnrollmentToken /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken
	    sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken

		instala_programas_eso
		crear_usuario innovamat vamat2023
	    echo "Configuración para Primaria/ESO/Bachillerato aplicada con éxito."
		
	elif [ "$opcion" == "2" ]; then
	    # Alumnado FP
	    sudo cp FP_CloudManagementEnrollmentToken /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken
	    sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken

	    sudo cp FP_CloudManagementEnrollmentToken /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken
	    sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken

		instala_programas_fp
	    echo "Configuración para FP aplicada con éxito."
		
	fi


	# Siguiente fichero se crea para que obligue a registrar el navegador
	sudo cp CloudManagementEnrollmentOptions /etc/opt/chrome/policies/enrollment/
	sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentOptions

	sudo cp CloudManagementEnrollmentOptions /opt/google/chrome/policies/enrollment/
	sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentOptions
	
	fin
	
else
    echo "Opción no válida. Saliendo..."
    exit 1
fi
