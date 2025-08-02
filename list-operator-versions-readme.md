# List Operator Versions

```shell
# ./list-operator-versions.sh
❌ Missing required version parameter
🚀 Usage: ./list-operator-versions.sh <version> <number_of_versions>
  • number_of_versions is optional, default is 1
  • example: ./list-operator-versions.sh 4.18 5
  • example: ./list-operator-versions.sh 4.18


# ./list-operator-versions.sh 4.18 3
🔍 Extracting catalog files from:
  📋 registry.redhat.io/redhat/redhat-operator-index:v4.18
  📋 registry.redhat.io/redhat/certified-operator-index:v4.18

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         🎯 OPERATOR VERSIONS REPORT 🎯
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Red Hat Operators:

📦 sriov-network-operator (latest 3 versions)
  🏷️ v4.18.0-202506230505
  🏷️ v4.18.0-202507081733
  🏷️ v4.18.0-202507211933

📦 lifecycle-agent (latest 3 versions)
  🏷️ v4.18.0

📦 redhat-oadp-operator (latest 3 versions)
  🏷️ v1.4.3
  🏷️ v1.4.4
  🏷️ v1.4.5

📦 local-storage-operator (latest 3 versions)
  🏷️ v4.18.0-202506241202
  🏷️ v4.18.0-202507081733
  🏷️ v4.18.0-202507211933

📦 ptp-operator (latest 3 versions)
  🏷️ v4.18.0-202506260833
  🏷️ v4.18.0-202507081733
  🏷️ v4.18.0-202507211933

📦 cluster-logging (latest 3 versions)
  🏷️ v6.2.2
  🏷️ v6.2.3
  🏷️ v6.3.0

🔵 Certified Operators:

📦 sriov-fec (latest 3 versions)
  🏷️ v2.7.2
  🏷️ v2.8.0
  🏷️ v2.9.0


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Report completed successfully! 🚀
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```