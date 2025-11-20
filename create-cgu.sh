#!/bin/bash
# script to create CGU
# is no policy name provided, the script will create a CGU with the all non-compliant policies for the cluster

create(){
cat <<EOF | oc apply -f -

apiVersion: ran.openshift.io/v1alpha1
kind: ClusterGroupUpgrade
metadata:
  name: $cgu_name
  namespace: ztp-install
spec:
  backup: false
  clusters:
  - $spoke
  enable: true
  managedPolicies:
$managed_policies_yaml
  preCaching: false
  remediationStrategy:
    maxConcurrency: 1
    timeout: 240
EOF
}

usage(){
    echo "Create a ClusterGroupUpgrade (CGU) for remediating non-compliant policies"
    echo
    echo "Usage: create-cgu.sh <cluster> [policy1] [policy2] [policy3] ..."
    echo
    echo "Options:"
    echo "  <cluster>          Target cluster name (required)"
    echo "  [policy1...]       Policy names (optional)"
    echo "                     - If omitted: auto-fetches all non-compliant policies sorted by wave annotation"
    echo "                     - Can be provided with or without cluster namespace prefix (e.g., ztp-vdu.)"
    echo "                     - Prefixes matching 'ztp-*' are automatically stripped to match parent policies"
    echo
    echo "Examples:"
    echo "  Auto-fetch all non-compliant policies:"
    echo "    create-cgu.sh sno171"
    echo
    echo "  Manual with cluster namespace prefix:"
    echo "    create-cgu.sh sno171 ztp-vdu.vdu2-4.20-p1d1-reduce ztp-vdu.vdu2-4.20-p1d1-ptp-sub"
    echo
    echo "  Manual with parent policy names:"
    echo "    create-cgu.sh sno171 vdu2-4.20-p1d1-reduce vdu2-4.20-p1d1-ptp-sub"
    echo
    echo "Features:"
    echo "  - Automatically sorts policies by ran.openshift.io/ztp-deploy-wave annotation"
    echo "  - Generates unique CGU names with timestamps"
    echo "  - Strips cluster namespace prefixes (ztp-*) to reference parent policies"
}

if [ $# -lt 1 ]
then
  usage
  exit
fi

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
  usage
  exit
fi

spoke=$1
shift  # Remove the first argument (cluster name)
policies=("$@")  # Store all remaining arguments as policies array

# Track if policies were auto-fetched (will need prefix removal) or manually provided (already clean)
auto_fetched=false
if [ ${#policies[@]} -eq 0 ]; then
    # Read non-compliant policies and sort by ztp-deploy-wave annotation
    # Using jq to filter and sort since kubectl --sort-by doesn't work with JSONPath filters
    policies=($(oc get policy -n $spoke -o json | jq -r '.items[] | select(.status.compliant == "NonCompliant") | {wave: (.metadata.annotations."ran.openshift.io/ztp-deploy-wave" // "999" | tonumber), name: .metadata.name} | "\(.wave)|\(.name)"' | sort -n -t'|' -k1 | cut -d'|' -f2))
    echo "Found ${#policies[@]} non-compliant policies for cluster $spoke" >&2
    auto_fetched=true
fi

# Create CGU name based on cluster and number of policies
if [ ${#policies[@]} -eq 1 ]; then
    # For single policy, use timestamp to avoid long names
    cgu_name="$spoke-single-policy-$(date +%s)"
else
    cgu_name="$spoke-multi-policy-$(date +%s)"
fi

# Build the managedPolicies YAML array
managed_policies_yaml=""
for policy in "${policies[@]}"; do
    # Remove known cluster namespace prefixes (e.g., ztp-vdu., ztp-global-hub., etc.)
    # Only strip if the policy starts with a known pattern
    policy_name="$policy"
    if [[ "$policy" == ztp-*.* ]]; then
        # Strip ztp-* prefix pattern (e.g., ztp-vdu., ztp-global-hub.)
        policy_name="${policy#*.}"
        echo "Policy name transformation: $policy -> $policy_name" >&2
    fi
    managed_policies_yaml+="  - $policy_name"$'\n'
done
# Remove the trailing newline
managed_policies_yaml=${managed_policies_yaml%$'\n'}

create
