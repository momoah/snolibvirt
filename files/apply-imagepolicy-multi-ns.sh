#!/bin/bash

# List of target namespaces
namespaces=("default" "dev" "test" "prod")

# Path to the base YAML file
base_yaml="base-imagepolicy.yaml"

# Loop through each namespace
for ns in "${namespaces[@]}"; do
  echo "Applying ImagePolicy to namespace: $ns"
  
  # Create a temp YAML with updated namespace
  yq eval ".metadata.namespace = \"$ns\"" "$base_yaml" | oc apply -f -
done
