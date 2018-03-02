# Unifi Controller Docker image 
![Ubiquiti Logo](https://home.conrad.pics/ubiquiti_logo.png)  
This Docker image is based on an Alpine Linux und has no MongoDB included.  
You must use an external Database e.g. with Docker Compose.

## Persist Data
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
## Docker Compse example