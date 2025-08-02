# Download managed clusters' kubeconfigs from the hub, add aliases

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

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       📄 ALIAS FILE CONTENT 📄
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Alias file created at: ~/kubeconfigs/oc-alias

File contents:
#oc alias for managed clusters
alias oc-sno130='oc --kubeconfig ~/kubeconfigs/sno130.kubeconfig'
alias oc-sno132='oc --kubeconfig ~/kubeconfigs/sno132.kubeconfig'
alias oc-sno133='oc --kubeconfig ~/kubeconfigs/sno133.kubeconfig'
alias oc-sno146='oc --kubeconfig ~/kubeconfigs/sno146.kubeconfig'
alias oc-sno171='oc --kubeconfig ~/kubeconfigs/sno171.kubeconfig'
#alias to switch to managed clusters
alias sno130='export KUBECONFIG=~/kubeconfigs/sno130.kubeconfig'
alias sno132='export KUBECONFIG=~/kubeconfigs/sno132.kubeconfig'
alias sno133='export KUBECONFIG=~/kubeconfigs/sno133.kubeconfig'
alias sno146='export KUBECONFIG=~/kubeconfigs/sno146.kubeconfig'
alias sno171='export KUBECONFIG=~/kubeconfigs/sno171.kubeconfig'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All kubeconfigs downloaded successfully!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 To activate the aliases, run:
   source ~/kubeconfigs/oc-alias

ℹ️ Available commands:
  • Use oc-<cluster> for kubectl commands
  • Use <cluster> to switch KUBECONFIG
```