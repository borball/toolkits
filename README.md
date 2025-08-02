# Toolkits

## List Operator Versions

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

## Download managed clusters' kubeconfigs from the hub, add aliases:

```shell

# ./download-mcl-kubeconfigs-alias.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🔗 MANAGED CLUSTER KUBECONFIGS DOWNLOADER 🔗
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ️ Discovering managed clusters...
✅ Found 5 managed clusters

⬇️ Starting kubeconfig downloads...

🔗 Processing cluster: sno130
  ✅ Downloaded kubeconfig for sno130
  ⚙️ Created oc alias: oc-sno130
🔗 Processing cluster: sno132
  ✅ Downloaded kubeconfig for sno132
  ⚙️ Created oc alias: oc-sno132
🔗 Processing cluster: sno133
  ✅ Downloaded kubeconfig for sno133
  ⚙️ Created oc alias: oc-sno133
🔗 Processing cluster: sno146
  ✅ Downloaded kubeconfig for sno146
  ⚙️ Created oc alias: oc-sno146
🔗 Processing cluster: sno171
  ✅ Downloaded kubeconfig for sno171
  ⚙️ Created oc alias: oc-sno171

⚙️ Creating cluster switch aliases...
⚙️ Created switch alias: sno130
⚙️ Created switch alias: sno132
⚙️ Created switch alias: sno133
⚙️ Created switch alias: sno146
⚙️ Created switch alias: sno171

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       📄 ALIAS FILE CONTENT 📄
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Alias file created at: /etc/kubeconfigs/oc-alias

File contents:
#oc alias for managed clusters
alias oc-sno130='oc --kubeconfig /etc/kubeconfigs/sno130.kubeconfig'
alias oc-sno132='oc --kubeconfig /etc/kubeconfigs/sno132.kubeconfig'
alias oc-sno133='oc --kubeconfig /etc/kubeconfigs/sno133.kubeconfig'
alias oc-sno146='oc --kubeconfig /etc/kubeconfigs/sno146.kubeconfig'
alias oc-sno171='oc --kubeconfig /etc/kubeconfigs/sno171.kubeconfig'
#alias to switch to managed clusters
alias sno130='export KUBECONFIG=/etc/kubeconfigs/sno130.kubeconfig'
alias sno132='export KUBECONFIG=/etc/kubeconfigs/sno132.kubeconfig'
alias sno133='export KUBECONFIG=/etc/kubeconfigs/sno133.kubeconfig'
alias sno146='export KUBECONFIG=/etc/kubeconfigs/sno146.kubeconfig'
alias sno171='export KUBECONFIG=/etc/kubeconfigs/sno171.kubeconfig'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All kubeconfigs downloaded successfully!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 To activate the aliases, run:
   source /etc/kubeconfigs/oc-alias

ℹ️ Available commands:
  • Use oc-<cluster> for kubectl commands
  • Use <cluster> to switch KUBECONFIG
```