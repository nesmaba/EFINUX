#!/bin/bash

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

# Actualizamos todo antes 
sudo apt update -y
sudo apt upgrade -y

# Instalar el paquete net-tools (para usar el arp para averiguar las ips de los clientes conectados a la lan)
sudo apt install -y net-tools

# Instalar epoptes-client y configurarlo
sudo apt-get install -y --install-recommends epoptes-client
sudo epoptes-client -c

# Añado la IP del server/PC del profesor. 
########## MODIFICAR CAMBIA LA IP A LA QUE CORRESPONDA ##########
# echo "10.2.122.21  server" | sudo tee -a /etc/hosts > /dev/null
# Llamar a la función para obtener la IP del servidor
obtener_ip_servidor

# Añadir la IP del servidor al archivo /etc/hosts
echo "$ip_servidor  server" | sudo tee -a /etc/hosts > /dev/null


# Instalar paquete ssh para poder realizar conexiones remotas profesor > alumno
sudo apt install -y ssh

# Configuramos el sssd (conexión LDAP de Google)
sudo apt install -y sssd sssd-tools

# Copiamos los ficheros necesarios para el login con cuentas Google Workspace del cole

sudo cp "Google_2026_12_14_37258.crt" "/var/"
sudo chmod a+r /var/Google_2026_12_14_37258.crt

sudo cp "Google_2026_12_14_37258.key" "/var/"
sudo chmod a+r /var/Google_2026_12_14_37258.key

# Crear el archivo sssd.conf
sudo bash -c 'cat <<EOF > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
domains = lapurisimavalencia.com, alu.lapurisimavalencia.com

[domain/lapurisimavalencia.com]
cache_credentials = true
ldap_tls_cert = /var/Google_2026_12_14_37258.crt
ldap_tls_key = /var/Google_2026_12_14_37258.key
ldap_uri = ldaps://ldap.google.com:636
ldap_search_base = dc=lapurisimavalencia,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
override_gid = 137 
ldap_group_search_base = OU=PROFESORADO   

[domain/alu.lapurisimavalencia.com]
cache_credentials = true
ldap_tls_cert = /var/Google_2026_12_14_37258.crt
ldap_tls_key = /var/Google_2026_12_14_37258.key
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

# Configurar Ubuntu para usar X11 en lugar de Wayland
echo -e "[daemon]\nWaylandEnable=false" | sudo tee -a /etc/gdm3/custom.conf

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

# Agregar usuarios a grupos
sudo usermod -aG vboxusers,dialout,epoptes $USER

# Configurar pam para agregar usuarios a grupos al inicio
echo "*;*;*;Al0000-2400;users,dialout,vboxusers,epoptes" | sudo tee -a /etc/security/group.conf

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
sudo apt install -y virtualbox
sudo apt install -y arduino
sudo apt install -y openjdk-11-jdk
sudo apt install -y kwrite

# Configurar Chrome para evitar problemas de sesión
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable --incognito|Exec=/usr/bin/google-chrome-stable --incognito --disable-session-crashed-bubble %U|g' /usr/share/applications/google-chrome.desktop

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
fi


# Siguiente fichero se crea para que obligue a registrar el navegador
sudo cp CloudManagementEnrollmentOptions /etc/opt/chrome/policies/enrollment/
sudo chmod a+r /etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentOptions

sudo cp CloudManagementEnrollmentOptions /opt/google/chrome/policies/enrollment/
sudo chmod a+r /opt/google/chrome/policies/enrollment/CloudManagementEnrollmentOptions

# Cambiamos el fondo de pantalla al iniciar y apagar el PC
# Instalamos el tema spinner necesario para cambiar el fondo al iniciar/reset/apagar el PC
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/spinner/spinner.plymouth 100
# Seleccionamos la opción que sea el tema spinner
echo "Selecciona el tema SPINNER"
read
sudo update-alternatives --config default.plymouth
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

# Generar machine-id único
sudo rm /etc/machine-id /var/lib/dbus/machine-id
sudo systemd-machine-id-setup

# Limpio todo
sudo apt autoclean -y 
sudo apt autoremove -y 
sudo apt purge -y

# Si ejecuto la siguiente instrucción se sale de todo, entonces prefiero hacerlo con el reboot.
# sudo systemctl restart lightdm
echo "Tareas automatizadas completadas con éxito!"
echo "Reiniciando el sistema en 5 segundos..."
sleep 5

# Reiniciamos
sudo reboot


