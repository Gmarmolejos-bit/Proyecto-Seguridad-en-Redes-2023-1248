#!/bin/bash

# ==========================================
# CONFIGURACIÓN DEL WEB-SERVER
# ==========================================

# Red
ip addr replace 10.12.48.130/28 dev eth0
ip link set eth0 up
ip route replace default via 10.12.48.129

# DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Actualizar repositorios
apt update

# Instalar servicios necesarios
apt install nginx openssl mariadb-client -y

# Crear directorio para certificados
mkdir -p /etc/nginx/ssl

# Crear certificado SSL autofirmado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/server.key \
-out /etc/nginx/ssl/server.crt \
-subj "/CN=10.12.48.130"

# Configuración de Nginx
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80;
    server_name 10.12.48.130;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name 10.12.48.130;

    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    root /var/www/html;
    index index.html;
}
EOF

# Página de prueba
echo "<h1>Servidor WEB funcionando por HTTPS</h1>" > /var/www/html/index.html

# Comprobar configuración
nginx -t

# Iniciar o recargar Nginx
nginx -s reload 2>/dev/null || nginx

echo "WEB-SERVER configurado correctamente."
