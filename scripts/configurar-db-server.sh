#!/bin/bash

# ==========================================
# CONFIGURACIÓN DEL DB-SERVER
# ==========================================

# Red
ip addr replace 10.12.48.131/28 dev eth0
ip link set eth0 up
ip route replace default via 10.12.48.129

# DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Actualizar repositorios
apt update

# Instalar MariaDB
apt install mariadb-server -y

# Directorios necesarios
mkdir -p /run/mysqld
mkdir -p /var/lib/mysql

chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Inicializar la base si todavía no existe
if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Permitir conexiones por la IP del DB-SERVER
sed -i 's/bind-address.*=.*/bind-address = 10.12.48.131/' \
/etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar MariaDB
mariadbd-safe --datadir=/var/lib/mysql &

sleep 5

# Solicitar contraseña sin guardarla en GitHub
read -s -p "Contraseña para webuser: " DB_PASSWORD
echo

mariadb <<EOF
CREATE DATABASE IF NOT EXISTS webdb;
CREATE USER IF NOT EXISTS 'webuser'@'10.12.48.130' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON webdb.* TO 'webuser'@'10.12.48.130';
FLUSH PRIVILEGES;
EOF

echo "DB-SERVER configurado correctamente."
