# Toolkits

This directory contains useful scripts and tools for managing OpenShift clusters and operators.

## 📚 Available Tools

### 📦 OpenShift Operator Catalog Tool
**Script:** `oc-catalog.sh`

A beautiful command-line tool for exploring OpenShift operator catalogs with professional table formatting. List packages, channels, and versions with colorized output and summary statistics.

**📖 [View Documentation](./oc-catalog.md)**

### 🔗 Download Managed Cluster Kubeconfigs & Create Aliases  
**Script:** `download-mcl-kubeconfigs-alias.sh`

Automatically downloads kubeconfigs from managed clusters and creates convenient shell aliases for easy cluster access.

**📖 [View Documentation](./download-mcl-kubeconfigs-alias-readme.md)**

## 🚀 Quick Start

```bash
# Explore operator catalog with beautiful formatting
./oc-catalog.sh 4.18 redhat-operator packages ptp-operator cluster-logging

# Download all managed cluster kubeconfigs
./download-mcl-kubeconfigs-alias.sh
```

## 📋 Prerequisites

- **OpenShift CLI (oc)** - Required for cluster operations
- **OPM CLI (opm)** - Required for operator catalog tool
- **jq** - JSON processor for parsing catalog data
- **Bash 4.0+** - For color support and array handling