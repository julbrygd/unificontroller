#!/bin/sh

unifictl(){
    OLD_DIR=$(pwd)
    cd /srv/unifi
    java -jar lib/ace.jar $*
    cd $OLD_DIR
}