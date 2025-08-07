#!/bin/bash
# script to list all operators in a catalog and their channels, versions, etc.
# use opm to implement it

# Default values
version="4.18"
catalog="redhat-operator"
show_help=0

# Parse options using getopts
while getopts "v:c:h" opt; do
    case $opt in
        v)
            version="$OPTARG"
            ;;
        c)
            catalog="$OPTARG"
            ;;
        h)
            show_help=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help=1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help=1
            ;;
    esac
done

# Shift past the options
shift $((OPTIND-1))

# Get command and packages from remaining arguments
cmd="$1"
shift 2>/dev/null

packages=()
while [ $# -gt 0 ]; do
    packages+=("$1")
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

if [ -z "$cmd" ] || [ $show_help -eq 1 ]; then
    print_header "OpenShift Operator Catalog Tool" "🚀"
    echo -e "${BOLD}Usage:${NC} $0 [options] <command> [packages...]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  ${GREEN}-v${NC} <version>   OpenShift version (default: 4.18)"
    echo -e "  ${GREEN}-c${NC} <catalog>   Catalog name (default: redhat-operator)"
    echo -e "  ${GREEN}-h${NC}             Show this help message"
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
    echo -e "  ${CYAN}$0 packages${NC}                                  # Use defaults (4.18, redhat-operator)"
    echo -e "  ${CYAN}$0 -v 4.17 packages${NC}                         # Different version"
    echo -e "  ${CYAN}$0 -c certified-operator packages${NC}           # Different catalog"
    echo -e "  ${CYAN}$0 -v 4.18 -c redhat-operator packages ptp-operator cluster-logging${NC}"
    echo -e "  ${CYAN}$0 -c certified-operator packages sriov-fec${NC} # Certified operator"
    echo
    exit 1
fi

_init

$cmd "$@"