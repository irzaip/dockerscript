#!/bin/bash
set -e

VMNAME="vmcentral"
ZONE="us-central1-c"

q="$(tr [A-Z] [a-z] <<< "$1")"

if [ -z q ]; then
    q="ssh"
fi

CMD="gcloud compute"
case $q in
    "ssh")
        CMD="$CMD ssh $VMNAME --zone=$ZONE"
        ;;
    "start")
        CMD="$CMD instances start $VMNAME --async --zone=$ZONE"
        ;;
    "stop")
        CMD="$CMD instances stop $VMNAME --async --zone=$ZONE"
        ;;
    *)
        CMD="$CMD instances describe $VMNAME --zone=$ZONE"
        ;;
esac

if [ ! -z "$CMD" ]; then
    exec $CMD
fi
