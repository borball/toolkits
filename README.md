# Toolkits

This directory contains useful scripts and tools for managing OpenShift clusters and operators.

## 📚 Available Tools

### 📦 List Operator Versions
**Script:** `list-operator-versions.sh`

A beautiful CLI tool to fetch and display operator versions from Red Hat and Certified operator indexes.

**📖 [View Documentation](./list-operator-versions-readme.md)**

### 🔗 Download Managed Cluster Kubeconfigs & Create Aliases  
**Script:** `download-mcl-kubeconfigs-alias.sh`

Automatically downloads kubeconfigs from managed clusters and creates convenient shell aliases for easy cluster access.

**📖 [View Documentation](./download-mcl-kubeconfigs-alias-readme.md)**

## 🚀 Quick Start

```bash
# List latest operator versions for OpenShift 4.18
./list-operator-versions.sh 4.18 3

# Download all managed cluster kubeconfigs
./download-mcl-kubeconfigs-alias.sh
```

## 📋 Prerequisites

- **OpenShift CLI (oc)** - Required for cluster operations
- **Podman** - Required for operator version script
- **jq** - JSON processor for parsing catalog data
- **Bash 4.0+** - For color support and array handling