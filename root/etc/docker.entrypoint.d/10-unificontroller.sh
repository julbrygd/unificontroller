#!/bin/sh

init_unifi_ctl() {
    if [[ ! -e /var/lib/unifi/system.properties ]]; then
        unifictl start > /dev/null &
        while [[ ! -e /var/lib/unifi/system.properties ]]; do
            sleep 1
        done
        kill $(ps|grep [j]ava|awk '{ print $1}')
    fi
    mv /var/lib/unifi/system.properties /var/lib/unifi/system.properties.org
    sed '/\#START_UNIFI_MONGO_DB_DOCKER_CONF/,/\#END_UNIFI_MONGO_DB_DOCKER_CONF/d' /var/lib/unifi/system.properties.org > /var/lib/unifi/system.properties
    echo "#START_UNIFI_MONGO_DB_DOCKER_CONF" >> /var/lib/unifi/system.properties
    echo "db.mongo.local=false" >> /var/lib/unifi/system.properties
    if [[ "${UNIFI_MONGO_DB_USE_AUTH}" == "FALSE" ]]; then
        echo "db.mongo.uri=mongodb://${UNIFI_MONGO_DB_HOST}:${UNIFI_MONGO_DB_PORT}/${UNIFI_MONGO_DB_NAME}" >> /var/lib/unifi/system.properties
        echo "statdb.mongo.uri=mongodb://${UNIFI_MONGO_DB_HOST}:${UNIFI_MONGO_DB_PORT}/${UNIFI_MONGO_DB_STAT_NAME}" >> /var/lib/unifi/system.properties
    else
        echo "db.mongo.uri=mongodb://${UNIFI_MONGO_DB_USER}:${UNIFI_MONGO_DB_PASS}@${UNIFI_MONGO_DB_HOST}:${UNIFI_MONGO_DB_PORT}/${UNIFI_MONGO_DB_NAME}" >> /var/lib/unifi/system.properties
        echo "statdb.mongo.uri=mongodb://${UNIFI_MONGO_DB_USER}:${UNIFI_MONGO_DB_PASS}@${UNIFI_MONGO_DB_HOST}:${UNIFI_MONGO_DB_PORT}/${UNIFI_MONGO_DB_STAT_NAME}" >> /var/lib/unifi/system.properties
    fi
    echo "unifi.db.name=${UNIFI_MONGO_DB_NAME}" >> /var/lib/unifi/system.properties
    echo "#END_UNIFI_MONGO_DB_DOCKER_CONF" >> /var/lib/unifi/system.properties
}

unifictl(){
    OLD_DIR=$(pwd)
    cd /srv/unifi
    java -jar lib/ace.jar $*
    cd $OLD_DIR
}