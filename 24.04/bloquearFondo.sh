#!/bin/bash

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

echo "✅ Configuración completada. Reinicia el sistema para aplicar los cambios."
