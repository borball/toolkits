#!/bin/bash

# usage: ./download-mcl-kubeconfigs-alias.sh
# example: ./download-mcl-kubeconfigs-alias.sh

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
DOWNLOAD="⬇️"
CONFIG="⚙️"
CLUSTER="🔗"
SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"
SEPARATOR="━" 

kubeconfig_dir="/etc/kubeconfigs"
alias_file="/etc/kubeconfigs/oc-alias"

# Download kubeconfig for all managed clusters and create alias for each cluster 
# Check if oc is installed
if ! command -v oc &> /dev/null; then
    echo -e "${RED}${ERROR} OpenShift CLI (oc) could not be found!${NC}"
    echo -e "${YELLOW}${INFO} Please install the oc command and try again.${NC}"
    exit 1
fi

# Check if kubeconfig directory exists
if [ ! -d $kubeconfig_dir ]; then
    echo -e "${YELLOW}${CONFIG} Creating kubeconfig directory: ${BOLD}$kubeconfig_dir${NC}"
    mkdir -p $kubeconfig_dir
fi

download_kubeconfigs_and_create_alias() {
    # Create a beautiful header
    echo ""
    printf "${PURPLE}"
    printf "${SEPARATOR}%.0s" {1..65}
    printf "${NC}\n"
    echo -e "${WHITE}${BOLD}      🔗 MANAGED CLUSTER KUBECONFIGS DOWNLOADER 🔗${NC}"
    printf "${PURPLE}"
    printf "${SEPARATOR}%.0s" {1..65}
    printf "${NC}\n\n"
    
    # Download kubeconfig for all managed clusters and create alias for each cluster 
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
    echo "#oc alias for managed clusters" > $alias_file
    for cluster in $managed_clusters; do
        echo -e "${YELLOW}${CLUSTER} Processing cluster: ${BOLD}$cluster${NC}"
        
        # Download kubeconfig for the cluster
        if oc get secret -n $cluster $cluster-admin-kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 -d > $kubeconfig_dir/$cluster.kubeconfig 2>/dev/null; then
            echo -e "  ${GREEN}${SUCCESS} Downloaded kubeconfig for ${BOLD}$cluster${NC}"
        else
            echo -e "  ${RED}${ERROR} Failed to download kubeconfig for ${BOLD}$cluster${NC}"
            continue
        fi
        
        # Create alias for the cluster
        echo "alias oc-$cluster='oc --kubeconfig $kubeconfig_dir/$cluster.kubeconfig'" >> $alias_file
        echo -e "  ${BLUE}${CONFIG} Created oc alias: ${BOLD}oc-$cluster${NC}"
    done
    
    echo -e "\n${CYAN}${CONFIG} Creating cluster switch aliases...${NC}"
    echo "#alias to switch to managed clusters" >> $alias_file
    for cluster in $managed_clusters; do
        echo "alias $cluster='export KUBECONFIG=$kubeconfig_dir/$cluster.kubeconfig'" >> $alias_file
        echo -e "${PURPLE}${CONFIG} Created switch alias: ${BOLD}$cluster${NC}"
    done

    # Display the results in a beautiful format
    echo ""
    printf "${CYAN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    echo -e "${WHITE}${BOLD}       📄 ALIAS FILE CONTENT 📄${NC}"
    printf "${CYAN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    
    echo -e "${GREEN}${SUCCESS} Alias file created at: ${BOLD}$alias_file${NC}\n"
    
    # Display the file content with syntax highlighting
    echo -e "${BLUE}${BOLD}File contents:${NC}"
    while IFS= read -r line; do
        if [[ $line == \#* ]]; then
            # Comment lines in cyan
            echo -e "${CYAN}$line${NC}"
        elif [[ $line == alias* ]]; then
            # Alias lines with different colors
            if [[ $line == *"oc --kubeconfig"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo -e "${PURPLE}$line${NC}"
            fi
        else
            echo -e "${WHITE}$line${NC}"
        fi
    done < "$alias_file"
    
    # Beautiful completion message
    echo ""
    printf "${GREEN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    echo -e "${GREEN}${SUCCESS} ${BOLD}All kubeconfigs downloaded successfully!${NC}"
    printf "${GREEN}"
    printf "${SEPARATOR}%.0s" {1..50}
    printf "${NC}\n"
    
    echo -e "${YELLOW}${ROCKET} ${BOLD}To activate the aliases, run:${NC}"
    echo -e "${WHITE}${BOLD}   source $alias_file${NC}\n"
    
    echo -e "${CYAN}${INFO} ${BOLD}Available commands:${NC}"
    echo -e "${BLUE}  • Use ${BOLD}oc-<cluster>${NC}${BLUE} for kubectl commands${NC}"
    echo -e "${PURPLE}  • Use ${BOLD}<cluster>${NC}${PURPLE} to switch KUBECONFIG${NC}"
}

download_kubeconfigs_and_create_alias
