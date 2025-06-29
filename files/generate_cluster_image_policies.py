# looks up files generated by oc-mirror v2, and creates a ClusterImagePolicy for each mirror/source pair.
# Run using python generate_cluster_image_policies.py
import os
import yaml

# Directory where oc-mirror YAML files are stored
input_dir = "files/disconnected/4.18/" # Change to match what you need.
output_file = "ClusterImagePolicies.yaml"

# Sigstore public key
sigstore_key = """LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FnOEFNSUlDQ2dLQ0FnRUEwQVN5dUgyVExXdkJVcVBIWjRJcAo3NWc3RW5jQmtnUUhkSm5qenhBVzVLUVRNaC9zaUJvQi9Cb1NydGlQTXduQ2hiVENuUU9JUWVadURpRm5odUo3Ck0vRDNiN0pvWDBtMTIzTmNDU242N21BZGpCYTZCZzZrdWtaZ0NQNFpVWmVFU2FqV1gvRWp5bEZjUkZPWFc1N3AKUkRDRU40MkovallsVnF0K2c5K0dya2VyOFN6ODZIM2wwdGJxT2RqYnovVnhIWWh3RjBjdFVNSHN5VlJEcTJRUAp0cXpOWGxtbE1oUy9Qb0ZyNlI0dS83SENuL0srTGVnY08yZkFGT2I0MEt2S1NLS1ZENmxld1VaRXJob3AxQ2dKClhqRHRHbW1POWRHTUY3MW1mNkhFZmFLU2R5K0VFNmlTRjJBMlZ2OVFoQmF3TWlxMmtPekVpTGc0bkFkSlQ4d2cKWnJNQW1QQ3FHSXNYTkdaNC9RK1lUd3dsY2UzZ2xxYjVMOXRmTm96RWRTUjlOODVERVNmUUxRRWRZM0NhbHdLTQpCVDFPRWhFWDF3SFJDVTRkck1PZWo2Qk5XMFZ0c2NHdEhtQ3JzNzRqUGV6aHdOVDh5cGt5UytUMHpUNFRzeTZmClZYa0o4WVNIeWVuU3pNQjJPcDJidnNFM2dyWStzNzRXaEc5VUlBNkRCeGNUaWUxNU5Tekt3Znphb05XT0RjTEYKcDdCWThhYUhFMk1xRnhZRlgrSWJqcGtRUmZhZVFRc291REZkQ2tYRUZWZlBwYkQyZGs2RmxlYU1UUHV5eHRJVApnalZFdEdRSzJxR0NGR2lRSEZkNGhmVitlQ0E2M0pybzF6MHpvQk01QmJJSVEzK2VWRnd0M0FsWnA1VVZ3cjZkCnNlY3FraS95cm12M1kwZHFaOVZPbjNVQ0F3RUFBUT09Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQ=="""

# Collect mirror-source pairs
pairs = []

for fname in os.listdir(input_dir):
    if fname.endswith("oc-mirror.yaml"):
        with open(os.path.join(input_dir, fname)) as f:
            docs = list(yaml.safe_load_all(f))
            for doc in docs:
                if not doc or "spec" not in doc:
                    continue
                key = "imageDigestMirrors" if "imageDigestMirrors" in doc["spec"] else "imageTagMirrors"
                for entry in doc["spec"].get(key, []):
                    source = entry["source"]
                    for mirror in entry["mirrors"]:
                        pairs.append((mirror, source))

# Deduplicate
unique_pairs = sorted(set(pairs))

# Generate policy YAMLs
policies = []
for mirror, source in unique_pairs:
    name = mirror.split("/")[-1].replace(".", "-").replace(":", "-")
    policy = {
        "apiVersion": "config.openshift.io/v1alpha1",
        "kind": "ClusterImagePolicy",
        "metadata": {"name": f"enforce-signatures-quay-mirror-{name}"},
        "spec": {
            "scopes": [mirror],
            "policy": {
                "type": "sigstore",
                "rootOfTrust": {
                    "policyType": "PublicKey",
                    "publicKey": {
                        "keyData": sigstore_key
                    }
                },
                "signedIdentity": {
                    "type": "RemapIdentity",
                    "matchPolicy": "RemapIdentity",
                    "remapIdentity": {
                        "prefix": mirror,
                        "signedPrefix": source
                    }
                }    
            }
        }
    }
    policies.append(policy)

# Output to file
with open(output_file, "w") as f:
     f.write("# This was generated by https://github.com/momoah/snolibvirt/blob/main/files/generate_cluster_image_policies.py\n")
    f.write("---\n" + "\n---\n".join(yaml.dump(p, sort_keys=False) for p in policies))

print(f"Generated {len(policies)} ClusterImagePolicy objects in {output_file}")
