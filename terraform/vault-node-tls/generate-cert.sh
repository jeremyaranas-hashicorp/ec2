# # RHEL
# mkdir /home/ec2-user/certs && cd /home/ec2-user/certs

# Ubuntu
mkdir /home/ubuntu/certs && cd /home/ubuntu/certs

# Generate CA cert to sign the certificate 
# Generate a private key for the CA cert to pair with
openssl genrsa -out myCA.key 2048

# Use private key to generate CA certificate
# Set "Common Name" to vault-primary.vaultsupport.local
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem -subj "/C=US/ST=CA/L=SJ/O=Test/OU=Test/CN=vault-primary.vaultsupport.local"

# Sign certificate with CA certificate
openssl genrsa -out vault-primary.vaultsupport.local -out vault-primary.vaultsupport.local.key

# Use the new private key to make a CSR for the host
# Set "Common Name" to vault-primary.vaultsupport.local
openssl req -new -key vault-primary.vaultsupport.local.key -out vault-primary.vaultsupport.local.csr -subj "/C=US/ST=CA/L=SJ/O=Test/OU=Test/CN=vault-primary.vaultsupport.local"

# With the CSR and key, sign a certificate for this host
# Create an extension file to add SANs to certs
cat > vault-primary.vaultsupport.local.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = vault-primary.vaultsupport.local
IP.2 = 10.0.101.21
EOF

# Generate certificate for this host
openssl x509 -req -in vault-primary.vaultsupport.local.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out vault-primary.vaultsupport.local.pem -days 365 -sha256 -extfile vault-primary.vaultsupport.local.ext