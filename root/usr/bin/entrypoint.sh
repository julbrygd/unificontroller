#!/bin/sh

if [[ -d /etc/docker.entrypoint.d ]]; then
    for FILE in "/etc/docker.entrypoint.d/*.sh"; do
        . ${FILE}
    done
fi

CMD=$1
if [[ ${#@} -gt 0 ]]; then
    shift
fi

case $CMD in
    "unifi_controller_start")
        init_unifi_ctl
        wait_for_mongo_db
        MONG_DB=$?
        if [[ $MONG_DB -eq 10 ]]; then
            exit 1
        else
            unifictl start
        fi
        ;;
    *)
        exec $CMD $@
        ;;
esac