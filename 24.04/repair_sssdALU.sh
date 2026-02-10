#!/bin/bash
set -e

echo "▶ Configurando /etc/sssd/sssd.conf..."

sudo tee /etc/sssd/sssd.conf > /dev/null << 'EOF'
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
ldap_search_base = dc=alu,dc=lapurisimavalencia,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
override_gid = 100
ldap_group_search_base = OU=ALUMNADO
EOF

echo "▶ Ajustando permisos..."
sudo chmod 600 /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf

echo "▶ Reiniciando SSSD..."
sudo systemctl stop sssd || true
sudo sss_cache -E || true
sudo systemctl start sssd

echo "▶ Estado de SSSD:"
systemctl --no-pager status sssd

echo "✅ Script finalizado"

