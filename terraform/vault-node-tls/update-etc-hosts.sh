# Update /etc/hosts with domain name to access Vault environment with FQDN locally
cat >> /etc/hosts << EOF
10.0.101.21 vault-primary.vaultsupport.local
EOF