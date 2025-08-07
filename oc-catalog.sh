#!/bin/bash
# script to list all operators in a catalog and their channels, versions, etc.
# use opm to implement it

version=${1:-4.18}
shift
catalog=${1:-redhat-operator}
shift
cmd=$1
shift
packages=()
while [ $# -gt 0 ]; do
    packages+=($1)
    shift
done

# Color and formatting variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Formatting functions
print_header() {
    local title="$1"
    local emoji="$2"
    echo -e "\n${emoji} ${CYAN}${BOLD}${title}${NC}"
    printf "${BOLD}%s${NC}\n" "$(printf '=%.0s' {1..50})"
}

print_table_header() {
    local col1="$1"
    local col2="$2"
    local width1="${3:-25}"
    local width2="${4:-20}"
    
    echo -e "${BOLD}┌$(printf '─%.0s' $(seq 1 $((width1+2))))┬$(printf '─%.0s' $(seq 1 $((width2+2))))┐${NC}"
    printf "${BOLD}│ %-${width1}s │ %-${width2}s │${NC}\n" "$col1" "$col2"
    echo -e "${BOLD}├$(printf '─%.0s' $(seq 1 $((width1+2))))┼$(printf '─%.0s' $(seq 1 $((width2+2))))┤${NC}"
}

print_table_row() {
    local col1="$1"
    local col2="$2"
    local width1="${3:-25}"
    local width2="${4:-20}"
    
    printf "│ ${GREEN}%-${width1}s${NC} │ ${YELLOW}%-${width2}s${NC} │\n" "$col1" "$col2"
}

print_table_footer() {
    local width1="${1:-25}"
    local width2="${2:-20}"
    echo -e "${BOLD}└$(printf '─%.0s' $(seq 1 $((width1+2))))┴$(printf '─%.0s' $(seq 1 $((width2+2))))┘${NC}"
}

print_summary() {
    local count="$1"
    local type="$2"
    echo -e "${BLUE}📊 Summary: ${BOLD}${count}${NC} ${BLUE}${type} found${NC}"
}

_init() {
    # Defensive check for required variables
    if [ -z "$version" ]; then
        echo -e "${RED}Error: Version parameter is required${NC}" >&2
        exit 1
    fi
    if [ -z "$catalog" ]; then
        echo -e "${RED}Error: Catalog parameter is required${NC}" >&2
        exit 1
    fi
    
    _index="registry.redhat.io/redhat/${catalog}-index:v${version}"
    local json_file="/tmp/${catalog}-${version}.json"
    
    if [ -f "$json_file" ]; then
        #if modified more than 120 minutes ago, re-render
        if [ $(stat -c %Y "$json_file") -lt $(date -d "120 minutes ago" +%s) ]; then
            echo -e "${BLUE}Refreshing catalog data...${NC}" >&2
            opm render $_index > "$json_file"
        fi
    else
        echo -e "${BLUE}Downloading catalog data...${NC}" >&2
        opm render $_index > "$json_file"
    fi
}

packages() {
    print_header "OpenShift Operator Packages (${catalog}-${version})" "📦"
    print_table_header "Package Name" "Default Channel" 55 30
    
    local json_file="/tmp/${catalog}-${version}.json"
    local count=0
    
    if [ ${#packages[@]} -eq 0 ]; then
        while IFS=$'\t' read -r name channel; do
            print_table_row "$name" "$channel" 55 30
            ((count++))
        done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.package")|[.name,.defaultChannel])|@tsv')
    else
        for package in ${packages[@]}; do
            while IFS=$'\t' read -r name channel; do
                print_table_row "$name" "$channel" 55 30
                ((count++))
            done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.package" and .name=="'$package'")|[.name,.defaultChannel])|@tsv')
        done
    fi
    
    print_table_footer 55 30
    print_summary "$count" "packages"
    echo
}

channels() {
    print_header "OpenShift Operator Channels (${catalog}-${version})" "📺"
    print_table_header "Package Name" "Channel" 55 35
    
    local json_file="/tmp/${catalog}-${version}.json"
    local count=0
    
    if [ ${#packages[@]} -eq 0 ]; then
        while IFS=$'\t' read -r package channel; do
            print_table_row "$package" "$channel" 55 35
            ((count++))
        done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.channel")|[.package,.name])|@tsv')
    else
        for package in ${packages[@]}; do
            while IFS=$'\t' read -r pkg channel; do
                print_table_row "$pkg" "$channel" 55 35
                ((count++))
            done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.channel" and .package=="'$package'")|[.package,.name])|@tsv')
        done
    fi
    
    print_table_footer 55 35
    print_summary "$count" "channels"
    echo
}

versions() {
    print_header "OpenShift Operator Versions (${catalog}-${version})" "🔢"
    print_table_header "Package Name" "Version/Bundle" 55 45
    
    local json_file="/tmp/${catalog}-${version}.json"
    local count=0
    
    if [ ${#packages[@]} -eq 0 ]; then
        while IFS=$'\t' read -r package ver; do
            print_table_row "$package" "$ver" 55 45
            ((count++))
        done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.bundle")|[.package,.name])|@tsv')
    else
        for package in ${packages[@]}; do
            while IFS=$'\t' read -r pkg ver; do
                print_table_row "$pkg" "$ver" 55 45
                ((count++))
            done < <(cat "$json_file" | jq -cr '(.|select(.schema=="olm.bundle" and .package=="'$package'")|[.package,.name])|@tsv')
        done
    fi
    
    print_table_footer 55 45
    print_summary "$count" "versions"
    echo
}

if [ -z "$cmd" ]; then
    print_header "OpenShift Operator Catalog Tool" "🚀"
    echo -e "${BOLD}Usage:${NC} $0 <version> <catalog> <command> [packages...]"
    echo
    echo -e "${BOLD}Parameters:${NC}"
    echo -e "  ${GREEN}version${NC}   - OpenShift version (default: 4.18)"
    echo -e "  ${GREEN}catalog${NC}   - Catalog name (default: redhat-operator)"
    echo -e "  ${GREEN}command${NC}   - Action to perform"
    echo
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  📦 ${YELLOW}packages${NC}  - List operator packages and their default channels"
    echo -e "  📺 ${YELLOW}channels${NC}  - List all available channels for packages"
    echo -e "  🔢 ${YELLOW}versions${NC}  - List all available versions/bundles for packages"
    echo
    echo -e "${BOLD}Package Arguments:${NC}"
    echo -e "  • Specify one or more package names to filter results"
    echo -e "  • If no packages provided, all packages will be listed"
    echo
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  ${CYAN}$0 4.18 redhat-operator packages${NC}"
    echo -e "  ${CYAN}$0 4.18 redhat-operator packages cluster-logging ptp-operator${NC}"
    echo -e "  ${CYAN}$0 4.18 certified-operator packages sriov-fec${NC}"
    echo
    exit 1
fi

_init

$cmd "$@"