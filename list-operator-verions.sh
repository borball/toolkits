#!/bin/bash
# fetch operator versions for a given version of redhat operator index
# usage: ./list-operator-versions.sh <version>
# example: ./list-operator-versions.sh 4.18

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
PACKAGE="📦"
VERSION="🏷️"
SEARCH="🔍"
SUCCESS="✅"
ERROR="❌"
SEPARATOR="━"


version=$1
number_of_versions=$2

if [ -z "$version" ]; then
    echo -e "${RED}${ERROR} Missing required version parameter${NC}"
    echo -e "${YELLOW}${ROCKET} Usage: ${BOLD}$0 <version> <number_of_versions>${NC}"
    echo -e "${CYAN}  • number_of_versions is optional, default is 1${NC}"
    echo -e "${GREEN}  • example: ${BOLD}$0 4.18 5${NC}"
    echo -e "${GREEN}  • example: ${BOLD}$0 4.18${NC}"
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
    echo -e "${CYAN}${SEARCH} Extracting catalog files from:${NC}"
    echo -e "${BLUE}  📋 ${redhat_operator_index}${NC}"
    echo -e "${BLUE}  📋 ${certified_operator_index}${NC}"
    echo ""
    
    podman pull $redhat_operator_index 1>/dev/null 2>&1
    podman run -d --name redhat-catalog $redhat_operator_index 1>/dev/null 2>&1
    podman cp redhat-catalog:/configs $workdir/redhat-operators

    podman pull $certified_operator_index 1>/dev/null 2>&1
    podman run -d --name certified-catalog $certified_operator_index 1>/dev/null 2>&1
    podman cp certified-catalog:/configs $workdir/certified-operators
}

create_temp_workdir
extract_catalog_files

# Create a beautiful separator
printf "${PURPLE}"
printf "${SEPARATOR}%.0s" {1..60}
printf "${NC}\n"
echo -e "${WHITE}${BOLD}         🎯 OPERATOR VERSIONS REPORT 🎯${NC}"
printf "${PURPLE}"
printf "${SEPARATOR}%.0s" {1..60}
printf "${NC}\n\n"

echo -e "${RED}🔴 Red Hat Operators:${NC}\n"

for operator in "${redhat_operators[@]}"; do
    if [ -f $workdir/redhat-operators/$operator/catalog.json ]; then
        echo -e "${YELLOW}${PACKAGE} ${BOLD}${operator}${NC} ${CYAN}(latest ${number_of_versions} versions)${NC}"
        versions=$(cat $workdir/redhat-operators/$operator/catalog.json | jq -r '.|select(.schema=="olm.bundle")|.name'|tail -$number_of_versions)
        for v in $versions; do
            clean_version=$(echo $v| sed "s/${operator}.//"| sed "s/oadp-operator.//")
            echo -e "  ${GREEN}${VERSION} ${clean_version}${NC}"
        done
    else
        echo -e "${RED}${ERROR} ${BOLD}${operator}${NC}: ${RED}not found${NC}"
    fi
    echo 
done

echo -e "${BLUE}🔵 Certified Operators:${NC}\n"

for operator in "${certified_operators[@]}"; do
    if [ -f $workdir/certified-operators/$operator/catalog.json ]; then
        echo -e "${YELLOW}${PACKAGE} ${BOLD}${operator}${NC} ${CYAN}(latest ${number_of_versions} versions)${NC}"
        versions=$(cat $workdir/certified-operators/$operator/catalog.json | jq -r '.|select(.schema=="olm.bundle")|.name'|tail -$number_of_versions)
        for v in $versions; do
            clean_version=$(echo $v| sed "s/${operator}.//")
            echo -e "  ${GREEN}${VERSION} ${clean_version}${NC}"
        done
    else
        echo -e "${RED}${ERROR} ${BOLD}${operator}${NC}: ${RED}not found${NC}"
    fi
    echo
done

# Create a beautiful closing separator
printf "\n${PURPLE}"
printf "${SEPARATOR}%.0s" {1..60}
printf "${NC}\n"
echo -e "${GREEN}${SUCCESS} ${BOLD}Report completed successfully!${NC} ${ROCKET}"
printf "${PURPLE}"
printf "${SEPARATOR}%.0s" {1..60}
printf "${NC}\n"

cleanup