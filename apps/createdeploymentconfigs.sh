#!/bin/bash

images=(
  "registry.redhat.io/odf4/odf-csi-addons-operator-bundle@sha256:fdd5486cc8d3a6f7ba8099d2319e0369a124ff78c4829037e392b989c6a80c25"
  "registry.redhat.io/openshift4/ose-csi-node-driver-registrar@sha256:6f0897ea75f6f081ef4cb64941d5f304c0cc0255f30e1eb990ab00cc464cdafe"
  "registry.redhat.io/rhacm2/memcached-exporter-rhel9@sha256:cd384186664cd3e018b53727d4b368cdb7e8890e698e15da73585a570562da44"
  "registry.redhat.io/odf4/odf-cosi-sidecar-rhel9@sha256:6a7b67ed227ed56833d5c02aec689fd5778a70494b31a36a358aaf278e7c2d2c"
  "registry.redhat.io/openshift4/ose-csi-external-provisioner@sha256:c5173e30b2cb85b3035463dc22be7a131ce249232a86533c6ac986f2d91ec25b"
  "registry.redhat.io/rhacm2/acm-prometheus-rhel9@sha256:c125800c1ce5a526b8f9c36ecb1e6440a40663baf43cbb655e4bdfe1cdba5eb8"
  "registry.redhat.io/rhacm2/acm-grafana-rhel9@sha256:4a76b2851848219e9d1ade66d5d79dbd69c319a31bf3c8dc86bac6aff928c773"
  "registry.redhat.io/rhacm2/node-exporter-rhel9@sha256:cb2545a4e8f825ecede60700ff33817d3a4eadd248b52c47150ff9fd072e30b2"
  "registry.redhat.io/openshift4/ose-csi-livenessprobe@sha256:b38f0bcb150c4d4030e77e84e04a2a7ab420a2f8fe06434260a53d33ac0e51f9"
  "registry.redhat.io/rhacm2/console-rhel9@sha256:581b9c3bc5d7c7184cda1ebb348bc7a0161247f03df1ac1a1abec22d3c60e6bf"
  "registry.redhat.io/ansible-automation-platform-25/platform-resource-runner-rhel8@sha256:8a09a5b616813400c74a325c45d33adde9a4cafa678e87ee2ca1ab6ddf19b7a7"
  "registry.redhat.io/rhacm2/acm-prometheus-config-reloader-rhel9@sha256:1f8c81a8c64cb27251a22ffb648628a74643ab23dbc55dde8936b1363af692fc"
  "registry.redhat.io/rhacm2/memcached-rhel9@sha256:5dac495aa94759fa7ae28127d827ec5f985dd234cdb85e4fae6802501eb07321"
  "registry.redhat.io/ansible-automation-platform-25/lightspeed-rhel8@sha256:5913161632b74ffc852e09cf0b80eb3f912bccadcf1bfefa09a797fc08154f92"
  "registry.redhat.io/odf4/ocs-client-rhel9-operator@sha256:fea8bbe98905816a3e8c3b31254f64ae926a8006832bd2d11836a06d59db4d19"
  "registry.redhat.io/ansible-automation-platform-25/eda-controller-rhel8-operator@sha256:5cff86c7c98980d0fb29b3dd461317fbf6bf3704a59e8f36b60f6d0e0db59715"
  "registry.redhat.io/rhacm2/acm-governance-policy-framework-addon-rhel9@sha256:8a1095e733cb761f6aa3a5ec4b20c68ca21843154eb9c9c987811b6f024b6b2e"
  "registry.redhat.io/odf4/mcg-rhel9-operator@sha256:8f78571d6e847085cc2aaf82df85a300a9b43fe3e8931054cc29fde80dc3c8fd"
  "registry.redhat.io/rhacm2/prometheus-rhel9@sha256:6e751a4fd3e4889525b6e37d0fedf72edc26d8a72782da8b70cb6c79a9bf5f1f"
  "registry.redhat.io/rhacm2/prometheus-alertmanager-rhel9@sha256:421a3415832cf34aae00e15c522ec414ae2773e1dcf4875d65a106febf303739"
  "registry.redhat.io/ansible-automation-platform/platform-operator-bundle@sha256:6446c318c217db099973ad311718841e2fd60ffce2d93a38d3df45b1cce9592b"
  "registry.redhat.io/rhacm2/cert-policy-controller-rhel9@sha256:214ee2bea22cc709b4c826b3cef05c87f1007cdcdffd870bfbe52bb61fabe0b7"
  "registry.redhat.io/odf4/odf-csi-addons-rhel9-operator@sha256:f302bf98e7c53786d0c3d338a07226078733b3ad6f23e18e0986affb1cbcf622"
  "registry.redhat.io/rhacm2/grafana-dashboard-loader-rhel9@sha256:5755502c3686244fd4da2051e2439f833913a69b285c1c61a80b51fd6a0ddb9b"
  "registry.redhat.io/odf4/ocs-operator-bundle@sha256:fc28f0d50a45643fc3cb26068218b2c3a561ad0840b2b3de8225d41b88feb164"
  "registry.redhat.io/rhacm2/acm-must-gather-rhel9@sha256:397c76f84709929b4252d67fe26e1fb1696a09153f162e3bc8d8978f35dec378"
  "registry.redhat.io/odf4/odf-operator-bundle@sha256:132315e43420ec234902175bfdd8241e340e760bcedbc16e02f19277dacc506f"
  "registry.redhat.io/ansible-automation-platform-25/ee-minimal-rhel8@sha256:c97285c6af1ebbb0e6aac3bcdad95ed5fc003998643d31038df5f0ddb874a96a"
  "registry.redhat.io/odf4/odr-hub-operator-bundle@sha256:aa170ef0a71b080233c65709ad1f72dbee2df5abc21776b2e1dce7c95e034c44"
  "registry.redhat.io/openshift4/ose-configmap-reloader-rhel9@sha256:1e369112bcf3d350fffef84225b2f9468c8ae38b29e5f7047475fa8ff97da5c9"
  "registry.redhat.io/rhacm2/multicluster-operators-channel-rhel9@sha256:f938de67bfad03671557d6519f7cd86b4de7d5171e9c6ff9fb339589db5689ec"
  "registry.redhat.io/rhacm2/insights-client-rhel9@sha256:7428fe2079167eebf80ec91092ea6297b92224bbcaa47281c352bad6789bd717"
  "registry.redhat.io/odf4/ocs-rhel9-operator@sha256:36e3cf061c8a5871807276f14c7b4d07a3a53572e5e0d665e643e381f22be364"
  "registry.redhat.io/openshift4/ose-csi-external-snapshotter-rhel8@sha256:cbba9ded297a31172780b2cac81585743ae68244ae665dca8ea5af33b3f821d7"
  "registry.redhat.io/ansible-automation-platform-25/eda-controller-ui-rhel8@sha256:d39fcd5d337e2c832f476559dad5c411dead7073d3e4ec3bac117b432280ebff"
  "registry.redhat.io/odf4/ocs-client-console-rhel9@sha256:f6f9562f9a27e196507c78a0d1854200390f192c840bfdf68e6d1d29e4bd5e7f"
  "registry.redhat.io/ansible-automation-platform-25/lightspeed-rhel8-operator@sha256:b4ccea42c731edb7de878e0620e0fc7bc06bd0ab672be2aadf549f2697402456"
  "registry.redhat.io/redhat/redhat-operator-index:v4.14"
  "registry.redhat.io/ansible-automation-platform-25/hub-rhel8-operator@sha256:a465a6656ef2927b058f29b50a71b2cecb16c459743b24157b4875dc4665c654"
  "registry.redhat.io/openshift4/ose-csi-external-resizer@sha256:433184a73a547e3eb8253711667de56f1583946ee7dfe0c74b87d4deb56da64c"
  "registry.redhat.io/rhacm2/kube-state-metrics-rhel9@sha256:5a4949c267df07a8bf37828f9cea8adb8b480b8a75fa813cff573f46676607d5"
  "registry.redhat.io/rhbk/keycloak-operator-bundle@sha256:dab43f78c3ef5029cf01f2109e1267282a8193c92782e99d5a13b4125347ba12"
  "registry.redhat.io/ansible-automation-platform-25/controller-rhel8-operator@sha256:d440f5ce3b88f99acb55555ab176799c2e3e1b2ee3c3ff07550414cbd0d4fd0e"
  "registry.redhat.io/openshift4/ose-csi-node-driver-registrar@sha256:08ac4d7cfd5b1ccacd8bdf50d53378e879e35d10aabc0e6f63db64c46421a442"
  "registry.redhat.io/rhacm2/acm-volsync-addon-controller-rhel9@sha256:20d8ef72e3c5b36d599f1dfc563021a8b2c9ea496df77cbc7090339f4dd71e66"
  "registry.redhat.io/odf4/mcg-cli-rhel9@sha256:3f02b6758d3aef7726ef4777cc98fbd053a61a3520ea20cf71b4c9c6bfa3c27c"
  "registry.redhat.io/openshift4/ose-csi-external-provisioner@sha256:ef440f1a0a54ab1ea4bbf78473eb86eba66f149bc1fc4c67a40a8b2100c26da5"
  "registry.redhat.io/odf4/odr-rhel9-operator@sha256:372f9d7a9e805f92d8207444237de36ae36907830d99c3d80fbb169e710e8b90"
  "registry.redhat.io/rhacm2/cluster-backup-rhel9-operator@sha256:ceec1e5e966002fd1b96ff934869b0235b4b7135565f24fcb9d63a994ea71c41"
  "registry.redhat.io/ansible-automation-platform-25/gateway-proxy-rhel8@sha256:54b22df108dd0d37fd1e38725e46b7db5f0116a1b334b9d8468f07aa74348290"
  "registry.redhat.io/ubi8/ubi@sha256:881aaf5fa0d1f85925a1b9668a1fc7f850a11ca30fd3e37ea194db4edff892a5"
  "registry.redhat.io/odf4/mcg-operator-bundle@sha256:5d5d123fa5e38ab5a9871b9d13d319a1d2cdb3465419eb5158baab9bc185fd80"
  "registry.redhat.io/redhat/certified-operator-index:v4.14"
  "registry.redhat.io/rhacm2/governance-policy-propagator-rhel9@sha256:6c4f1047698d84e0d8e8722674f209693f74f56a70b24719bddb9e596c8b3ed9"
  "registry.redhat.io/lvms4/lvms-rhel9-operator@sha256:3fc7b044c45638fc75c6286259e758ad5cdfd80cc19b1eda7c7890f9a2cba28e"
  "registry.redhat.io/odf4/ocs-client-operator-bundle@sha256:e319ab13c8ddeac7a167e9a1dd264a407d9b1ca4aa1e74a084a251391170aea8"
  "registry.redhat.io/rhacm2/multicluster-operators-application-rhel9@sha256:be5fbfc3bda9883cf85399f3cbcea855975abce8431208e03c548b078d4df4f9"
  "registry.redhat.io/openshift4/ose-oauth-proxy@sha256:8ce44de8c683f198bf24ba36cd17e89708153d11f5b42c0a27e77f8fdb233551"
  "registry.redhat.io/rhacm2/submariner-addon-rhel9@sha256:4e2cc8c58c8f095ad35aa3e9a2c4c3069b9bc4bc90ee73115dcccce0a08f80fc"
  "registry.redhat.io/rhacm2/thanos-rhel9@sha256:4085b48a8d8964f8c429cedb9adda9b4c3e8e180946ce91bd7100a7156dfd2ef"
  "registry.redhat.io/openshift4/ose-csi-external-attacher-rhel8@sha256:708469f8dce333193da3029a43b16160e2fc859ed014b7cd143cf30d4f27b650"
  "registry.redhat.io/rhacm2/klusterlet-addon-controller-rhel9@sha256:3f8d742e2e1d1d880d7a3a261844b3ea707cff1db73114656517fa3ef98fed50"
  "registry.redhat.io/ansible-automation-platform-25/gateway-rhel8@sha256:ea543c06a97c2d1fe4efd36b6935e010e43288a3ff1f5d8206454cb97197f930"
  "registry.redhat.io/odf4/odf-multicluster-console-rhel9@sha256:bee5af95d19d2302aef0ba3ad2d714bfb8dbc08817843c3c6e2673c056e1afca"
  "registry.redhat.io/redhat/community-operator-index:v4.14"
  "registry.redhat.io/rhacm2/observatorium-rhel9-operator@sha256:f5a148b5bc3af8689118362fa50d02e37f85f4c4c7767cbb5ad287551d1c03f5"
  "registry.redhat.io/openshift4/ose-oauth-proxy@sha256:41762eda03298362d3f97e1fd0be4af429d22658b520f94023941655e062d1a1"
  "registry.redhat.io/rhacm2/acm-operator-bundle@sha256:08a132d3f16c10a0dc041de248d7092bf60ab559f462e67861df7875474f26e7"
  "registry.redhat.io/odf4/odf-must-gather-rhel9@sha256:1af11cebd4abc9ac822ddfca93bd0ee777e53a5db094ddba1e0b4bcc4a448e71"
  "registry.redhat.io/odf4/ocs-metrics-exporter-rhel9@sha256:e2d5f9bd3d927eaaec6df04e32ed781ce4566f93b4ba6a757f3888c54bcc57ce"
  "registry.redhat.io/ansible-automation-platform-25/eda-controller-rhel8@sha256:a0bc05446e1e75c62b69e89f2e532326f379b38a060e088c5655f284e5ad483d"
  "registry.redhat.io/rhel8/postgresql-12@sha256:7b5d76c6dde4561bbec01f46cbd728b17657c2a07b9776d2d7953601078ff2c4"
  "registry.redhat.io/rhacm2/multicluster-observability-rhel9-operator@sha256:091f616a387a55d8fb74f689c83c7d3a82937fceca277b198ef79ba4afc30128"
  "registry.redhat.io/rhacm2/insights-metrics-rhel9@sha256:3105ba390afdbb8e0c4fcf436d4729c56aa6fe0e4e4695344081a1fbef10879f"
  "registry.redhat.io/rhacm2/metrics-collector-rhel9@sha256:2fb68cb9deb93034153651edd6474f84e00aaaccb98e7f406c0052947ba3f106"
  "registry.redhat.io/odf4/odf-csi-addons-sidecar-rhel9@sha256:e9176f3de0f202a766e33ec345a4e1e7f7a89bb82b6da9684861709b6c0cced5"
  "registry.redhat.io/rhacm2/acm-search-v2-api-rhel9@sha256:73ff322f3febee62266029ee07a8f7df07e8b178462110340c9491394b978fb2"
  "registry.redhat.io/lvms4/lvms-operator-bundle@sha256:2883137948848c58e27e633efc3acd72d4d25c40780272d4671e44c9d8c7056a"
  "registry.redhat.io/odf4/rook-ceph-rhel9-operator@sha256:b921ec480ee900e7f754473ca57199ae2d81c194fcb2d3af7edbe7b767e2d63f"
  "registry.redhat.io/odf4/odf-rhel9-operator@sha256:8fd357df018f8cb618f9e06cc5b65a51846c831ab58e77ebd1da4f043f1ecabb"
  "registry.redhat.io/odf4/cephcsi-rhel9@sha256:52c02f54d5587b535567b8649cb5953ad46b202fbbbd3f10d115b88f6f726439"
  "registry.redhat.io/rhacm2/search-collector-rhel9@sha256:4e83d233c66a293a9b7f46fb1cac2c9e7fd85f2190fa0294207d680b464dd917"
  "registry.redhat.io/rhbk/keycloak-rhel9-operator@sha256:db68006c9508fa1ce42f7bc3c35afd7057eb407ab7d9f8933f8c2bac33b2eb7d"
  "registry.redhat.io/rhacm2/multicloud-integrations-rhel9@sha256:04d556334f378c8586f13e7783dfd5e4c59add577c253dde05a6603719b51780"
  "registry.redhat.io/odf4/odf-multicluster-operator-bundle@sha256:7537cb2be464052079c14458a7e4a48bf8fa410b0a8b80c3deccaca19008babd"
  "registry.redhat.io/ansible-automation-platform-25/platform-resource-rhel8-operator@sha256:1c89eb39aaab65edb4967db1a6087205cbbb2e739183b6d652c6bf81134f7f31"
  "registry.redhat.io/rhacm2/thanos-receive-controller-rhel9@sha256:361fdbed3010ab8198e7193ffe32c216430fd5effa85b4e5880a606493e1fe29"
  "registry.redhat.io/ansible-automation-platform-25/ee-supported-rhel8@sha256:f73e82a9fdc5f7b3ffe59d3ddc8948543535479c6a25205b1830a8ef5d0f9928"
  "registry.redhat.io/rhacm2/acm-governance-policy-addon-controller-rhel9@sha256:161a67c50941fb696b9e53d626131b2ebb3e6a7b2449ad789e56068c8620eb6d"
  "registry.redhat.io/rhacm2/multiclusterhub-rhel9@sha256:e8d0d6cf2465e2cf5e8efc9522f5a85a17163158262e41dcebd18c4e6f516011"
  "registry.redhat.io/openshift4/ose-csi-external-resizer@sha256:5cefc87a7eaf9daeeff2642fe842ce5954936c8634df6b4b12b71ddd8e669dca"
  "registry.redhat.io/rhacm2/acm-search-v2-rhel9@sha256:fc4044bc0af308cd3256a2b0f5052d9e4372ef34bf61879c30633b4879914e05"
  "registry.redhat.io/rhacm2/endpoint-monitoring-rhel9-operator@sha256:df08b0c930da41e31bb7dd927b3356b2d41c7b86ded0d6ec4525f0a040efbc78"
  "registry.redhat.io/rhacm2/observatorium-rhel9@sha256:1e0033700cfe1f96d691716408f4cfe68d01e01a7f3bb7693f7dd61981911ea4"
  "registry.redhat.io/rhacm2/config-policy-controller-rhel9@sha256:6dc0d9669f189edb6f4e882ffc7ca4ec24cc0f611da7425b97ffcc6292cf7662"
  "registry.redhat.io/rhacm2/kube-rbac-proxy-rhel9@sha256:5fbfb8fdb66a1837d57623a85788f5017eb4f75f41ec289ed4108e7c924bba0d"
  "registry.redhat.io/rhbk/keycloak-rhel9@sha256:1bdf400a95ed9245893473bef792db26a6a4f956a5a33f6f3283a752191f1cba"
  "registry.redhat.io/odf4/mcg-core-rhel9@sha256:6f2bffd01c0fb1af6dd36a936c98ae2acd7163c1f3fb0060bc58102546cead56"
  "registry.redhat.io/openshift4/ose-kube-rbac-proxy@sha256:c35940d233ba26a9e9acc625a21b6b95d093638f0b37699e0c059a3ed36863da"
  "registry.redhat.io/ansible-automation-platform-25/controller-rhel8@sha256:3e81f1a3d1119373104b44f078dd20a4826b11e9552418716c9ea70e1b513b63"
  "registry.redhat.io/odf4/odf-console-rhel9@sha256:4d7cf24a5ea73aa49352cf8252ef32ca79dcac3a6ef80ab91b00038b317447d9"
  "registry.redhat.io/rhceph/rhceph-7-rhel9@sha256:75bd8969ab3f86f2203a1ceb187876f44e54c9ee3b917518c4d696cf6cd88ce3"
  "registry.redhat.io/rhel9/postgresql-13@sha256:31c77c19480ab82cb33525d32419b68cf59daccf0b9936e88e8238e48a2d47e5"
  "registry.redhat.io/rhacm2/rbac-query-proxy-rhel9@sha256:4db3bc98281b804ffa6f3868e618d79df03d70630b3a0290722010835b45dadb"
  "registry.redhat.io/lvms4/lvms-must-gather-rhel9@sha256:c437a877398187ec1af10170618db62d4594aaf3832742ee4efa255a5c394df8"
  "registry.redhat.io/openshift4/ose-csi-external-snapshotter@sha256:362028779506af143ddc3e4c3660d25acacec025e9c6a79ef0ff234a2d68271b"
  "registry.redhat.io/ansible-automation-platform-25/hub-web-rhel8@sha256:b03b790fe8742a48e106892e7d1622c30c631a5fc96131685aabc96301500710"
  "registry.redhat.io/odf4/odf-multicluster-rhel9-operator@sha256:2cfae94354b8c6f47e819a23f35227795dbac3c029389f4580f08401af45a1ee"
  "registry.redhat.io/rhacm2/acm-cluster-permission-rhel9@sha256:47f377de3101726f4966c687f4c3a05b54d216dd78d98357b279aa19b5752e47"
  "registry.redhat.io/odf4/odr-cluster-operator-bundle@sha256:bbd9dafa7b01f12a9b2dd1c77c49ac9de99feb3586614106f3b11cf1d4eb45c2"
  "registry.redhat.io/openshift4/ose-kube-rbac-proxy@sha256:0c90e9a06033bdfb535acbb1bcd748813166bc7a9fe5a3746089b9e8b069d5c7"
  "registry.redhat.io/ansible-automation-platform-25/hub-rhel8@sha256:014eafa952362c2d226a157f0016b28e3eed181b80758be1f112d275d893c260"
  "registry.redhat.io/rhacm2/multicluster-operators-subscription-rhel9@sha256:885828e43912a6922f132dc05a82ded8b750f77ef9f9512a1f589fbb84049eb3"
  "registry.redhat.io/rhacm2/acm-search-indexer-rhel9@sha256:715e1f9a160933306c6551c8c5831b54b738882e90f60f43f126c245c0784eb3"
  "registry.redhat.io/ansible-automation-platform-25/gateway-rhel8-operator@sha256:8db9ed1f6767c04ddadd748fb6dd18e7a1b385c51921fb4599edbb6d42a26bdd"
  "registry.redhat.io/lvms4/topolvm-rhel9@sha256:5b77927d2cfde47d0a5ae04ecf768bcbf70a91a0682fb67b65e3ffaf78b77a04"
)

# Loop through the images and create a DeploymentConfig for each
for i in {1..247}; do
  cat <<EOF | oc apply -f -
apiVersion: apps.openshift.io/v1
kind: DeploymentConfig
metadata:
  name: app-$i
  labels:
    app: app-$i
spec:
  replicas: 1
  selector:
    app: app-$i
  template:
    metadata:
      labels:
        app: app-$i
    spec:
      containers:
      - name: app-$i-container
        image: ${images[$i-1]}  # Use the corresponding image from the array
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
  triggers:
  - type: ConfigChange
EOF
done
