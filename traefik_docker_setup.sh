### Pre-Installation

sudo apt install apache2-utils -y

docker network create proxy

## Passwort für Traefik setzen -- Ausgabe speichern!

htpasswd -nb traefikadmin password

## Directory für Traefik erstellen

mkdir -p traefik/

### Traefik Configuration

## traefik.toml-Datei erstellen

cd traefik/
cat << EOF > traefik.toml
#Traefik Global Configuration
debug = false
checkNewVersion = true
logLevel = "ERROR"

#Define the EntryPoint for HTTP and HTTPS
defaultEntryPoints = ["https","http"]

#Enable Traefik Dashboard on port 8080
#with basic authentication method
#mohammad and password
[web]
address = ":8080"
[web.auth.basic]
users = ["mohammad:$apr1$hEgpZUN2$OYG3KwpzI3T1FqIg9LIbi."]

#Define the HTTP port 80 and
#HTTPS port 443 EntryPoint
#Enable automatically redirect HTTP to HTTPS
[entryPoints]
[entryPoints.http]
address = ":80"
[entryPoints.http.redirect]
entryPoint = "https"
[entryPoints.https]
address = ":443"
[entryPoints.https.tls]

#Enable retry sending a request if the network error
[retry]

#Define Docker Backend Configuration
[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "traefik.hakase-labs.io"
watch = true
exposedbydefault = false

#Letsencrypt Registration
#Define the Letsencrypt ACME HTTP challenge
[acme]
email = "hakaselabs@gmail.com"
storage = "acme.json"
entryPoint = "https"
OnHostRule = true
  [acme.httpChallenge]
  entryPoint = "http"
EOF

### Create Traefik Docker Compose Script

cat << EOF > docker-compose.yml
version: '3'

services:

  traefik:
    image: traefik:latest
    command: --docker --docker.domain=hakase-labs.io
    ports:
      - 80:80
      - 443:443
    networks:
      - proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.toml:/traefik.toml
      - ./acme.json:/acme.json
    labels:
      - "traefik.frontend.rule=Host:traefik.hakase-labs.io"
      - "traefik.port=8080"
    container_name: traefik
    restart: always

networks:
  proxy:
    external: true
EOF

### Create ACME.json-File

touch acme.json
chmod 600 acme.json

## Build Traefik Container

cd traefik/

docker-compose up -d
