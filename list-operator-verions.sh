#!/bin/bash
# fetch operator versions for a given version of redhat operator index
# usage: ./list-operator-versions.sh <version>
# example: ./list-operator-versions.sh 4.18


version=$1
number_of_versions=$2

if [ -z "$version" ]; then
    echo "Usage: $0 <version> <number_of_versions>"
    echo "number_of_versions is optional, default is 1"
    echo "example: $0 4.18 5"
    echo "example: $0 4.18"
    exit 1
fi

if [ -z "$number_of_versions" ]; then
    number_of_versions=1
fi

redhat_operator_index="registry.redhat.io/redhat/redhat-operator-index:v${version}"
certified_operator_index="registry.redhat.io/redhat/certified-operator-index:v${version}"

redhat_operators=(
    "sriov-network-operator"
    "lifecycle-agent"
    "redhat-oadp-operator"
    "local-storage-operator"
    "ptp-operator"
    "cluster-logging"
)

certified_operators=(
    "sriov-fec"
)

create_temp_workdir() {
    workdir=$(mktemp -d /tmp/operator-versions-cm.XXXXXX)
}

cleanup() {
    podman stop redhat-catalog 1>/dev/null 2>&1
    podman rm redhat-catalog 1>/dev/null 2>&1
    podman stop certified-catalog 1>/dev/null 2>&1
    podman rm certified-catalog 1>/dev/null 2>&1
    rm -rf $workdir
}

extract_catalog_files() {
    echo "Extracting catalog files from $redhat_operator_index and $certified_operator_index..."
    podman pull $redhat_operator_index 1>/dev/null 2>&1
    podman run -d --name redhat-catalog $redhat_operator_index 1>/dev/null 2>&1
    podman cp redhat-catalog:/configs $workdir/redhat-operators

    podman pull $certified_operator_index 1>/dev/null 2>&1
    podman run -d --name certified-catalog $certified_operator_index 1>/dev/null 2>&1
    podman cp certified-catalog:/configs $workdir/certified-operators
}

create_temp_workdir
extract_catalog_files

echo "--------------------------------"

for operator in "${redhat_operators[@]}"; do
    if [ -f $workdir/redhat-operators/$operator/catalog.json ]; then
        echo $operator latest $number_of_versions versions:
        versions=$(cat $workdir/redhat-operators/$operator/catalog.json | jq -r '.|select(.schema=="olm.bundle")|.name'|tail -$number_of_versions)
        for v in $versions; do
            echo $(echo $v| sed "s/${operator}.//"| sed "s/oadp-operator.//")
        done
    else
        echo "$operator: not found"
    fi
    echo 
done

for operator in "${certified_operators[@]}"; do
    if [ -f $workdir/certified-operators/$operator/catalog.json ]; then
        echo $operator latest $number_of_versions versions:
        versions=$(cat $workdir/certified-operators/$operator/catalog.json | jq -r '.|select(.schema=="olm.bundle")|.name'|tail -$number_of_versions)
        for v in $versions; do
            echo $(echo $v| sed "s/${operator}.//")
        done
    else
        echo "$operator: not found"
    fi
    echo
done

echo "--------------------------------"
cleanup