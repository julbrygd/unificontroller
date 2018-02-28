#!/bin/sh

if [[ -d /etc/docker.entrypoint.d ]]; then
    for FILE in "/etc/docker.entrypoint.d/*.sh"; do
        . ${FILE}
    done
fi

for CALL_FUNC in $ENTRYPOINT_FUNCS; do
    $CALL_FUNC $*
done