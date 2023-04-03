#!/usr/bin/env bash
set -x
exec > >(tee /var/log/tf-user-data.log|logger -t user-data ) 2>&1

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT $0: $1"
}

# Variables
# Get private IP address
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

VAULT_ZIP="${tpl_vault_zip_file}"

# Detect package management system
YUM=$(which yum 2>/dev/null)

# Functions
user_rhel() {
  # RHEL/CentOS user setup
  sudo /usr/sbin/groupadd --force --system $${USER_GROUP}

  if ! getent passwd $${USER_NAME} >/dev/null ; then
    sudo /usr/sbin/adduser \
      --system \
      --gid $${USER_GROUP} \
      --home $${USER_HOME} \
      --no-create-home \
      --comment "$${USER_COMMENT}" \
      --shell /bin/false \
      $${USER_NAME}  >/dev/null
  fi
}

# Install base prerequisites
logger "Setting timezone to UTC"
sudo timedatectl set-timezone UTC
logger "Performing updates and installing prerequisites"
sudo yum-config-manager --enable rhui-REGION-rhel-server-releases-optional
sudo yum-config-manager --enable rhui-REGION-rhel-server-supplementary
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
sudo yum -y check-update
sudo yum install -q -y wget unzip bind-utils ruby rubygems ntp jq
sudo systemctl start ntpd.service
sudo systemctl enable ntpd.service

# Install AWS specific prerequisites
logger "Performing updates and installing prerequisites"
curl --silent -O https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install awscli

# Configure Vault user
USER_NAME="vault"
USER_GROUP="vault"
USER_HOME="/srv/vault"

user_rhel

# Install Vault
logger "Downloading Vault"
curl -o /tmp/vault.zip $${VAULT_ZIP}
logger "Installing Vault"
sudo unzip -o /tmp/vault.zip -d /usr/local/bin/
sudo chmod 0755 /usr/local/bin/vault
sudo chown vault:vault /usr/local/bin/vault
sudo mkdir -pm 0755 /etc/vault.d
sudo mkdir -pm 0755 /etc/ssl/vault
sudo mkdir -pm 0755 ${tpl_vault_storage_path}
sudo chown -R vault:vault ${tpl_vault_storage_path}
sudo chmod -R a+rwx ${tpl_vault_storage_path}
sudo mkdir -p /opt/vault/

sudo tee /etc/vault.d/vault.hcl <<EOF
storage "raft" {
  path    = "${tpl_vault_storage_path}"
  node_id = "${tpl_vault_node_name}"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "false"
  tls_cert_file = "/home/ec2-user/certs/vault-primary.vaultsupport.local.pem"
  tls_key_file = "/home/ec2-user/certs/vault-primary.vaultsupport.local.key"
}

license_path = "/opt/vault/vault.hclic"
api_addr = "http://$${PUBLIC_IP}:8200"
cluster_addr = "http://$${PRIVATE_IP}:8201"
disable_mlock = true
ui=true
EOF

sudo tee /opt/vault/vault.hclic <<EOF
02MV4UU43BK5HGYYTOJZWFQMTMNNEWU33JJ5CFCM2NPJDG2T2XJV2FSVCWNFGUGMD2J5LVE2CMK5EXQWL2LF2FS6TDPJHHU2ZSLJKEM2KNIRVXQSLJO5UVSM2WPJSEOOLULJMEUZTBK5IWST3JJEZFS6SVPBNEIYZTLJBTAMCNPJJGUTCXLE2FS3KVORMWUQLYJZ4TC3C2IRBGYTKUIE2E26SNGRHG2RLJJRBUU4DCNZHDAWKXPBZVSWCSOBRDENLGMFLVC2KPNFEXCSLJO5UWCWCOPJSFOVTGMRDWY5C2KNETMSLKJF3U22SJORGVIRLUJVKEEVKNKRVTMTKUJU3E2RDDOVHVIRJVJZ5ECMSOIRTXUV3JJFZUS3SOGBMVQSRQLAZVE4DCK5KWST3JJF4U2RCJPFGFIRLYJRKEK52WIRAXOT3KIF3U62SBO5LWSSLTJFWVMNDDI5WHSWKYKJYGEMRVMZSEO3DULJJUSNSJNJEXOTLKJV2E2VCFORGVIQSVJVVE2NSOKRVTMTSUNN2U6VDLGVLWSSLTJFXFE3DDNUYXAYTNIYYGCVZZOVMDGUTQMJLVK2KPNFEXSTKEJF5EYVCFPBGFIRLXKZCES6SPNJKTKT3KKU2UY2TLGVHVM33JJRBUU53DNU4WWZCXJYYES2TPNFSG2RRRMJEFC2KMINFG2YSHIZXGG6KJGZSXSSTUMIZFEMLCI5LHUSLKOBRES3JRGFREQUTQJRLVE2SMLBHGUWKXPBWES2LXNFNDEOJSLJMEU5KZK42WUWSTGF3WEMTYOBMTG23JJRBUU2C2JBNGQYTNJZWFUQZRNNMVQUTIJRMEE6LCGNJGYWJTKJYGEMRUORSEQSTIMJXE43LCGNFHISLJO5UVSV2SGJMVONLKLJLVC5C2I5DDAWKTGF3WG3JZGBNFOTRQMFLTS5KMK52GYZKTGF2FSVZVNBNDEVTULJLTKMCJNQYTSZSRHU6S4NBPKFVVE3SULFBFAN3HKNUGY53RJVRXGURPNY3WS5TZKJDVIZSHNVQVMLZSO5KGYUKBIZQXQYLMF54VMWLSGRYUOTLEKF3EMRJVLJZVANDIIJUDG2DPLF3EEQTKKZQWKT3NMZWEI4BRMRAWWY3BGRSFMMBTGM4FA53NKZWGC5SKKA2HASTYJFETSRBWKVDEYVLBKZIGU22XJJ2GGRBWOBQWYNTPJ5TEO3SLGJ5FAS2KKJWUOSCWGNSVU53RIZSSW3ZXNMXXGK2BKRHGQUC2M5JS6S2WLFTS6SZLNRDVA52MG5VEE6CJG5DU6YLLGZKWC2LBJBXWK2ZQKJKG6NZSIRIT2PI
EOF

sudo chown -R vault:vault /etc/vault.d /etc/ssl/vault
sudo chmod -R 0644 /etc/vault.d/*

sudo tee -a /etc/environment <<EOF
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

source /etc/environment

sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Install Vault systemd 
read -d '' VAULT_SERVICE <<EOF
[Unit]
Description=Vault
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d
ExecReload=/bin/kill -HUP \$MAINPID
KillSignal=SIGTERM
User=vault
Group=vault

[Install]
WantedBy=multi-user.target
EOF

# Install Vault systemd that allows additional params/args
sudo tee /etc/systemd/system/vault@.service > /dev/null <<EOF
[Unit]
Description=Vault
Requires=network-online.target
After=network-online.target

[Service]
Environment="OPTIONS=%i"
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d \$OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
KillSignal=SIGTERM
User=vault
Group=vault

[Install]
WantedBy=multi-user.target
EOF

SYSTEMD_DIR="/etc/systemd/system"
logger "Installing systemd services for RHEL/CentOS"
echo "$${VAULT_SERVICE}" | sudo tee $${SYSTEMD_DIR}/vault.service
sudo chmod 0664 $${SYSTEMD_DIR}/vault*

sudo systemctl enable vault

# Set up aliases to ease networking to each node
%{ for address, name in tpl_vault_node_address_names  ~}
echo "${address} ${name}" | sudo tee -a /etc/hosts
%{ endfor ~}


