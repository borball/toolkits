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
./oc-catalog.sh [options] <command> [packages...]
```

### Options

- **-v, --version** - OpenShift version (default: 4.18)
- **-c, --catalog** - Catalog name (default: redhat-operator)
- **-h, --help** - Show help message

### Commands

- **command** - Action to perform: `packages`, `channels`, or `versions`
- **packages** - Optional: specific package names to filter results

## Commands

### List Packages
Show operator packages and their default channels:

```bash
# List all packages (using defaults: 4.18, redhat-operator)
./oc-catalog.sh packages

# List specific packages
./oc-catalog.sh packages ptp-operator cluster-logging

# Use different catalog
./oc-catalog.sh -c certified-operator packages
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
# List all channels (using defaults)
./oc-catalog.sh channels

# List channels for specific packages
./oc-catalog.sh channels cluster-logging

# Use different version
./oc-catalog.sh -v 4.17 channels cluster-logging
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
# List all versions (using defaults)
./oc-catalog.sh versions

# List versions for specific packages  
./oc-catalog.sh versions ptp-operator

# Use different catalog and version
./oc-catalog.sh -v 4.17 -c redhat-operator versions ptp-operator
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

**Certified Operator Example:**
```bash
# List versions for certified operator
./oc-catalog.sh -c certified-operator versions sriov-fec
```

**Output:**
```
🔢 OpenShift Operator Versions (certified-operator-4.18)
==================================================
┌─────────────────────────────────────────────────────────┬───────────────────────────────────────────────┐
│ Package Name                                            │ Version/Bundle                                │
├─────────────────────────────────────────────────────────┼───────────────────────────────────────────────┤
│ sriov-fec                                               │ sriov-fec.v2.10.0                             │
│ sriov-fec                                               │ sriov-fec.v2.11.0                             │
│ sriov-fec                                               │ sriov-fec.v2.11.1                             │
│ sriov-fec                                               │ sriov-fec.v2.7.1                              │
│ sriov-fec                                               │ sriov-fec.v2.7.2                              │
│ sriov-fec                                               │ sriov-fec.v2.8.0                              │
│ sriov-fec                                               │ sriov-fec.v2.9.0                              │
└─────────────────────────────────────────────────────────┴───────────────────────────────────────────────┘
📊 Summary: 7 versions found
```

## Examples

```bash
# Get help
./oc-catalog.sh --help

# List all packages (using defaults: 4.18, redhat-operator)
./oc-catalog.sh packages

# Check specific operators
./oc-catalog.sh packages ptp-operator cluster-logging

# View channels for cluster logging
./oc-catalog.sh channels cluster-logging

# See all versions of PTP operator
./oc-catalog.sh versions ptp-operator

# Work with different OpenShift version
./oc-catalog.sh -v 4.17 packages

# Use certified operator catalog
./oc-catalog.sh -c certified-operator packages

# Check certified operator (e.g., SR-IOV FEC operator)
./oc-catalog.sh -c certified-operator packages sriov-fec

# Combine options
./oc-catalog.sh -v 4.17 -c certified-operator versions sriov-fec
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