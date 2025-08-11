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

## 🚀 Quick Start

```bash
# Explore operator catalog with beautiful formatting
./oc-catalog.sh 4.18 redhat-operator packages ptp-operator cluster-logging

# Download all managed cluster kubeconfigs
./download-mcl-kubeconfigs.sh
```

## 📋 Prerequisites

- **OpenShift CLI (oc)** - Required for cluster operations
- **OPM CLI (opm)** - Required for operator catalog tool  
- **jq** - JSON processor for parsing catalog data
- **Bash 4.0+** - For color support and array handling
- **Hub cluster access** - Required for downloading managed cluster kubeconfigs