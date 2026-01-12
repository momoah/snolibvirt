#!/bin/bash

# --- START: Recommended Changes ---
# 1. (CRITICAL) Delete the entire cache directory to force a truly clean run.
echo "INFO: Clearing oc-mirror cache directory..."
rm -rf /data/oc-mirror/cache
rm -fr /data/oc-mirror/workdir # not as important as the cache, you may choose to delete occassionally.

# 2. (RECOMMENDED) Remind user to match client versions.
echo "WARN: Ensure your 'oc' and 'oc-mirror' client versions match your cluster version (4.20.4)."
# https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/oc-mirror.rhel9.tar.gz
# https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux-amd64-rhel9.tar.gz

# --- END: Recommended Changes ---

datestamp=$(date +"%Y%m%d-%H-%M")

# This is your command with the required --log-level debug
time oc-mirror --v2 --image-timeout 20m0s --retry-times 15 --retry-delay 10s \
--secure-policy=true --remove-signatures=true --cache-dir /data/oc-mirror/cache \
--authfile=/data/oc-mirror/run_containers_0_auth.json \
-c v2_imageset-config_with_RHOperators_4.20.yml \
--workspace file:///data/oc-mirror/workdir/ \
--log-level info \
docker://quay.local.momolab.io:443/mirror 2>&1 | tee /data/oc-mirror/logs/oc-mirror-v2-logs-$datestamp.txt

# This part of your script is fine
sed -i 's/cs-redhat-operator-index-[^[:space:]]*/redhat-operators/g; s/cc-redhat-operator-index-[^[:space:]]*/redhat-operators/g' /data/oc-mirror/workdir/working-dir/cluster-resources/*.yaml

