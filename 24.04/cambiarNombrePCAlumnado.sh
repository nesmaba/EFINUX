#!/bin/bash

# Pedir número del PC
read -p "Introduce el número del PC (ej. 01, 02, ..., 30): " pcnum

# Validar formato de número de PC (2 dígitos)
if ! [[ "$pcnum" =~ ^[0-9]{2}$ ]]; then
    echo "Número inválido. Debe ser un número de 2 dígitos (ej. 01, 02, 10)."
    exit 1
fi

# Pedir número de aula
read -p "Introduce el número del aula (ej. 118, 119, 403, 404): " aula

# Determinar sufijo según aula
case "$aula" in
    118) tipo="INF2" ;;
    119) tipo="INF1" ;;
    403) tipo="SMR2" ;;
    404) tipo="SMR1" ;;
    *)
        echo "Aula no reconocida. Usa 118, 119, 403 o 404."
        exit 1
        ;;
esac

# Construir nuevo hostname
new_hostname="alumno${pcnum}-${aula}-${tipo}"
echo "Cambiando hostname a: $new_hostname"

# Cambiar hostname
sudo hostnamectl set-hostname "$new_hostname"

# Actualizar /etc/hosts
sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/" /etc/hosts

# Regenerar machine-id
echo "Regenerando machine-id..."

sudo truncate -s 0 /etc/machine-id
sudo systemd-machine-id-setup

echo "Hostname y machine-id actualizados. Reinicia el sistema para aplicar todos los cambios."
