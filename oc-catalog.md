# OpenShift Operator Catalog Tool

A beautiful command-line tool for exploring OpenShift operator catalogs with professional table formatting.

## Features

- 📦 **List operator packages** and their default channels
- 📺 **Browse available channels** for each operator
- 🔢 **View all versions/bundles** available for operators
- 🎨 **Beautiful table formatting** with colors and Unicode borders
- 📊 **Summary statistics** showing count of results
- 🚀 **Smart caching** - automatically refreshes catalog data every 2 hours

## Usage

```bash
./oc-catalog.sh <version> <catalog> <command> [packages...]
```

### Parameters

- **version** - OpenShift version (default: 4.18)
- **catalog** - Catalog name (default: redhat-operator)  
- **command** - Action to perform: `packages`, `channels`, or `versions`
- **packages** - Optional: specific package names to filter results

## Commands

### List Packages
Show operator packages and their default channels:

```bash
# List all packages
./oc-catalog.sh 4.18 redhat-operator packages

# List specific packages
./oc-catalog.sh 4.18 redhat-operator packages ptp-operator cluster-logging
```

**Output:**
```
📦 OpenShift Operator Packages (redhat-operator-4.18)
==================================================
┌─────────────────────────────────────────────────────────┬────────────────────────────────┐
│ Package Name                                            │ Default Channel                │
├─────────────────────────────────────────────────────────┼────────────────────────────────┤
│ ptp-operator                                            │ stable                         │
│ cluster-logging                                         │ stable-6.3                     │
└─────────────────────────────────────────────────────────┴────────────────────────────────┘
📊 Summary: 2 packages found
```

### List Channels
Show all available channels for operators:

```bash
# List all channels
./oc-catalog.sh 4.18 redhat-operator channels

# List channels for specific packages
./oc-catalog.sh 4.18 redhat-operator channels cluster-logging
```

**Output:**
```
📺 OpenShift Operator Channels (redhat-operator-4.18)
==================================================
┌─────────────────────────────────────────────────────────┬───────────────────────────────────┐
│ Package Name                                            │ Channel                           │
├─────────────────────────────────────────────────────────┼───────────────────────────────────┤
│ cluster-logging                                         │ stable-6.1                        │
│ cluster-logging                                         │ stable-6.2                        │
│ cluster-logging                                         │ stable-6.3                        │
└─────────────────────────────────────────────────────────┴───────────────────────────────────┘
📊 Summary: 3 channels found
```

### List Versions
Show all available versions/bundles for operators:

```bash
# List all versions
./oc-catalog.sh 4.18 redhat-operator versions

# List versions for specific packages  
./oc-catalog.sh 4.18 redhat-operator versions ptp-operator
```

**Output:**
```
🔢 OpenShift Operator Versions (redhat-operator-4.18)
==================================================
┌─────────────────────────────────────────────────────────┬───────────────────────────────────────────────┐
│ Package Name                                            │ Version/Bundle                                │
├─────────────────────────────────────────────────────────┼───────────────────────────────────────────────┤
│ ptp-operator                                            │ ptp-operator.v4.18.0-202501230001             │
│ ptp-operator                                            │ ptp-operator.v4.18.0-202502250302             │
│ ptp-operator                                            │ ptp-operator.v4.18.0-202503121135             │
│ ptp-operator                                            │ ptp-operator.v4.18.0-202503211332             │
│ ptp-operator                                            │ ptp-operator.v4.18.0-202504021503             │
└─────────────────────────────────────────────────────────┴───────────────────────────────────────────────┘
📊 Summary: 5 versions found
```

## Examples

```bash
# Get help
./oc-catalog.sh

# List all packages in OpenShift 4.18 Red Hat catalog
./oc-catalog.sh 4.18 redhat-operator packages

# Check specific operators
./oc-catalog.sh 4.18 redhat-operator packages ptp-operator cluster-logging

# View channels for cluster logging
./oc-catalog.sh 4.18 redhat-operator channels cluster-logging

# See all versions of PTP operator
./oc-catalog.sh 4.18 redhat-operator versions ptp-operator

# Work with different OpenShift version
./oc-catalog.sh 4.17 redhat-operator packages

# Use certified operator catalog
./oc-catalog.sh 4.18 certified-operator packages

# Check certified operator (e.g., SR-IOV FEC operator)
./oc-catalog.sh 4.18 certified-operator packages sriov-fec
```

## Requirements

- `opm` tool installed and available in PATH
- `jq` for JSON processing
- Bash shell environment
- Internet connectivity to download catalog data

## Installation

1. Make the script executable:
   ```bash
   chmod +x oc-catalog.sh
   ```

2. Run the script:
   ```bash
   ./oc-catalog.sh
   ```

## Caching

The tool automatically caches catalog data in `/tmp/` and refreshes it every 2 hours to balance performance with data freshness.

Cache files are named: `/tmp/{catalog}-{version}.json`

## Supported Catalogs

- `redhat-operator`
- `certified-operator`  
- `community-operator`
- `redhat-marketplace`

---

*Built with ❤️ for OpenShift operators exploration*