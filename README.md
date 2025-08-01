#Toolkits

## List Operator Versions

```shell
# ./list-operator-versions.sh
Usage: ./list-operator-versions.sh <version> <number_of_versions>
number_of_versions is optional, default is 1
example: ./list-operator-versions.sh 4.18 5
example: ./list-operator-versions.sh 4.14


./list-operator-versions.sh 4.14 3
Extracting catalog files from registry.redhat.io/redhat/redhat-operator-index:v4.14 and registry.redhat.io/redhat/certified-operator-index:v4.14...
--------------------------------
sriov-network-operator latest 3 versions:
v4.14.0-202504281009
v4.14.0-202506121138
v4.14.0-202507221336

lifecycle-agent latest 3 versions:
v4.14.1
v4.14.2
v4.14.3

redhat-oadp-operator latest 3 versions:
v1.4.3
v1.4.4
v1.4.5

local-storage-operator latest 3 versions:
v4.14.0-202504220036
v4.14.0-202506112307
v4.14.0-202507221336

ptp-operator latest 3 versions:
v4.14.0-202504281009
v4.14.0-202506112307
v4.14.0-202507221336

cluster-logging latest 3 versions:
v6.0.7
v6.0.8
v6.0.9

sriov-fec latest 3 versions:
v2.7.2
v2.8.0
v2.9.0

--------------------------------
# ./list-operator-versions.sh 4.18 5
Extracting catalog files from registry.redhat.io/redhat/redhat-operator-index:v4.18 and registry.redhat.io/redhat/certified-operator-index:v4.18...
--------------------------------
sriov-network-operator latest 5 versions:
v4.18.0-202505260733
v4.18.0-202506092139
v4.18.0-202506230505
v4.18.0-202507081733
v4.18.0-202507211933

lifecycle-agent latest 5 versions:
v4.18.0

redhat-oadp-operator latest 5 versions:
v1.4.1
v1.4.2
v1.4.3
v1.4.4
v1.4.5

local-storage-operator latest 5 versions:
v4.18.0-202505271635
v4.18.0-202506092139
v4.18.0-202506241202
v4.18.0-202507081733
v4.18.0-202507211933

ptp-operator latest 5 versions:
v4.18.0-202505291136
v4.18.0-202506121732
v4.18.0-202506260833
v4.18.0-202507081733
v4.18.0-202507211933

cluster-logging latest 5 versions:
v6.2.0
v6.2.1
v6.2.2
v6.2.3
v6.3.0

sriov-fec latest 5 versions:
v2.11.1
v2.7.1
v2.7.2
v2.8.0
v2.9.0

--------------------------------
```