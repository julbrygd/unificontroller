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
    exec java \
        -Dunifi.datadir=/var/lib/unifi \
        -Dunifi.rundir=/var/run/unifi \
        -Dunifi.logdir=/var/log/unifi \
        -Xmx1024M \
        -Djava.awt.headless=true \
        -Dfile.encoding=UTF-8 \
        -jar lib/ace.jar $*
    cd $OLD_DIR
}

wait_for_mongo_db(){
    COUNTER=0
    nc -z ${UNIFI_MONGO_DB_HOST} $UNIFI_MONGO_DB_PORT{} > /dev/null 2>&1
    MONGO_RUNNING=$?
    while [[ $MONGO_RUNNING -eq 1 ]]; do
        echo "MongoDB on host ${UNIFI_MONGO_DB_HOST} with port ${UNIFI_MONGO_DB_PORT} is not running. Waiting 1s (${COUNTER}s/${UNIFI_MONGO_DB_WAIT_TIMEOUT}s) ..."
        COUNTER=$(expr ${COUNTER} + 1)
        sleep 1
        nc -z ${UNIFI_MONGO_DB_HOST} ${UNIFI_MONGO_DB_PORT} > /dev/null 2>&1
        MONGO_RUNNING=$?
        if [[ $COUNTER -gt ${UNIFI_MONGO_DB_WAIT_TIMEOUT} ]]; then
            MONGO_RUNNING=10
            echo "ERROR: MongoDB still not running after timeout of ${UNIFI_MONGO_DB_WAIT_TIMEOUT}s"
        fi
    done
    return $MONGO_RUNNING
}