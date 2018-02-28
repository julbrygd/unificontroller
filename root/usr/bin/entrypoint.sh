#!/bin/sh

check_is_func(){
    type $1|grep "is a shell function" > /dev/null
    RC=$?
    if [[ $RC -eq 0 ]]; then
        exit 0
    else 
        exit 1
    fi
}

if [[ -d /etc/docker.entrypoint.d ]]; then
    for FILE in "/etc/docker.entrypoint.d/*.sh"; do
        . ${FILE}
    done
fi

CMD=$1
CMD_VAR="CALL_${CMD}"
if [[ ${#@} -gt 0 ]]; then
    shift
fi

if [[ check_is_func $CMD_VAR ]]; then
    $CMD_VAR $@
else
    $CMD $@
fi