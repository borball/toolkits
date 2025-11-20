# Toolkits

This directory contains useful scripts and tools for managing OpenShift clusters and operators.

## 📚 Available Toolkits

| Script | Description | Documentation/Usage |
|--------|-------------|---------------------|
| `oc-catalog.sh` | Explore OpenShift operator catalogs with beautiful table formatting | [View Docs](./oc-catalog.md) |
| `download-mcl-kubeconfigs.sh` | Download kubeconfigs from all managed clusters in the hub | [View Docs](./download-mcl-kubeconfigs-readme.md) |
| `create-cgu.sh` | Create ClusterGroupUpgrades for remediating non-compliant policies | `./create-cgu.sh sno171` |
| `ssh0.sh` | Quick SSH access to cluster nodes using kubeconfig files | `./ssh0.sh sno171` |