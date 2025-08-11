#!/bin/bash

# usage: ./download-mcl-kubeconfigs.sh
# example: ./download-mcl-kubeconfigs.sh

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
DOWNLOAD="⬇️"
CLUSTER="🔗"
SUCCESS="✅"
ERROR="❌"
INFO="ℹ️"
SEPARATOR="━" 

kubeconfig_dir="${1:-$HOME/.kubes}"

# Download kubeconfig for all managed clusters
# Check if oc is installed
if ! command -v oc &> /dev/null; then
    echo -e "${RED}${ERROR} OpenShift CLI (oc) could not be found!${NC}"
    echo -e "${YELLOW}${INFO} Please install the oc command and try again.${NC}"
    exit 1
fi

# Check if kubeconfig directory exists
if [ ! -d "$kubeconfig_dir" ]; then
    echo -e "${YELLOW}${INFO} Creating kubeconfig directory: ${BOLD}$kubeconfig_dir${NC}"
    mkdir -p "$kubeconfig_dir"
fi

download_kubeconfigs() {
    # Create a beautiful header
    echo ""
    printf "${PURPLE}"
    printf "${SEPARATOR}%.0s" {1..65}
    printf "${NC}\n"
    echo -e "${WHITE}${BOLD}      🔗 MANAGED CLUSTER KUBECONFIGS DOWNLOADER 🔗${NC}"
    printf "${PURPLE}"
    printf "${SEPARATOR}%.0s" {1..65}
    printf "${NC}\n\n"
    
    # Download kubeconfig for all managed clusters
    echo -e "${CYAN}${INFO} Discovering managed clusters...${NC}"
    
    # Get all managed clusters except local cluster
    managed_clusters=$(oc get mcl -o jsonpath='{.items[?(@.metadata.name != "local-cluster")].metadata.name}')
    
    if [ -z "$managed_clusters" ]; then
        echo -e "${RED}${ERROR} No managed clusters found!${NC}"
        return 1
    fi
    
    cluster_count=$(echo $managed_clusters | wc -w)
    echo -e "${GREEN}${SUCCESS} Found ${BOLD}$cluster_count${NC}${GREEN} managed clusters${NC}\n"
    
    echo -e "${BLUE}${DOWNLOAD} Starting kubeconfig downloads...${NC}\n"
    
    downloaded_count=0
    failed_count=0
    
    for cluster in $managed_clusters; do
        echo -e "${YELLOW}${CLUSTER} Processing cluster: ${BOLD}$cluster${NC}"
        
        # Download kubeconfig for the cluster
        if oc get secret -n $cluster $cluster-admin-kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 -d > "$kubeconfig_dir/kubeconfig-$cluster.yaml" 2>/dev/null; then
            echo -e "  ${GREEN}${SUCCESS} Downloaded kubeconfig for ${BOLD}$cluster${NC}"
            ((downloaded_count++))
        else
            echo -e "  ${RED}${ERROR} Failed to download kubeconfig for ${BOLD}$cluster${NC}"
            ((failed_count++))
        fi
    done
    
    # Display summary
    echo ""
    printf "${GREEN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    echo -e "${GREEN}${SUCCESS} ${BOLD}Download Summary${NC}"
    printf "${GREEN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    
    echo -e "${GREEN}${SUCCESS} Successfully downloaded: ${BOLD}$downloaded_count${NC}${GREEN} kubeconfigs${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${RED}${ERROR} Failed downloads: ${BOLD}$failed_count${NC}${RED} kubeconfigs${NC}"
    fi
    echo -e "${CYAN}${INFO} Kubeconfigs saved to: ${BOLD}$kubeconfig_dir${NC}"
    
    # List downloaded files
    if [ $downloaded_count -gt 0 ]; then
        echo -e "\n${BLUE}${BOLD}Downloaded files:${NC}"
        for cluster in $managed_clusters; do
            if [ -f "$kubeconfig_dir/kubeconfig-$cluster.yaml" ]; then
                echo -e "${WHITE}  • kubeconfig-$cluster.yaml${NC}"
            fi
        done
    fi
}

download_kubeconfigs
