#!/bin/bash

# Obtener la interfaz de red predeterminada
default_interface=$(ip route | grep '^default' | head -n 1 | awk '{print $5}' | xargs)


# Verificar si se pudo obtener la interfaz predeterminada
if [ -n "$default_interface" ]; then
    echo "La interfaz de red predeterminada es: $default_interface"

    # Obtener la red y la máscara en formato CIDR (por ejemplo, 10.2.123.0/24)
    network=$(ip -o -f inet addr show dev $default_interface | awk '{print $4}' | head -n 1)
if [ -z "$network" ]; then
    echo "No se pudo obtener la red CIDR de la interfaz $default_interface."
    exit 1
fi

    # Obtener la dirección IP local
    local_ip=$(hostname -I | awk '{print $1}')

    # Realizar un escaneo de la red para descubrir dispositivos (excluye la IP local y la IP 10.2.123.21)
    echo "Realizando escaneo de la red en el rango $network..."
    lan_ips=$(nmap -sn --exclude $local_ip $network | grep "Nmap scan report" | awk '{print $NF}')

    # Verificar si se encontraron direcciones IP
    if [ -n "$lan_ips" ]; then
        echo "Direcciones IP encontradas en la LAN:"
        echo "$lan_ips"

        # Eliminar cualquier paréntesis de las direcciones IP
        lan_ips_clean=$(echo "$lan_ips" | sed 's/[()]//g')

        # Usuario administrador
        admin_user="administrador"

        # Construir la cadena de direcciones IP para cssh
        cssh_ips=$(echo "$lan_ips_clean" | tr '\n' ' ')

        # Realizar el cssh a todas las direcciones IP con el usuario administrador
        echo "Iniciando cssh para las direcciones IP encontradas..."
        cssh -l $admin_user $cssh_ips
    else
        echo "No se encontraron dispositivos en la LAN."
    fi
else
    echo "No se pudo determinar la interfaz de red predeterminada."
fi

