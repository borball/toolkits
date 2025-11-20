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