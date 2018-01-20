#!/usr/bin/env bash

env=`terraform workspace show`

vms=`az network public-ip list -g mvp_lpg1 | sed -n 's/\(.*fqdn\": \"\)\(.*\)\(\",\)/\2/p'`

for group in test ; do

    echo ["$group"]

    for host in "$vms"; do
        echo "$host"| grep "$group";
    done

done