# To capture signatures, you must run with `--remove-signatures=false`
datestamp=$(date +"%Y%m%d-%H-%M")
time oc-mirror --v2 --remove-signatures=false -c  v2_imageset-config_all_RHOperators_4.18.yml --workspace file:///data/oc-mirror/workdir/  --log-level info docker://quay.local.momolab.io:443/mirror 2>&1 | tee /data/oc-mirror/logs/oc-mirror-v2-logs-$datestamp.txt


