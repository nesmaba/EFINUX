#!/bin/bash

# Configuro la IP estática para el profesorado

# Solicitar la IP estática al usuario
read -p "Introduce la IP estática (por ejemplo, 192.168.1.100): " ip_estatica

# Calcular la dirección del gateway (el último byte de la IP será .10)
gateway=$(echo $ip_estatica | sed 's/\.[0-9]\+$/\.2/')

# Obtener el nombre de la interfaz de red (excluyendo la interfaz loopback lo)
interface=$(ip -o -4 addr show up primary scope global | awk '{print $2}' | head -n 1)

if [ -z "$interface" ]; then
    echo "No se pudo detectar una interfaz de red activa."
    exit 1
fi

# Buscar el archivo de configuración de Netplan
netplan_file=$(sudo ls /etc/netplan/*.yaml 2>/dev/null | head3 -n 1)

if [ -z "$netplan_file" ]; then
    echo "No se encontró ningún archivo de configuración de Netplan. Creando uno nuevo..."
    netplan_file="/etc/netplan/01-netcfg.yaml"
else
    # Hacer una copia de seguridad del archivo original
    sudo cp "$netplan_file" "${netplan_file}.bak"
fi

# Crear o modificar el archivo de configuración de netplan
sudo tee "$netplan_file" > /dev/null <<EOF
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

echo "Configuración de red actualizada y aplicada con éxito."
