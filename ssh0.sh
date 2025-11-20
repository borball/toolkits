#!/bin/bash

cluster=$1

if [ -z "$cluster" ]; then
    echo "Usage: $0 <cluster>"
    exit 1
fi

if [ ! -f "/etc/kubes/kubeconfig-$cluster.yaml" ]; then
    echo "Kubeconfig file /etc/kubes/kubeconfig-$cluster.yaml not found"
    exit 1
fi

# get IP of node
ip=$(oc get node --kubeconfig /etc/kubes/kubeconfig-$cluster.yaml -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

if [ -z "$ip" ]; then
    echo "Node $cluster not found"
    exit 1
fi

# ssh to node
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet core@$ip

