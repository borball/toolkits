# Download Managed Cluster Kubeconfigs

A beautiful command-line tool that automatically downloads kubeconfig files from all managed clusters in your hub cluster.

## 🚀 Features

- **🔍 Auto-discovery**: Automatically finds all managed clusters (excluding local-cluster)
- **📥 Batch download**: Downloads all kubeconfigs in one operation
- **🎨 Beautiful output**: Colorized progress indicators and summary
- **📊 Progress tracking**: Shows download success/failure counts
- **📁 Organized storage**: Saves files in `~/.kubes/` directory (customizable)
- **🎛️ Configurable location**: Accepts custom directory as first parameter
- **🛡️ Error handling**: Graceful handling of failed downloads

## 📋 Prerequisites

- **OpenShift CLI (oc)** - Must be installed and authenticated to hub cluster
- **Hub cluster access** - Must be logged into the hub cluster with appropriate permissions
- **Bash 4.0+** - For color support and array handling

## 🔧 Usage

```bash
# Make the script executable
chmod +x download-mcl-kubeconfigs.sh

# Run the script (uses default directory: ~/.kubes)
./download-mcl-kubeconfigs.sh

# Or specify a custom directory
./download-mcl-kubeconfigs.sh /path/to/custom/directory
./download-mcl-kubeconfigs.sh ~/my-kubeconfigs
```

## 📖 Example Output

```shell
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🔗 MANAGED CLUSTER KUBECONFIGS DOWNLOADER 🔗
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ️ Discovering managed clusters...
✅ Found 5 managed clusters

⬇️ Starting kubeconfig downloads...

🔗 Processing cluster: sno130
  ✅ Downloaded kubeconfig for sno130
🔗 Processing cluster: sno132
  ✅ Downloaded kubeconfig for sno132
🔗 Processing cluster: sno133
  ✅ Downloaded kubeconfig for sno133
🔗 Processing cluster: sno146
  ✅ Downloaded kubeconfig for sno146
🔗 Processing cluster: sno171
  ✅ Downloaded kubeconfig for sno171

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Download Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Successfully downloaded: 5 kubeconfigs
ℹ️ Kubeconfigs saved to: ~/.kubes

Downloaded files:
  • kubeconfig-sno130.yaml
  • kubeconfig-sno132.yaml
  • kubeconfig-sno133.yaml
  • kubeconfig-sno146.yaml
  • kubeconfig-sno171.yaml
```

## 📁 File Structure

After running the script, your kubeconfig directory will look like:

```
~/.kubes/                    # Default location
├── kubeconfig-cluster1.yaml
├── kubeconfig-cluster2.yaml
├── kubeconfig-cluster3.yaml
└── ...

# Or custom location if specified
/custom/path/
├── kubeconfig-cluster1.yaml
├── kubeconfig-cluster2.yaml
└── ...
```

## 🔧 Using the Downloaded Kubeconfigs

Once downloaded, you can use the kubeconfigs in several ways:

### Option 1: Direct oc commands
```bash
# Use specific kubeconfig for commands
oc --kubeconfig ~/.kubes/kubeconfig-cluster1.yaml get nodes

# Or set KUBECONFIG environment variable
export KUBECONFIG=~/.kubes/kubeconfig-cluster1.yaml
oc get nodes
```

### Option 2: Create your own aliases
```bash
# Add to your ~/.bashrc or ~/.zshrc
alias oc-cluster1='oc --kubeconfig ~/.kubes/kubeconfig-cluster1.yaml'
alias switch-cluster1='export KUBECONFIG=~/.kubes/kubeconfig-cluster1.yaml'
```

### Option 3: Merge kubeconfigs
```bash
# Merge multiple kubeconfigs into one file
export KUBECONFIG=~/.kube/config:~/.kubes/kubeconfig-cluster1.yaml:~/.kubes/kubeconfig-cluster2.yaml
oc config view --flatten > ~/.kube/merged-config
```

## ⚠️ Important Notes

- **Permissions**: Ensure you have admin access to the managed clusters
- **Network**: Requires network connectivity to the hub cluster
- **Storage**: Each kubeconfig file is typically small (< 5KB)
- **Security**: Kubeconfig files contain sensitive authentication data - protect them accordingly

## 🐛 Troubleshooting

### No managed clusters found
- Verify you're connected to the hub cluster: `oc cluster-info`
- Check if managed clusters exist: `oc get mcl`

### Download failures
- Ensure the cluster namespace exists
- Verify the secret name format: `<cluster>-admin-kubeconfig`
- Check your permissions on the managed cluster namespaces

### Permission denied errors
- Ensure you have admin access to managed cluster namespaces
- Verify your hub cluster authentication: `oc whoami`

## 🔄 Script Behavior

1. **Discovery Phase**: Uses `oc get mcl` to find all managed clusters
2. **Filtering**: Excludes the `local-cluster` automatically  
3. **Download Phase**: Retrieves kubeconfig from each cluster's secret
4. **Validation**: Checks if download was successful before continuing
5. **Summary**: Provides detailed report of successful and failed downloads

## 🛠️ Customization

### Directory Configuration
```bash
# Use default directory (~/.kubes)
./download-mcl-kubeconfigs.sh

# Use custom directory
./download-mcl-kubeconfigs.sh /my/custom/path
./download-mcl-kubeconfigs.sh ~/work/clusters
```

### Script Modifications
You can modify the script to:
- Modify the kubeconfig secret name pattern if your setup differs
- Add additional filtering logic for specific clusters  
- Customize the output colors and formatting
- Change the file naming convention by editing line 75
