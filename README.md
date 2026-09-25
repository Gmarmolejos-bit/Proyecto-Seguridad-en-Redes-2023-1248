# Proyecto Final de Seguridad en Redes

**Estudiante:** Gerson Marmolejos
**Matrícula:** 2023-1248
**Plataforma utilizada:** GNS3
**Tecnologías principales:** FortiGate, Cisco IOSvL2, VLANs, Nginx, HTTPS y MariaDB

## Descripción

Este proyecto consiste en la creación de una infraestructura de red en GNS3, enfocada principalmente en segmentación, seguridad y comunicación entre diferentes equipos.

La idea fue separar los usuarios y los servidores utilizando VLANs, controlar el tráfico mediante un firewall FortiGate y, además, permitir acceso a Internet de forma segura utilizando NAT.

También configuré un servidor web con Nginx y HTTPS, junto con un servidor de base de datos MariaDB. Ambos servidores pueden comunicarse entre sí, pero manteniendo una estructura organizada y controlada desde la red.

## Topología

La red está compuesta por varios dispositivos, cada uno con una función específica dentro del proyecto:

* NAT de GNS3 para proporcionar salida a Internet.
* Firewall FortiGate para controlar y filtrar el tráfico.
* Switch Cisco IOSvL2 para manejar las VLANs.
* Un equipo de usuario.
* Un servidor WEB.
* Un servidor de base de datos.
* Webterm para administración y pruebas.

La verdad es que esta parte fue una de las más importantes del proyecto, porque prácticamente todo depende de que las conexiones entre estos equipos estén correctamente organizadas.

## Redes utilizadas

Para separar los dispositivos utilicé dos redes principales:

| Red               | Función              |
| ----------------- | -------------------- |
| `10.12.48.0/25`   | VLAN 10 - USUARIOS   |
| `10.12.48.128/28` | VLAN 20 - SERVIDORES |

### Direccionamiento principal

* Gateway de VLAN 10: `10.12.48.1`
* FortiGate en red de servidores: `10.12.48.129`
* WEB-SERVER: `10.12.48.130`
* DB-SERVER: `10.12.48.131`

## VLANs

Se configuraron dos VLANs:

* **VLAN 10 - USUARIOS**
* **VLAN 20 - SERVIDORES**

El enlace entre el switch y el FortiGate funciona como un trunk utilizando 802.1Q.

La VLAN 20 fue configurada como VLAN nativa, mientras que la VLAN 10 se transmite etiquetada.

Esto permite mantener separados los equipos de usuario y los servidores, aunque ambos estén conectados al mismo switch físico.

## Firewall FortiGate

FortiGate se utilizó como el punto principal de seguridad de la red.

Se configuraron políticas para:

* Permitir comunicación desde USUARIOS hacia SERVIDORES.
* Permitir que los usuarios tengan acceso a Internet mediante NAT.
* Publicar el servidor WEB hacia la red externa utilizando un Virtual IP.

Para acceder al servidor WEB desde el lado externo se configuró el siguiente redireccionamiento:

`192.168.153.133:8443 → 10.12.48.130:443`

De esta forma, cuando se accede al puerto 8443 del FortiGate, el tráfico es enviado directamente al servicio HTTPS del servidor WEB.

## Servidor WEB

El servidor WEB utiliza Ubuntu y Nginx.

Se configuraron los siguientes servicios:

* HTTP en el puerto `80`.
* HTTPS en el puerto `443`.
* Certificado SSL autofirmado.
* Página web de prueba.

La página configurada muestra el siguiente mensaje:

**Servidor WEB funcionando por HTTPS**

Además, se comprobó que el servidor podía ser accedido correctamente mediante el FortiGate utilizando el Virtual IP.

## Servidor de Base de Datos

El segundo servidor fue configurado con MariaDB.

Su configuración principal es:

* Dirección IP: `10.12.48.131`
* Puerto: `3306`
* Base de datos: `webdb`
* Usuario de aplicación: `webuser`

El usuario fue configurado para aceptar conexiones provenientes específicamente desde el WEB-SERVER con dirección `10.12.48.130`.

Después de configurar MariaDB, realicé una conexión desde el servidor WEB hacia la base de datos y pude acceder correctamente a `webdb`.

## Pruebas realizadas

Durante la práctica fui realizando diferentes pruebas para confirmar que cada parte de la red estuviera funcionando correctamente.

Entre ellas:

* Comunicación entre PC-USUARIO y FortiGate.
* Comunicación entre PC-USUARIO y WEB-SERVER.
* Comunicación entre PC-USUARIO y DB-SERVER.
* Salida a Internet desde la VLAN de usuarios.
* Funcionamiento de HTTP y HTTPS.
* Acceso al servidor WEB mediante el Virtual IP del FortiGate.
* Comunicación entre WEB-SERVER y DB-SERVER mediante el puerto `3306`.
* Verificación de las VLAN 10 y 20.
* Verificación del enlace trunk 802.1Q.

Estas pruebas ayudaron bastante, porque permitieron detectar los errores por partes en lugar de cambiar configuraciones al azar.

## Evidencias

Las capturas utilizadas para demostrar el funcionamiento del proyecto se encuentran en la carpeta:

`capturas/`

Las configuraciones de los dispositivos se encuentran en:

`configuraciones/`

También se incluyen evidencias de:

* Topología completa.
* VLANs configuradas.
* Trunk entre FortiGate y el switch.
* Políticas del firewall.
* Servidor HTTPS funcionando.
* Conexión entre WEB-SERVER y MariaDB.

## Video demostrativo

Aquí se agregará el enlace al video donde se demuestra el funcionamiento completo del proyecto:

**Video:** Pendiente

## Conclusión

Con este proyecto pude trabajar de manera práctica varios temas vistos en Seguridad en Redes.

No solamente se trató de conectar dispositivos, sino de segmentar correctamente la red, controlar qué equipos pueden comunicarse, configurar reglas en el firewall y publicar servicios de forma segura.

Además, trabajar con Nginx, HTTPS y MariaDB permitió integrar servicios reales dentro de la topología, haciendo que la práctica fuera mucho más completa.

## Autor

**Gerson Marmolejos**
Matrícula: **2023-1248**
