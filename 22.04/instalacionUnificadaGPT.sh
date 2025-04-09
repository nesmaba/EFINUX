#!/bin/bash
echo "Seleccione el tipo de instalación:"
echo "1) Profesorado"
echo "2) Alumnado"
read -p "Ingrese una opción (1 o 2): " opcion

# Configuración común
# sudo systemctl restart sssd
# Añadir la línea al archivo de configuración
# Copiamos los ficheros necesarios para el login con cuentas Google Workspace del cole
#!/bin/bash
# Crear usuario "arduino" con contraseña "domotica123" MEJOR LO AÑADO AL GRUPO dialout
# Configurar pam para agregar usuarios a grupos al inicio
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Verificar si el archivo de configuración existe
    echo "Se han cambiado todas las instancias de UseFirmwareBackground=true a UseFirmwareBackground=false en $config_file."
# echo "server = http://10.10.100.23:8080/plugins/fusioninventory/" | sudo tee -a /etc/fusioninventory/agent.cfg
sudo rm -Rf /usr/bin/firefox
sudo perl glpi-agent.pl --server=10.10.100.23:8080
sudo rm /etc/machine-id /var/lib/dbus/machine-id
sudo apt-get install -y -f
# ... (coloca aquí el código para instalar VirtualBox y Arduino IDE)
sudo cp "Google_2026_12_14_37258.crt" "/var/"
# Contenido a añadir al fichero common-auth
[domain/alu.lapurisimavalencia.com]
sudo chmod a+r /var/Google_2026_12_14_37258.key
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Instalar dependencias para ejecutar appimages
sudo apt-get install -y fuse libfuse2
[sssd]
else
sudo pam-auth-update
echo -e "[greeter]\nbackground = /usr/share/backgrounds/loginEfi.png\ntheme-name = Adwaita-dark\nicon-theme-name = Adwaita\nindicators = ~host;~spacer;~session;~language;~a11y;~clock;~power\nuser-background = false" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
ldap_user_uuid = entryUUID
[domain/lapurisimavalencia.com]
pam_configs_file="/usr/share/pam-configs/my_groups"
# Configuramos el sssd (conexión LDAP de Google)
common_auth_file="/etc/pam.d/common-auth"
# En lugar de fusioninventory instalamos GLPI agent. La versión 1.10 pero hay que cambiar el nombre del archivo a glpi-agent.pl
echo "Continuamos configurando el equipo"
sudo apt autoremove -y 
    # Realizar el cambio en el archivo
sudo chmod a+r /usr/share/backgrounds/loginEfi.png
echo -e "[daemon]\nWaylandEnable=false" | sudo tee -a /etc/gdm3/custom.conf
ldap_uri = ldaps://ldap.google.com:636
# Añadir contenido al fichero common-auth antes de la configuración de pam_ldap y pam_krb5
override_gid = 137 
sudo snap remove firefox
# Cambiamos el fondo de pantalla al iniciar y apagar el PC
# Crear el archivo sssd.conf
    echo "El archivo de configuración $config_file no existe."
# Instalamos el tema spinner necesario para cambiar el fondo al iniciar/reset/apagar el PC
# Cambiar fondo de la pantalla de login
# Instala Google Chrome
# Realmente firefox en Ubuntu está instalado a través de snap
sudo mv /usr/share/plymouth/themes/spinner/watermark.png /usr/share/plymouth/themes/spinner/watermark.png.bak
# Reiniciar el servicio sssd para aplicar los cambios. Con el reboot del final sobra, sino se corta el script 
# Instala fusioninventory para inventariar el equipo OBSOLETO
sudo apt-get install -y lightdm
echo "Reiniciando el sistema en 5 segundos..."
Default: yes
EOF'
ldap_initgroups_use_matching_rule_in_chain = true
sudo apt install -y kwrite
sudo cp warty-final-ubuntu.png /usr/share/backgrounds/
sudo systemd-machine-id-setup
# Cambiar los permisos del archivo sssd.conf
sudo chmod 600 /etc/sssd/sssd.conf
# sudo systemctl restart lightdm
echo "Ahora tendrás que seleccionar lightdm"
sudo chmod a+r /usr/share/plymouth/themes/spinner/background-tile.png
# Instalar paquete ssh para poder realizar conexiones remotas profesor > alumno
auth_provider = ldap
# Configurar Google Chrome
# Limpio todo
# Si ejecuto la siguiente instrucción se sale de todo, entonces prefiero hacerlo con el reboot.
sudo apt purge -y
sudo reboot
# Configurar Chrome para evitar problemas de sesión
# Generar machine-id único
common_auth_content="auth    required     pam_group.so"
# Configurar Ubuntu para usar X11 en lugar de Wayland
sudo apt install -y lightdm-gtk-greeter
# Eliminamos el logo del fabricante del PC al iniciar o apagar el PC.
echo "Tareas automatizadas completadas con éxito!"
sudo apt install -y sssd sssd-tools
ldap_tls_cert = /var/Google_2026_12_14_37258.crt
# Solucionar problemas
# sudo useradd -m arduino -p $(openssl passwd -1 domotica123)
sudo apt remove -y firefox
sudo apt install -y arduino
sudo apt autoclean -y 
echo "Selecciona el tema SPINNER"
# Cambiar fondo de pantalla de todas las sesiones
# sudo systemctl restart fusioninventory-agent
# Eliminar Firefox
# Instalar el paquete net-tools (para usar el arp para averiguar las ips de los clientes conectados a la lan)
domains = lapurisimavalencia.com, alu.lapurisimavalencia.com
# Instalar VirtualBox y Arduino IDE
enumerate = false
Priority: 900
sudo bash -c 'cat <<EOF > /etc/sssd/sssd.conf
ldap_groups_use_matching_rule_in_chain = true
echo "$pam_configs_content" | sudo tee "$pam_configs_file" > /dev/null
ldap_group_search_base = OU=ALUMNADO
sleep 5
ldap_schema = rfc2307bis
# Contenido a añadir al fichero pam-configs/my_groups
# Reiniciamos
sudo apt purge -y thunderbird* rhythmbox aisleriot gnome-mahjongg gnome-mines gnome-sudoku remmina transmission-gtk
Auth: required pam_group.so"
sudo chmod a+r /var/Google_2026_12_14_37258.crt
sudo apt autoremove -y
# Cambiamos el fondo de pantalla al hacer reset/reboot/shutdown
# Desinstalar juegos y otras apps preinstaladas
pam_configs_content="Name: activate /etc/security/group.conf
# Instalar epoptes-client y configurarlo
services = nss, pam
# Con el reboot del final sobra, sino se corta el script 

