# Build SNOs on Libvirt
Inspired by Michele Baldesari's https://github.com/mbaldessari/kvm-sno.git

## DNS Entries

This mainly uses bind/named, the entries uses look like this:

```bash
# /var/named/local.momolab.io.db
; SNO 1
sno1         IN A       192.168.1.231
*.apps.sno1       CNAME      sno1
api.sno1       CNAME      sno1
api-int.sno1       CNAME      sno1

; SNO 2
sno2         IN A       192.168.1.232
*.apps.sno2       CNAME      sno2
api.sno2       CNAME      sno2
api-int.sno2       CNAME      sno2

; SNO 3
sno3         IN A       192.168.1.233
*.apps.sno3       CNAME      sno3
api.sno3       CNAME      sno3
api-int.sno3       CNAME      sno3

# /var/named/192.168.1.db
;PTR Record IP address to HostName
231      IN  PTR     sno1.local.momolab.io.
232      IN  PTR     sno2.local.momolab.io.
233      IN  PTR     sno3.local.momolab.io.

```

# Pre-Run
```bash
sudo dnf install python3-bcrypt-3.2.2
ansible-galaxy collection install -r requirements.yml
```

oc-mirror version 1:
```bash
oc mirror --config=./imageset-config.yaml docker://registry.local.momolab.io:8443
```

oc-mirror version 2:
```bash
oc-mirror --v2 -c imageset-config-ocmirrorv2-v4.16.yaml  --loglevel debug   --workspace file:////data/oc-mirror/workdir/   docker://registry.local.momolab.io:8443/mirror 2>&1 | tee oc-mirror-v2-logs-202400904-debug.txt 
```
