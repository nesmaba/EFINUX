#!/bin/bash

echo "==============================="
echo " REPARACIÓN MATE – PANEL (FIX)"
echo "==============================="

for HOME in /home/*; do
  USERNAME=$(basename "$HOME")
  id "$USERNAME" &>/dev/null || continue

  echo "→ Reparando usuario: $USERNAME"

  # Quitar immutable si existe
  chattr -i "$HOME/.config/dconf/user" 2>/dev/null
  chattr -Ri "$HOME/.config/mate" 2>/dev/null

  # Limpiar config rota
  rm -f  "$HOME/.config/dconf/user"
  rm -rf "$HOME/.config/mate/panel"

  # Permisos correctos
  chown -R "$USERNAME:$USERNAME" "$HOME/.config" 2>/dev/null
done

echo "✔ Reparación completa"
echo "➡️  Cerrar sesión y volver a entrar"

