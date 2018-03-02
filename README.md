# Unifi Controller Docker image 
![Ubiquiti Logo](https://home.conrad.pics/ubiquiti_logo.png)  
This Docker image is based on an Alpine Linux und has no MongoDB included.  
You must use an external Database e.g. with Docker Compose.

## Persist Data
The image has a volume "/var/lib/unifi" where the configuration and the data, e.g. Firmware-Dowloads are stored.

## Ports
| Port    | Usage                |
|---------|----------------------|
|3478/udp |                      |
|6789/tcp |                      |
|8080/tcp | HTTP Gui Redirect to HTTPS |
|8443/tcp | HTTPS GUI            |
|8843/tcp |                      |
|8880/tcp |                      |
|8881/tcp |                      |
|8882/tcp |                      |

## Envoirenment (Config)
|Variable|Default|Description|
|--------|-------|-----------|
|UNIFI_MONGO_DB_HOST|mongo|Mongo DB Host Name|
|UNIFI_MONGO_DB_USE_AUTH|FALSE|Use Mongo DB Authentification (FALSE or TRUE)|
|UNIFI_MONGO_DB_USER||Mongo DB Username|
|UNIFI_MONGO_DB_PASS||Mongo DB Password|
|UNIFI_MONGO_DB_NAME|ace|Database Name|
|UNIFI_MONGO_DB_STAT_NAME|ace-stat|Statistics Database name|
|UNIFI_MONGO_DB_PORT|27017|Mongo DB Port|
|UNIFI_MONGO_DB_WAIT_TIMEOUT|60|Wait x seconds to connect to Mongo|
## Docker Compse example:
```
version: '2.2'
services:
  unificontroler:
    image: "julbrygd/unificontroller"
    ports:
      - "3478:3478/udp"
      - "6789:6789/tcp"
      - "8080:8080/tcp"
      - "8443:8443/tcp"
      - "8843:8843/tcp"
      - "8880:8880/tcp"
      - "8881:8881/tcp"
      - "8882:8882/tcp"
    environment:
      UNIFI_MONGO_DB_HOST: "mongo"
      UNIFI_MONGO_DB_USE_AUTH: "FALSE"
      UNIFI_MONGO_DB_USER: ""
      UNIFI_MONGO_DB_PASS: ""
      UNIFI_MONGO_DB_NAME: "ace"
      UNIFI_MONGO_DB_STAT_NAME: "ace-stat"
      UNIFI_MONGO_DB_PORT: "27017"
      UNIFI_MONGO_DB_WAIT_TIMEOUT: "60"
    depends_on:
      - mongo
    volumes:
      - unifi_data:/var/lib/unifi

  mongo:
    image: mongo
    volumes:
      - unifi_mongo_data:/data/db
volumes:
  unifi_data:
  unifi_mongo_data:
```