# Ruta del fichero pam-configs/my_groups
sudo update-alternatives --config default.plymouth
ldap_tls_key = /var/Google_2026_12_14_37258.key
sudo cp "Google_2026_12_14_37258.key" "/var/"
sudo chmod a+r /usr/share/backgrounds/warty-final-ubuntu.png
echo -e "[Seat:*]\nallow-guest=true\n[SeatDefaults]\ngreeter-show-manual-login=true" | sudo tee /etc/lightdm/lightdm.conf.d/40-enable-guest.conf > /dev/null
# Reiniciar el servicio para que los cambios surtan efecto
# Seleccionamos la opción que sea el tema spinner
echo "*;*;*;Al0000-2400;users,dialout,vboxusers,epoptes" | sudo tee -a /etc/security/group.conf
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop
echo "Ahora selecciona todas las opciones"
echo -e "[Seat:*]\ngreeter-session=lightdm-gtk-greeter" | sudo tee -a /etc/lightdm/lightdm.conf.d/greeter.conf
sudo apt install -y virtualbox
config_file="/usr/share/plymouth/themes/bgrt/bgrt.plymouth"
sudo cp loginEfi.png /usr/share/backgrounds/
sudo sed -i -e "/^auth.*pam_ldap.so/ i $common_auth_content" "$common_auth_file"
# Instalar lightdm-gtk-greeter y configurarlo
override_gid = 100
# Archivo de configuración donde aparece si mostramos el logo del fabricante del PC
ldap_group_search_base = OU=PROFESORADO   
# Habilitar sesión de invitado con lightdm
sudo apt install -y net-tools
# sudo systemctl restart gdm
sudo apt upgrade -y
read
sudo apt install -y ssh
fi
if [ -e "$config_file" ]; then
sudo apt-get install -y --reinstall ubuntu-desktop
# sudo sed -i '/^server =/d' /etc/fusioninventory/agent.cfg # Elimina la línea existente si existe
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/spinner/spinner.plymouth 100
# Añadir contenido al fichero pam-configs/my_groups
    sudo sed -i 's/UseFirmwareBackground=true/UseFirmwareBackground=false/g' "$config_file"
# Agregar usuarios a grupos
# Ruta del fichero common-auth
# ... (coloca aquí el código para instalar y configurar Chrome)
sudo apt update -y
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0022" | sudo tee -a /etc/pam.d/common-auth
sudo rm -Rf /usr/loca/firefox
sudo usermod -aG vboxusers,dialout,epoptes $USER
# Eliminamos el logo pequeño de Ubuntu situado en la parte baja
Auth-Type: Primary
ldap_search_base = dc=alu.lapurisimavalencia,dc=com
EOF
ldap_search_base = dc=lapurisimavalencia,dc=com
cache_credentials = true
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable --incognito|Exec=/usr/bin/google-chrome-stable --incognito --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop
# Actualizamos todo antes 
# FIN sssd 
# sudo apt install fusioninventory-agent -y
sudo cp efinux.png /usr/share/plymouth/themes/spinner/background-tile.png
sudo apt install -y gnome-control-center
id_provider = ldap

