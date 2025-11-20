# Toolkits

This directory contains useful scripts and tools for managing OpenShift clusters and operators.

## 📚 Available Tools

### 📦 OpenShift Operator Catalog Tool
**Script:** `oc-catalog.sh`

A beautiful command-line tool for exploring OpenShift operator catalogs with professional table formatting. List packages, channels, and versions with colorized output and summary statistics.

**📖 [View Documentation](./oc-catalog.md)**

### 🔗 Download Managed Cluster Kubeconfigs  
**Script:** `download-mcl-kubeconfigs.sh`

Automatically downloads kubeconfigs from all managed clusters in the hub cluster for easy access and management.

**📖 [View Documentation](./download-mcl-kubeconfigs-readme.md)**

### 🔄 ClusterGroupUpgrade (CGU) Creator
**Script:** `create-cgu.sh`

Create ClusterGroupUpgrades for remediating non-compliant policies in OpenShift clusters. Automatically fetches and sorts policies by wave annotation, or accepts manual policy lists.

**Usage:**
```bash
# Auto-fetch all non-compliant policies
./create-cgu.sh sno171

# Manual policy specification
./create-cgu.sh sno171 vdu2-4.20-p1d1-reduce vdu2-4.20-p1d1-ptp-sub
```

### 🔌 SSH to Cluster Node
**Script:** `ssh0.sh`

Quick SSH access to cluster nodes using kubeconfig files. Automatically resolves the node IP and connects via SSH.

**Usage:**
```bash
./ssh0.sh <cluster-name>
```

## 🚀 Quick Start

```bash
# Explore operator catalog with beautiful formatting
./oc-catalog.sh 4.18 redhat-operator packages ptp-operator cluster-logging

# Download all managed cluster kubeconfigs
./download-mcl-kubeconfigs.sh

# Create CGU for non-compliant policies
./create-cgu.sh sno171

# SSH to a cluster node
./ssh0.sh sno171
```

## 📋 Prerequisites

- **OpenShift CLI (oc)** - Required for cluster operations
- **OPM CLI (opm)** - Required for operator catalog tool  
- **jq** - JSON processor for parsing catalog data
- **Bash 4.0+** - For color support and array handling
- **Hub cluster access** - Required for downloading managed cluster kubeconfigs and creating CGUs
- **SSH access** - Required for ssh0.sh script to connect to cluster nodes
- **Kubeconfig files in /etc/kubes/** - Required for ssh0.sh script (format: kubeconfig-<cluster>.yaml)