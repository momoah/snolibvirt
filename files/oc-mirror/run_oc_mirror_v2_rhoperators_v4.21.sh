#!/bin/bash
set -o pipefail

# Usage:
#   ./run_oc_mirror_v2_4.21.sh              # all three phases
#   ./run_oc_mirror_v2_4.21.sh platform
#   ./run_oc_mirror_v2_4.21.sh redhat certified
#
# Phases:
#   platform  — OCP release payload + additionalImages. Signed.
#   redhat    — Red Hat operator catalog. Signed.
#   certified — certified + community catalogs. ISV images on
#               registry.connect.redhat.com publish no sigstore attachments,
#               so this phase runs with --remove-signatures=true.

CACHE=/data/oc-mirror/cache
AUTH=/data/oc-mirror/run_containers_0_auth.json
DEST=docker://quay.local.momolab.io:443/mirror
LOGDIR=/data/oc-mirror/logs
STAGE=~/files-disconnected-4.21
datestamp=$(date +"%Y%m%d-%H-%M")

COMMON="--v2 --image-timeout 30m0s --retry-times 20 --retry-delay 30s \
--parallel-images 2 --parallel-layers 2 \
--cache-dir ${CACHE} --authfile=${AUTH} --log-level info"

PHASES="${@:-platform redhat certified}"
mkdir -p "${STAGE}" "${LOGDIR}"

declare -A RC

run_phase() {
  local name=$1 config=$2 workdir=$3 extra=$4
  echo "=== Phase: ${name} ==="
  time oc-mirror ${COMMON} ${extra} \
    -c "${config}" \
    --workspace "file://${workdir}/" \
    "${DEST}" 2>&1 | tee "${LOGDIR}/oc-mirror-v2-${name}-${datestamp}.txt"
  RC[$name]=${PIPESTATUS[0]}
  echo "Phase ${name} rc=${RC[$name]}"
}

for p in ${PHASES}; do
  case $p in
    platform)
      run_phase platform v2_imageset-config_platform_4.21.yml \
        /data/oc-mirror/workdir-platform \
        "--secure-policy=true --remove-signatures=false"
      ;;
    redhat)
      run_phase redhat v2_imageset-config_redhat_operators_4.21.yml \
        /data/oc-mirror/workdir-redhat \
        "--secure-policy=true --remove-signatures=false"
      ;;
    certified)
      run_phase certified v2_imageset-config_certified_community_4.21.yml \
        /data/oc-mirror/workdir-certified \
        "--remove-signatures=true"
      ;;
    *)
      echo "Unknown phase: $p (expected: platform, redhat, certified)"
      exit 1
      ;;
  esac
done

# --- stage cluster-resources for playbook 01 ---
stage_phase() {
  local name=$1 workdir=$2 suffix=$3
  local src="${workdir}/working-dir/cluster-resources"
  local rc="${RC[$name]:-skipped}"
  if [ "${rc}" = "skipped" ]; then
    echo "Phase ${name} not run — leaving its staged resources untouched"
    return
  fi
  if [ ! -d "${src}" ]; then
    echo "WARNING: phase ${name} rc=${rc} and no cluster-resources dir — nothing to stage"
    return
  fi
  if [ "${rc}" -ne 0 ]; then
    echo "WARNING: phase ${name} rc=${rc} — staging anyway, but mirror content is INCOMPLETE."
    echo "         Review ${workdir}/working-dir/logs/mirroring_errors_*.txt"
  else
    echo "Staging ${name} resources"
  fi

  # oc-mirror names every IDMS/ITMS object idms-operator-0 / idms-release-0 /
  # itms-operator-0 / itms-release-0 regardless of which imageset produced it.
  # Applying all three phases' files would therefore overwrite the same objects
  # and only the last-applied phase would survive. Rename per phase.
  if [ -f "${src}/idms-oc-mirror.yaml" ]; then
    sed -E "s/^([[:space:]]*)name:[[:space:]]*idms-(operator|release)-0[[:space:]]*$/\1name: idms-\2-${name}/" \
      "${src}/idms-oc-mirror.yaml" > "${STAGE}/idms-oc-mirror${suffix}.yaml"
  fi
  if [ -f "${src}/itms-oc-mirror.yaml" ]; then
    sed -E "s/^([[:space:]]*)name:[[:space:]]*itms-(operator|release)-0[[:space:]]*$/\1name: itms-\2-${name}/" \
      "${src}/itms-oc-mirror.yaml" > "${STAGE}/itms-oc-mirror${suffix}.yaml"
  fi
  ls "${src}"/cs-*.yaml >/dev/null 2>&1 && cp "${src}"/cs-*.yaml "${STAGE}/"
}

# Rename Red Hat CatalogSource to 'redhat-operators' before staging.
if [ -d /data/oc-mirror/workdir-redhat/working-dir/cluster-resources ] && \
   [ "${RC[redhat]:-skipped}" != "skipped" ]; then
  sed -i 's/cs-redhat-operator-index-[^[:space:]]*/redhat-operators/g; s/cc-redhat-operator-index-[^[:space:]]*/redhat-operators/g' \
    /data/oc-mirror/workdir-redhat/working-dir/cluster-resources/*.yaml
fi

stage_phase platform  /data/oc-mirror/workdir-platform  -platform
stage_phase redhat    /data/oc-mirror/workdir-redhat    -redhat
stage_phase certified /data/oc-mirror/workdir-certified -certified

echo "=== Results ==="
for p in ${PHASES}; do echo "  ${p}: rc=${RC[$p]}"; done
echo "=== ${STAGE} ==="
ls -la "${STAGE}"