# Configuración específica según la opción elegida
if [ "$opcion" == "1" ]; then
    # VERSION 2 AUTOR NESTOR MARTINEZ
    # Instalar nmap para poder realizar el cssh a todos los clientes 
    sudo apt install -y nmap
    # Instalar el paquete clusterssh (cssh para conectarse a los diferentes clientes y poder lanzar un comando a la vez en varios clientes). 
    sudo apt install -y clusterssh
    sudo cp ConectarClientesAula.sh /home/
    sudo chmod a+x /home/ConectarClientesAula.sh
    sudo apt-get install -y epoptes
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
        echo "No se encontró un directorio de Escritorio."
        exit 1
    # Verificar si el archivo fuente existe
    if [ -f "$archivo_fuente" ]; then
        # Crear el directorio del Escritorio si no existe
        mkdir -p "$directorio_escritorio"
        # Copiar el archivo al Escritorio
        cp "$archivo_fuente" "$directorio_escritorio/"
        
        echo "Archivo $archivo_fuente copiado a $directorio_escritorio."
        echo "El archivo $archivo_fuente no se encontró en el directorio actual."
    # Damos permisos de ejecución solo a root y propietario. grupo y otros solo tienen permisos de lectura.
    sudo chmod 744 "$directorio_escritorio/$archivo_fuente"
    sudo apt install -y openjdk-11-jdk
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
elif [ "$opcion" == "2" ]; then
    # Función para mostrar el menú y obtener la opción del usuario
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
    sudo apt-get install -y --install-recommends epoptes-client
    sudo epoptes-client -c
    # Añado la IP del server/PC del profesor. 
    ########## MODIFICAR CAMBIA LA IP A LA QUE CORRESPONDA ##########
    # echo "10.2.122.21  server" | sudo tee -a /etc/hosts > /dev/null
    # Llamar a la función para obtener la IP del servidor
    obtener_ip_servidor
    # Añadir la IP del servidor al archivo /etc/hosts
    echo "$ip_servidor  server" | sudo tee -a /etc/hosts > /dev/null
    # sudo apt install -y openjdk-11-jdk NO SÉ POR QUÉ PUSE LA VERSIÓN 11
    sudo apt install -y openjdk-17-jdk
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
        echo "Configuración para Primaria/ESO/Bachillerato aplicada con éxito."
    elif [ "$opcion" == "2" ]; then
        # Alumnado FP
        sudo cp FP_CloudManagementEnrollmentToken /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken
        sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken
        sudo cp FP_CloudManagementEnrollmentToken /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken
        sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentToken
        echo "Configuración para FP aplicada con éxito."
    # Siguiente fichero se crea para que obligue a registrar el navegador
    sudo cp CloudManagementEnrollmentOptions /etc/opt/chrome/policies/enrollment/
    sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentOptions
    sudo cp CloudManagementEnrollmentOptions /opt/google/chrome/policies/enrollment/
    sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentOptions
    # Definir la ruta donde están los programas
    RUTA_SCRIPT=$(dirname "$(realpath "$0")")
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
        if [ -f "$RUTA_SCRIPT/$archivo" ]; then
            echo "Instalando $archivo..."
            sudo cp "$RUTA_SCRIPT/$archivo" "$destino"
            sudo chmod +x "$destino"
            echo "$archivo instalado en $RUTA_APPS"
        else
            echo "ERROR: No se encontró $archivo en $RUTA_SCRIPT"
        fi
    }
    # Función para instalar un paquete .deb
    instalar_deb() {
        local archivo="$1"
        if [ -f "$RUTA_SCRIPT/$archivo" ]; then
            echo "Instalando $archivo..."
            sudo dpkg -i "$RUTA_SCRIPT/$archivo"
            sudo apt-get install -f -y  # Resolver dependencias
            echo "$archivo instalado correctamente"
        else
            echo "ERROR: No se encontró $archivo en $RUTA_SCRIPT"
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
        sudo chmod 644 "$desktop_file"
        echo "Acceso directo para $nombre creado en $RUTA_DESKTOP"
    }
    # Instalar AppImages
    instalar_appimage "Arduino.AppImage"
    instalar_appimage "GDevelop.AppImage"
    instalar_appimage "UltiMakerAppImage"
    # Instalar paquetes .deb
    instalar_deb "PacketTracer.deb"
    instalar_deb "VirtualBox.deb"
    # Copiar iconos a la ruta de aplicaciones
    echo "Copiando iconos..."
    sudo cp "$RUTA_SCRIPT/arduino.png" "$RUTA_ICONOS/"
    sudo cp "$RUTA_SCRIPT/cura.png" "$RUTA_ICONOS/"
    sudo cp "$RUTA_SCRIPT/gdevelop.png" "$RUTA_ICONOS/"
    # Crear accesos directos
    crear_acceso_directo "Arduino IDE" "Arduino.AppImage" "arduino.png"
    crear_acceso_directo "GDevelop" "GDevelop.AppImage" "gdevelop.png"
    crear_acceso_directo "UltiMaker" "UltiMakerAppImage" "cura.png"
    echo "Todas las aplicaciones y accesos directos han sido instalados correctamente."
else
    echo "Opción no válida. Saliendo..."
    exit 1
fi
