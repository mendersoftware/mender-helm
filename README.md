# Mender

[Mender](https://mender.io/) is a robust and secure way to update all your software and deploy your IoT devices at scale with support for customization.

## TL;DR;

Using `helm`:

```bash
helm install mender ./mender
```

## Introduction

This chart bootstraps a [Mender](https://mender.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm >= 3.7.0

## External services required

This Helm chart does not install the following external services and dependencies which are required to run Mender:

- MinIO

### Installing mongodb

MongoDB is integrated as a sub-chart deployment: you can enable it with
the following settings:

```
mongodb:
  enabled: true

# or via the --set argument:
--set="mongodb.enabled=true"
```

You can customize it by following the [provider's](https://artifacthub.io/packages/helm/bitnami/mongodb)
specifications.
It's recommended to use an external deployment in Production.

### Installing MinIO

You can install MinIO using the official MinIO Helm chart using `helm`:

```bash
cat >minio-operator.yml <<EOF
tenants: {}
EOF

helm repo add minio https://operator.min.io/
helm repo update
helm install minio-operator minio/minio-operator --version 4.1.7 -f minio-operator.yml

export MINIO_ACCESS_KEY=$(pwgen 32 1)
export MINIO_SECRET_KEY=$(pwgen 32 1)

cat >minio.yml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: minio-creds-secret
type: Opaque
data:
  accesskey: $(echo -n $MINIO_ACCESS_KEY | base64)
  secretkey: $(echo -n $MINIO_SECRET_KEY | base64)
---
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: minio
  labels:
    app: minio
spec:
  image: minio/minio:RELEASE.2021-06-17T00-10-46Z
  credsSecret:
    name: minio-creds-secret
  pools:
    - servers: 2
      volumesPerServer: 2
      volumeClaimTemplate:
        metadata:
          name: data
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 10Gi
          storageClassName: "standard"
  mountPath: /export
  requestAutoCert: false
EOF

kubectl apply -f minio.yml
```

### Installing NATS

NATS is integrated as a sub-chart deployment: you can enable it with
the following settings:

```
nats:
  enabled: true

# or via the --set argument:
--set="nats.enabled=true"
```

You can customize it by following the [provider's](https://docs.nats.io/running-a-nats-service/nats-kubernetes/helm-charts)
specifications.
It's recommended to use an external deployment in Production.

## Installing the Chart

To install the chart with the release name `my-release` using `helm`:

```bash
helm install my-release -f values.yaml ./mender
```

The command deploys Mender on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

This is the minimum `values.yaml` file needed to install Mender:

```yaml
global:
  image:
    username: <your_user>
    password: <your_password>
  url: https://mender.example.com

api_gateway:
  certs:
    cert: |-
      -----BEGIN CERTIFICATE-----
      MIIFcjCCBFq...
    key: |-
      -----BEGIN PRIVATE KEY-----
      MIIEvgIBADA...

device_auth:
  certs:
    key: |-
      -----BEGIN RSA PRIVATE KEY-----
      MIIEvgIBADA...

tenantadm:
  certs:
    key: |-
      -----BEGIN RSA PRIVATE KEY-----
      MIIEvgIBADA...

useradm:
  certs:
    key: |-
      -----BEGIN RSA PRIVATE KEY-----
      MIIEvgIBADA...
```

You can generate your `cert` and `key` for `api-gareway` using `openssl`:

```bash
openssl req -x509 -sha256 -nodes -days 3650 -newkey ec:<(openssl ecparam -name prime256v1) -keyout private.key -out certificate.crt -subj /CN="your.host.name"
```

You can generate the RSA private keys for `device-auth`, `tenantadm` and `useradm` using `openssl`:

```bash
openssl genpkey -algorithm RSA -out device_auth.key -pkeyopt rsa_keygen_bits:3072
openssl rsa -in device_auth.key -out device_auth_converted.key
mv device_auth_converted.key device_auth.key
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Complete list of parameters

The following table lists the global, default, and other parameters supported by the chart and their default values.

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `global.enterprise` | Enable the enterprise features | `true` |
| `global.hosted` | Enabled Hosted Mender specific features | `false` |
| `global.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the workwloads | `nil` |
| `global.image.registry` | Global Docker image registry | `registry.mender.io` |
| `global.image.username` | Global Docker image registry username | `nil` |
| `global.image.password` | Global Docker image registry username | `password` |
| `global.image.tag` | Global Docker image registry tag | `mender-3.7.8` |
| `global.mongodb.existingSecret` | MongoDB existing secret with keys: `MONGO` and `MONGO_URL` both with MongoDB connection string format  | `null` |
| `global.mongodb.URL` | MongoDB URL | `mongodb://mongodb` |
| `global.nats.existingSecret` | NATS existing secret with key: `NATS_URI` and NATS connection string `nats://...` | `null` |
| `global.nats.URL` | NATS URL | `nats://nats:4222` |
| `global.redis.URL` | Optional Redis URL, used with an external service when `redis.enabled=false` | `nil` |
| `global.redis.existingSecret` | Optional Redis URL from a secret, used with an external service when `redis.enabled=false`. The key has to be `REDIS_CONNECTION_STRING` | `nil` |
| `global.redis.username` | Optional Redis Username **[Deprecated from 3.7.0: use `global.redis.URL` instead ]** | `nil` |
| `global.redis.password` | Optional Redis Password **[Deprecated from 3.7.0: use `global.redis.URL` instead ]** | `nil` |
| `global.opensearch.URLs` | Opensearch URLs | `http://opensearch-cluster-master:9200` |
| `global.storage` | Artifacts storage type  (available types: `aws` and `azure`) | `aws` |
| `global.s3.AWS_URI` | AWS S3 / MinIO URI | value from `global.url` |
| `global.s3.AWS_EXTERNAL_URI` | External AWS S3 / MinIO URI | `null` |
| `global.s3.AWS_BUCKET` | AWS S3 / MinIO bucket | `minio-hosted-mender-artifacts` |
| `global.s3.AWS_REGION` | AWS S3 region | `us-east-1` |
| `global.s3.AWS_ACCESS_KEY_ID` | AWS S3 / MinIO key ID. An empty value will use credentials from the shared AWS credentials. | `myaccesskey` |
| `global.s3.AWS_SECRET_ACCESS_KEY` | AWS S3 / MinIO access key | `mysecretkey` |
| `global.s3.AWS_SERVICE_ACCOUNT_NAME` | Use K8s service account instead of `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to access the bucket. | `""` |
| `global.s3.AWS_FORCE_PATH_STYLE` | Set the AWS S3 URI style to path | `true` |
| `global.s3.AWS_TAG_ARTIFACT` | Tag the artifact in the AWS S3 storage service with the tenant ID | `true` |
| `global.s3.existingSecret` | S3 existing secret containing the keys above: `AWS_URI`, `AWS_BUCKET`, `AWS_REGION`, ... | `null` |
| `global.azure.AUTH_CONNECTION_STRING` | Azure Blob Storage connection string | `""` |
| `global.azure.AUTH_SHARED_KEY_ACCOUNT_NAME` | Azure Blob Storage shared key account name | `""` |
| `global.azure.AUTH_SHARED_KEY_ACCOUNT_KEY` | Azure Blob Storage shared key account key | `""` |
| `global.azure.AUTH_SHARED_KEY_URI` | Azure Blob Storage shared key URI | `""` |
| `global.azure.CONTAINER_NAME` | Azure Blob Storage container name | `mender-artifact-storage` |
| `global.smtp.existingSecret` | Use an existing secret to get the env vars | `nil` |
| `global.smtp.EMAIL_SENDER` | SMTP email sender | `root@localhost` |
| `global.smtp.SMTP_HOST` | SMTP server address | `localhost:25` |
| `global.smtp.SMTP_AUTH_MECHANISM` | SMTP auth mechanism (Valid values: PLAIN, CRAM-MD5) | `PLAIN` |
| `global.smtp.SMTP_USERNAME` | SMTP server username | `null` |
| `global.smtp.SMTP_PASSWORD` | SMTP server password | `null` |
| `global.smtp.SMTP_SSL` | Enable the SSL connection to the SMTP server | `false` |
| `global.url` | Public URL of the Mender Server, replace with your domain | `https://mender-api-gateway` |
| `default.affinity` | Optional affinity values that applies to all the resources | `nil` |
| `default.toleration` | Optional toleration values that applies to all the resources | `nil` |
| `default.hpa` | HorizontalPodAutoscaler support | `nil` |
| `default.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `default.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `default.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `default.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `default.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `default.pdb.enabled` | PodDistruptionBudget enabled | `false` |
| `default.pdb.minAvailable` | PodDistruptionBudget minAvailable | `1` |
| `default.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `default.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `default.updateStrategy` | The strategy to use to update existing pods | `rollingUpdate = { maxSurge = 25%, maxUnavailable = 0 }` |
| `default.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `default.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `default.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |
| `ingress.enabled` | Optional Mender Ingress | `false` |
| `dbmigration.enable` | Helm Chart hook that trigger a DB Migration utility just before an Helm Chart install or upgrade  | `true` |
| `device_license_count.enabled` | Device license count feature - enterprise only | `false` |
| `serviceAccount.create` | Create a custom ServiceAccount | `false` |
| `serviceAccount.name` | Custom ServiceAccount name | `nil` |
| `serviceAccount.labels` | ServiceAccount labels | `nil` |
| `serviceAccount.annotations` | ServiceAccount annotations | `nil` |
| `fullnameOverride` | Use a custom prefix for the resources, instead of using the helm chart name (default) | `nil` |
| `tests.enabled` | Whether or not to run the helm tests after the chart install | `false` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
  ./mender
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install --name my-release -f values.yaml ./mender
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Parameters: api-gateway

The following table lists the parameters for the `api-gateway` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `api_gateway.enabled` | Enable the component | `true` |
| `api_gateway.dashboard` | Enable the Traefik dashboard (port 8080) | `false` |
| `api_gateway.image.registry` | Docker image registry | `docker.io` |
| `api_gateway.image.repository` | Docker image repository | `traefik` |
| `api_gateway.image.tag` | Docker image tag | `v2.5` |
| `api_gateway.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `api_gateway.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `api_gateway.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `api_gateway.podAnnotations` | add custom pod annotations | `nil` |
| `api_gateway.replicas` | Number of replicas | `1` |
| `api_gateway.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `api_gateway.httpPort` | Port for the HTTP listener in the container | `9080` |
| `api_gateway.httpsPort` | Port for the HTTPS listener in the container | `9443` |
| `api_gateway.resources.limits.cpu` | Resources CPU limit | `600m` |
| `api_gateway.resources.limits.memory` | Resources memory limit | `1Gi` |
| `api_gateway.resources.requests.cpu` | Resources CPU request | `600m` |
| `api_gateway.resources.requests.memory` | Resources memory request | `512Mi` |
| `api_gateway.service.name` | Name of the service | `mender-api-gateway` |
| `api_gateway.service.annotations` | Annotations map for the service | `{}` |
| `api_gateway.service.type` | Service type | `ClusterIP` |
| `api_gateway.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `api_gateway.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `api_gateway.service.httpPort` | Port for the HTTP service | `80` |
| `api_gateway.service.httpsPort` | Port for the HTTPS service | `443` |
| `api_gateway.service.httpNodePort` | Node port for the HTTP service | `nil` |
| `api_gateway.service.httpsNodePort` | Node port for the HTTPS service | `nil` |
| `api_gateway.env.SSL` | SSL termination flag | `true` |
| `api_gateway.minio.enabled` | Enable routing of S3 requests to the minio service. **[Deprecated from 5.5.0, use `api_gateway.storage_proxy`` instead]** | `true` |
| `api_gateway.minio.url` | URL of the minio service. **[Deprecated from 5.5.0, use `api_gateway.storage_proxy`` instead]** | `http://minio:9000` |
| `api_gateway.storage_proxy.enabled` | Enable storage proxy to the S3/minio service | `false` |
| `api_gateway.storage_proxy.url` | URL of the storage proxy. Should point to the AWS Bucket/Minio URL | `nil` |
| `api_gateway.storage_proxy.customRule` | Custom rules for the storage proxy. | ``HostRegexp(`{domain:^artifacts.*$}`)`` |
| `api_gateway.storage_proxy.passHostHeader` | The passHostHeader allows to forward client Host header to server. | `false` |
| `api_gateway.rateLimit.average` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `100` |
| `api_gateway.rateLimit.burst` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `100` |
| `api_gateway.rateLimit.period` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `1s` |
| `api_gateway.rateLimit.sourceCriterion` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `{"ipStrategy": {"depth": 1}}` |
| `api_gateway.extraArgs` | Optional list of additional args for the `api_gateway` container. | `null` |
| `api_gateway.authRateLimit` | Optional rate limiting for the Auth module only. See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `null` |
| `api_gateway.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `api_gateway.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `api_gateway.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `api_gateway.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `api_gateway.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `api_gateway.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `api_gateway.compression` | Enable Traefik Compression | `true` |
| `api_gateway.security_redirect` | Custom redirect to a company security page | `null` |
| `api_gateway.minio.customRule` | Custom redirect for MinIO. Uses the default one if not specified. **[Deprecated from 5.5.0, use `api_gateway.storage_proxy`` instead]** | `null` |
| `api_gateway.hpa` | HorizontalPodAutoscaler support | `nil` |
| `api_gateway.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `api_gateway.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `api_gateway.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `api_gateway.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `api_gateway.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `api_gateway.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `api_gateway.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `api_gateway.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `api_gateway.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `api_gateway.certs` | certificate management | `nil` |
| `api_gateway.certs.cert` | Public certificate (with full chain optionally) in PEM format | `nil` |
| `api_gateway.certs.key` | Private key in PEM format | `nil` |
| `api_gateway.certs.existingSecret` | Preexisting secret containing the Cert (key `cert.crt`) and the Key (key `private.key`). **Deprecation notice**: these keys will be moved to `tls.crt` and `tls.key` respectively in the next releases. If you want to use it in advance, please enable `featureGates.k8sTlsSecrets` | `nil` |
| `api_gateway.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `api_gateway.accesslogs` | Traefik Access Logs, enabled by default | `true` |
| `api_gateway.podMonitor.enabled` | If enabled, creates a PodMonitor resource for scraping Traefik metrics | `false` |
| `api_gateway.podMonitor.customLabels` | PodMonitor custom labels | `nil` |
| `api_gateway.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `api_gateway.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `api_gateway.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `3` |

### Parameters: deployments

The following table lists the parameters for the `deployments` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deployments.enabled` | Enable the component | `true` |
| `deployments.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deployments.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `deployments.image.repository` | Docker image repository | `mendersoftware/deployments-enterprise` if `global.enterprise` is true, else `mendersoftware/deployments` |
| `deployments.image.tag` | Docker image tag | `nil` |
| `deployments.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deployments.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `deployments.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deployments.podAnnotations` | add custom pod annotations | `nil` |
| `deployments.replicas` | Number of replicas | `1` |
| `deployments.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deployments.directUpload.enabled` | Enable direct upload feature | `true` |
| `deployments.directUpload.jitter` | Clock jitter - margin for removing expired objects | `"3s"` |
| `deployments.directUpload.skipVerify`  | Skip verification of artifact uploaded through direct upload. Only advised if you verified the direct upload through other means. | `false` |
| `deployments.daemonSchedule` | Cron schedule for running the storage daemon | `"15 * * * *"` |
| `deployments.resources.limits.cpu` | Resources CPU limit | `300m` |
| `deployments.resources.limits.memory` | Resources memory limit | `128Mi` |
| `deployments.resources.requests.cpu` | Resources CPU request | `300m` |
| `deployments.resources.requests.memory` | Resources memory request | `64Mi` |
| `deployments.service.name` | Name of the service | `mender-deployments` |
| `deployments.service.annotations` | Annotations map for the service | `{}` |
| `deployments.service.type` | Service type | `ClusterIP` |
| `deployments.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deployments.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deployments.service.port` | Port for the service | `8080` |
| `deployments.service.nodePort` | Node port for the service | `nil` |
| `deployments.env.DEPLOYMENTS_MIDDLEWARE` | Set the DEPLOYMENTS_MIDDLEWARE variable | `prod` |
| `deployments.env.DEPLOYMENTS_PRESIGN_SECRET` | Set the secret for generating signed url, must be a base64 encoded secret. | random value at start-up time |
| `deployments.presignSecretExistingSecret` | Set the secret for generating signed url from an existing secret with the key `PRESIGN_SECRET`. | `nil` |
| `deployments.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deployments.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `deployments.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `deployments.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deployments.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `deployments.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `deployments.hpa` | HorizontalPodAutoscaler support | `nil` |
| `deployments.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `deployments.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `deployments.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `deployments.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `deployments.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `deployments.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `deployments.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `deployments.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `deployments.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `deployments.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `deployments.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `deployments.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `deployments.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `deployments.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `deployments.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: device-auth

The following table lists the parameters for the `device-auth` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `device_auth.enabled` | Enable the component | `true` |
| `device_auth.automigrate` | Enable automatic database migrations at service start up | `true` |
| `device_auth.image.registry` | Docker image registry | `docker.io` |
| `device_auth.image.repository` | Docker image repository | `mendersoftware/deviceauth` |
| `device_auth.image.tag` | Docker image tag | `nil` |
| `device_auth.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `device_auth.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `device_auth.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `device_auth.podAnnotations` | add custom pod annotations | `nil` |
| `device_auth.replicas` | Number of replicas | `1` |
| `device_auth.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `device_auth.resources.limits.cpu` | Resources CPU limit | `350m` |
| `device_auth.resources.limits.memory` | Resources memory limit | `128Mi` |
| `device_auth.resources.requests.cpu` | Resources CPU request | `350m` |
| `device_auth.resources.requests.memory` | Resources memory request | `128Mi` |
| `device_auth.service.name` | Name of the service | `mender-device-auth` |
| `device_auth.service.annotations` | Annotations map for the service | `{}` |
| `device_auth.service.type` | Service type | `ClusterIP` |
| `device_auth.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `device_auth.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `device_auth.service.port` | Port for the service | `8080` |
| `device_auth.service.nodePort` | Node port for the service | `nil` |
| `device_auth.env.DEVICEAUTH_INVENTORY_ADDR` | Set the DEVICEAUTH_INVENTORY_ADDR variable | `http://mender-inventory:8080/` |
| `device_auth.env.DEVICEAUTH_ORCHESTRATOR_ADDR` | Set the DEVICEAUTH_ORCHESTRATOR_ADDR variable | `http://mender-workflows-server:8080` |
| `device_auth.env.DEVICEAUTH_JWT_ISSUER` | Set the DEVICEAUTH_JWT_ISSUER variable | `Mender` |
| `device_auth.env.DEVICEAUTH_JWT_EXP_TIMEOUT` | Set the DEVICEAUTH_JWT_EXP_TIMEOUT variable | `604800` |
| `device_auth.env.DEVICEAUTH_MIDDLEWARE` | Set the DEVICEAUTH_MIDDLEWARE variable | `prod` |
| `device_auth.env.DEVICEAUTH_REDIS_KEY_PREFIX` | Set the DEVICEAUTH_REDIS_KEY_PREFIX variable | `deviceauth:v1` |
| `device_auth.env.DEVICEAUTH_REDIS_LIMITS_EXPIRE_SEC` | Set the DEVICEAUTH_REDIS_LIMITS_EXPIRE_SEC variable | `3600` |
| `device_auth.env.DEVICEAUTH_REDIS_DB` | Set the DEVICEAUTH_REDIS_DB variable **[Deprecated from 3.7.0]** | `1` |
| `device_auth.env.DEVICEAUTH_REDIS_TIMEOUT_SEC` | Set the DEVICEAUTH_REDIS_TIMEOUT_SEC variable **[Deprecated from 3.7.0]** | `1` |
| `device_auth.env.DEVICEAUTH_TENANTADM_ADDR` | Set the DEVICEAUTH_TENANTADM_ADDR variable | `http://mender-tenantadm:8080` |
| `device_auth.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `device_auth.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `device_auth.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `device_auth.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `device_auth.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `device_auth.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `device_auth.hpa` | HorizontalPodAutoscaler support | `nil` |
| `device_auth.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `device_auth.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `device_auth.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `device_auth.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `device_auth.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `device_auth.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `device_auth.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `device_auth.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `device_auth.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `device_auth.certs` | certificate management | `nil` |
| `device_auth.certs.key` | Private key in PEM format | `nil` |
| `device_auth.certs.existingSecret` | Preexisting secret containing the private key (key `private.pem`) | `nil` |
| `device_auth.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `device_auth.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `device_auth.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `device_auth.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `device_auth.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `device_auth.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: gui

The following table lists the parameters for the `gui` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `gui.enabled` | Enable the component | `true` |
| `gui.image.registry` | Docker image registry | `docker.io` |
| `gui.image.repository` | Docker image repository | `mendersoftware/gui` |
| `gui.image.tag` | Docker image tag | `nil` |
| `gui.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `gui.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `gui.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `gui.podAnnotations` | add custom pod annotations | `nil` |
| `gui.replicas` | Number of replicas | `1` |
| `gui.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `gui.resources.limits.cpu` | Resources CPU limit | `20m` |
| `gui.resources.limits.memory` | Resources memory limit | `64Mi` |
| `gui.resources.requests.cpu` | Resources CPU request | `5m` |
| `gui.resources.requests.memory` | Resources memory request | `16Mi` |
| `gui.service.name` | Name of the service | `mender-gui` |
| `gui.service.annotations` | Annotations map for the service | `{}` |
| `gui.service.type` | Service type | `ClusterIP` |
| `gui.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `gui.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `gui.service.port` | Port for the service | `80` |
| `gui.service.nodePort` | Node port for the service | `nil` |
| `gui.service.portError` | Port for the Error server block | `8080` |
| `gui.httpPort` | Port for the HTTP listener in the container | `80` |
| `gui.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `gui.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `gui.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `gui.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `gui.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `gui.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `gui.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `gui.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `gui.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `gui.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `gui.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |
| `gui.hpa` | HorizontalPodAutoscaler support | `nil` |
| `gui.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `gui.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `gui.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `gui.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `gui.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |

### Parameters: inventory

The following table lists the parameters for the `inventory` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `inventory.enabled` | Enable the component | `true` |
| `inventory.automigrate` | Enable automatic database migrations at service start up | `true` |
| `inventory.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `inventory.image.repository` | Docker image repository | `mendersoftware/inventory-enterprise` if `global.enterprise` is true, else `mendersoftware/inventory` |
| `inventory.image.tag` | Docker image tag | `nil` |
| `inventory.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `inventory.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `inventory.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `inventory.podAnnotations` | add custom pod annotations | `nil` |
| `inventory.replicas` | Number of replicas | `1` |
| `inventory.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `inventory.resources.limits.cpu` | Resources CPU limit | `300m` |
| `inventory.resources.limits.memory` | Resources memory limit | `128Mi` |
| `inventory.resources.requests.cpu` | Resources CPU request | `300m` |
| `inventory.resources.requests.memory` | Resources memory request | `128Mi` |
| `inventory.service.name` | Name of the service | `mender-inventory` |
| `inventory.service.annotations` | Annotations map for the service | `{}` |
| `inventory.service.type` | Service type | `ClusterIP` |
| `inventory.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `inventory.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `inventory.service.port` | Port for the service | `8080` |
| `inventory.service.nodePort` | Node port for the service | `nil` |
| `inventory.env.INVENTORY_MIDDLEWARE` | Set the INVENTORY_MIDDLEWARE variable | `prod` |
| `inventory.env.INVENTORY_REDIS_KEY_PREFIX` | Set the INVENTORY_REDIS_KEY_PREFIX variable | `inventory:v1` |
| `inventory.env.INVENTORY_REDIS_CACHE_EXPIRE_SEC` | Set the INVENTORY_REDIS_CACHE_EXPIRE_SEC variable | `1800` |
| `inventory.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `inventory.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `inventory.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `inventory.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `inventory.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `inventory.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `inventory.hpa` | HorizontalPodAutoscaler support | `nil` |
| `inventory.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `inventory.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `inventory.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `inventory.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `inventory.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `inventory.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `inventory.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `inventory.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `inventory.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `inventory.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `inventory.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `inventory.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `inventory.mongodbExistingSecret` | Use a different MongoDB secret for this service | `nil` |
| `inventory.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `inventory.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `inventory.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: reporting

The following table lists the parameters for the `reporting` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `reporting.enabled` | Enable the component | `true` |
| `reporting.automigrate` | Enable automatic database migrations at service start up | `false` |
| `reporting.image.registry` | Docker image registry | `docker.io` |
| `reporting.image.repository` | Docker image repository | `mendersoftware/reporting` |
| `reporting.image.tag` | Docker image tag | `nil` |
| `reporting.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `reporting.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `reporting.image.podAnnotations` | add custom pod annotations | `nil` |
| `reporting.replicas` | Number of replicas | `1` |
| `reporting.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `reporting.resources.limits.cpu` | Resources CPU limit | `50m` |
| `reporting.resources.limits.memory` | Resources memory limit | `128Mi` |
| `reporting.resources.requests.cpu` | Resources CPU request | `50m` |
| `reporting.resources.requests.memory` | Resources memory request | `128Mi` |
| `reporting.service.name` | Name of the service | `mender-reporting` |
| `reporting.service.annotations` | Annotations map for the service | `{}` |
| `reporting.service.type` | Service type | `ClusterIP` |
| `reporting.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `reporting.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `reporting.service.port` | Port for the service | `8080` |
| `reporting.service.nodePort` | Node port for the service | `nil` |

### Parameters: tenantadm

The following table lists the parameters for the `tenantadm` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `tenantadm.enabled` | Enable the component | `true` |
| `tenantadm.image.registry` | Docker image registry | `registry.mender.io` |
| `tenantadm.image.repository` | Docker image repository | `mendersoftware/tenantadm` |
| `tenantadm.image.tag` | Docker image tag | `nil` |
| `tenantadm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `tenantadm.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `tenantadm.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `tenantadm.podAnnotations` | add custom pod annotations | `nil` |
| `tenantadm.replicas` | Number of replicas | `1` |
| `tenantadm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `tenantadm.resources.limits.cpu` | Resources CPU limit | `150m` |
| `tenantadm.resources.limits.memory` | Resources memory limit | `128Mi` |
| `tenantadm.resources.requests.cpu` | Resources CPU request | `150m` |
| `tenantadm.resources.requests.memory` | Resources memory request | `64Mi` |
| `tenantadm.service.name` | Name of the service | `mender-tenantadm` |
| `tenantadm.service.annotations` | Annotations map for the service | `{}` |
| `tenantadm.service.type` | Service type | `ClusterIP` |
| `tenantadm.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `tenantadm.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `tenantadm.service.port` | Port for the service | `8080` |
| `tenantadm.service.nodePort` | Node port for the service | `nil` |
| `tenantadm.env.TENANTADM_MIDDLEWARE` | Set the TENANTADM_MIDDLEWARE variable | `prod` |
| `tenantadm.env.TENANTADM_SERVER_PRIV_KEY_PATH` | Set the TENANTADM_SERVER_PRIV_KEY_PATH variable | `/etc/tenantadm/rsa/private.pem` |
| `tenantadm.env.TENANTADM_ORCHESTRATOR_ADDR` | Set the TENANTADM_ORCHESTRATOR_ADDR variable | `http://mender-workflows-server:8080/` |
| `tenantadm.env.TENANTADM_RECAPTCHA_URL_VERIFY` | Set the TENANTADM_RECAPTCHA_URL_VERIFY variable | `https://www.google.com/recaptcha/api/siteverify` |
| `tenantadm.env.TENANTADM_DEFAULT_API_LIMITS` | Set the TENANTADM_DEFAULT_API_LIMITS variable, defining the default rate limits | see below for the default values |
| `tenantadm.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `tenantadm.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `tenantadm.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `tenantadm.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `tenantadm.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `tenantadm.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `tenantadm.hpa` | HorizontalPodAutoscaler support | `nil` |
| `tenantadm.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `tenantadm.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `tenantadm.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `tenantadm.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `tenantadm.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `tenantadm.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `tenantadm.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `tenantadm.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `tenantadm.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `tenantadm.certs` | certificate management | `nil` |
| `tenantadm.certs.key` | Private key in PEM format | `nil` |
| `tenantadm.certs.existingSecret` | Preexisting secret containing the private key (key `private.pem`) | `nil` |
| `tenantadm.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `tenantadm.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `tenantadm.migrationArgs` | Migration job: optional migration args (list). | `["migrate"]` |
| `tenantadm.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `tenantadm.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `tenantadm.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `tenantadm.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

The default value for the rate limits are:

* Management APIs rate limits, per user:
  * 600 API calls/minute/user
* Device APIs rate limits, per device:
  * 60 API calls/minute
  * 1 API call/5 seconds for each API end-point

You can customize the default API limits setting a custom JSON document. See the [default one here](./mender/templates/tenantadm-deploy.yaml#L82).

### Parameters: useradm

The following table lists the parameters for the `useradm` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `useradm.enabled` | Enable the component | `true` |
| `useradm.automigrate` | Enable automatic database migrations at service start up | `true` |
| `useradm.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `useradm.image.repository` | Docker image repository | `mendersoftware/useradm-enterprise` if `global.enterprise` is true, else `mendersoftware/useradm` |
| `useradm.image.tag` | Docker image tag | `nil` |
| `useradm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `useradm.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `useradm.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `useradm.podAnnotations` | add custom pod annotations | `nil` |
| `useradm.replicas` | Number of replicas | `1` |
| `useradm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `useradm.resources.limits.cpu` | Resources CPU limit | `150m` |
| `useradm.resources.limits.memory` | Resources memory limit | `128Mi` |
| `useradm.resources.requests.cpu` | Resources CPU request | `150m` |
| `useradm.resources.requests.memory` | Resources memory request | `64Mi` |
| `useradm.service.name` | Name of the service | `mender-useradm` |
| `useradm.service.annotations` | Annotations map for the service | `{}` |
| `useradm.service.type` | Service type | `ClusterIP` |
| `useradm.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `useradm.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `useradm.service.port` | Port for the service | `8080` |
| `useradm.service.nodePort` | Node port for the service | `nil` |
| `useradm.env.USERADM_PROXY_COUNT` | Set the number of proxy gateways from the backend to client. | `2` |
| `useradm.env.USERADM_JWT_ISSUER` | Set the USERADM_JWT_ISSUER variable | `Mender Users` |
| `useradm.env.USERADM_JWT_EXP_TIMEOUT` | Set the USERADM_JWT_EXP_TIMEOUT variable | `604800` |
| `useradm.env.USERADM_MIDDLEWARE` | Set the USERADM_MIDDLEWARE variable | `prod` |
| `useradm.env.USERADM_REDIS_KEY_PREFIX` | Set the USERADM_REDIS_KEY_PREFIX variable | `useradm:v1` |
| `useradm.env.USERADM_REDIS_LIMITS_EXPIRE_SEC` | Set the USERADM_REDIS_LIMITS_EXPIRE_SEC variable | `3600` |
| `useradm.env.USERADM_REDIS_DB` | Set the USERADM_REDIS_DB variable **[Deprecated from 3.7.0]** | `2` |
| `useradm.env.USERADM_REDIS_TIMEOUT_SEC` | Set the USERADM_REDIS_TIMEOUT_SEC variable **[Deprecated from 3.7.0]** | `1` |
| `useradm.env.USERADM_TENANTADM_ADDR` | Set the USERADM_TENANTADM_ADDR variable | `http://mender-tenantadm:8080` |
| `useradm.env.USERADM_TOTP_ISSUER` | Set the USERADM_TOTP_ISSUER variable | `Mender` |
| `useradm.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `useradm.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `useradm.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `useradm.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `useradm.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `useradm.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `useradm.hpa` | HorizontalPodAutoscaler support | `nil` |
| `useradm.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `useradm.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `useradm.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `useradm.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `useradm.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `useradm.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `useradm.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `useradm.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `useradm.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `useradm.certs` | certificate management | `nil` |
| `useradm.certs.key` | Private key in PEM format | `nil` |
| `useradm.certs.existingSecret` | Preexisting secret containing the private key (key `private.pem`) | `nil` |
| `useradm.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `useradm.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `useradm.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `useradm.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `useradm.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `useradm.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: workflows

The following table lists the parameters for the `workflows-server` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `workflows.enabled` | Enable the component | `true` |
| `workflows.automigrate` | Enable automatic database migrations at service start up | `true` |
| `workflows.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `workflows.image.repository` | Docker image repository | `mendersoftware/workflows-enterprise` if `global.enterprise` is true, else `mendersoftware/workflows` |
| `workflows.image.tag` | Docker image tag | `nil` |
| `workflows.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `workflows.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `workflows.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `workflows.podAnnotations` | add custom pod annotations | `nil` |
| `workflows.replicas` | Number of replicas | `1` |
| `workflows.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `workflows.resources.limits.cpu` | Resources CPU limit | `100m` |
| `workflows.resources.limits.memory` | Resources memory limit | `128Mi` |
| `workflows.resources.requests.cpu` | Resources CPU request | `10m` |
| `workflows.resources.requests.memory` | Resources memory request | `64Mi` |
| `workflows.service.name` | Name of the service | `mender-workflows-server` |
| `workflows.service.annotations` | Annotations map for the service | `{}` |
| `workflows.service.type` | Service type | `ClusterIP` |
| `workflows.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `workflows.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `workflows.service.port` | Port for the service | `8080` |
| `workflows.service.nodePort` | Node port for the service | `nil` |
| `workflows.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `workflows.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `workflows.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `workflows.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `workflows.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `workflows.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `workflows.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `workflows.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `workflows.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `workflows.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `workflows.mountSecrets` | Optional `volumeMounts` and `volumes` to inject a credential files in the workflows service  | `nil` |
| `workflows.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `workflows.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `workflows.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: create_artifact_worker

The following table lists the parameters for the `create-artifact-worker` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `create_artifact_worker.enabled` | Enable the component | `true` |
| `create_artifact_worker.automigrate` | Enable automatic database migrations at service start up | `false` |
| `create_artifact_worker.image.registry` | Docker image registry | `docker.io` |
| `create_artifact_worker.image.repository` | Docker image repository | `mendersoftware/create-artifact-worker` |
| `create_artifact_worker.image.tag` | Docker image tag | `nil` |
| `create_artifact_worker.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `create_artifact_worker.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `create_artifact_worker.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `create_artifact_worker.podAnnotations` | add custom pod annotations | `nil` |
| `create_artifact_worker.replicas` | Number of replicas | `1` |
| `create_artifact_worker.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `create_artifact_worker.resources.limits.cpu` | Resources CPU limit | `100m` |
| `create_artifact_worker.resources.limits.memory` | Resources memory limit | `1024Mi` |
| `create_artifact_worker.resources.requests.cpu` | Resources CPU request | `100m` |
| `create_artifact_worker.resources.requests.memory` | Resources memory request | `128Mi` |
| `create_artifact_worker.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `create_artifact_worker.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `create_artifact_worker.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `create_artifact_worker.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `create_artifact_worker.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `create_artifact_worker.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `create_artifact_worker.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `create_artifact_worker.updateStrategy` | The strategy to use to update existing pods | `nil` |

### Parameters: auditlogs

The following table lists the parameters for the `auditlogs` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `auditlogs.enabled` | Enable the component | `true` |
| `auditlogs.automigrate` | Enable automatic database migrations at service start up | `true` |
| `auditlogs.image.registry` | Docker image registry | `registry.mender.io` |
| `auditlogs.image.repository` | Docker image repository | `mendersoftware/auditlogs` |
| `auditlogs.image.tag` | Docker image tag | `nil` |
| `auditlogs.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `auditlogs.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `auditlogs.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `auditlogs.podAnnotations` | add custom pod annotations | `nil` |
| `auditlogs.logRetentionSeconds` | Seconds before an audit event is evicted from the database | `7776000` |
| `auditlogs.replicas` | Number of replicas | `1` |
| `auditlogs.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `auditlogs.resources.limits.cpu` | Resources CPU limit | `50m` |
| `auditlogs.resources.limits.memory` | Resources memory limit | `128Mi` |
| `auditlogs.resources.requests.cpu` | Resources CPU request | `50m` |
| `auditlogs.resources.requests.memory` | Resources memory request | `128Mi` |
| `auditlogs.service.name` | Name of the service | `mender-auditlogs` |
| `auditlogs.service.annotations` | Annotations map for the service | `{}` |
| `auditlogs.service.type` | Service type | `ClusterIP` |
| `auditlogs.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `auditlogs.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `auditlogs.service.port` | Port for the service | `8080` |
| `auditlogs.service.nodePort` | Node port for the service | `nil` |
| `auditlogs.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `auditlogs.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `auditlogs.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `auditlogs.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `auditlogs.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `auditlogs.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `auditlogs.hpa` | HorizontalPodAutoscaler support | `nil` |
| `auditlogs.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `auditlogs.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `auditlogs.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `auditlogs.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `auditlogs.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `auditlogs.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `auditlogs.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `auditlogs.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `auditlogs.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `auditlogs.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `auditlogs.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `auditlogs.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: iot-manager

The following table lists the parameters for the `iot-manager` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `iot_manager.enabled` | Enable the component | `true` |
| `iot_manager.automigrate` | Enable automatic database migrations at service start up | `true` |
| `iot_manager.image.registry` | Docker image registry | `docker.io` |
| `iot_manager.image.repository` | Docker image repository | `mendersoftware/iot-manager` |
| `iot_manager.image.tag` | Docker image tag | `nil` |
| `iot_manager.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `iot_manager.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `iot_manager.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `iot_manager.image.podAnnotations` | add custom pod annotations | `nil` |
| `iot_manager.replicas` | Number of replicas | `1` |
| `iot_manager.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `iot_manager.resources.limits.cpu` | Resources CPU limit | `50m` |
| `iot_manager.resources.limits.memory` | Resources memory limit | `128Mi` |
| `iot_manager.resources.requests.cpu` | Resources CPU request | `50m` |
| `iot_manager.resources.requests.memory` | Resources memory request | `128Mi` |
| `iot_manager.service.name` | Name of the service | `mender-iot_manager` |
| `iot_manager.service.annotations` | Annotations map for the service | `{}` |
| `iot_manager.service.type` | Service type | `ClusterIP` |
| `iot_manager.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `iot_manager.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `iot_manager.service.port` | Port for the service | `8080` |
| `iot_manager.service.nodePort` | Node port for the service | `nil` |
| `iot_manager.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `iot_manager.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `iot_manager.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `iot_manager.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `iot_manager.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `iot_manager.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `iot_manager.hpa` | HorizontalPodAutoscaler support | `nil` |
| `iot_manager.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `iot_manager.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `iot_manager.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `iot_manager.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `iot_manager.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `iot_manager.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `iot_manager.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `iot_manager.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `iot_manager.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `iot_manager.aesEncryptionKey.existingSecret` | Optional secret containing the AES encryption key. The secret key must be `AES_ENCRYPTION_KEY` | `nil` |
| `iot_manager.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `iot_manager.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `iot_manager.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: deviceconnect

The following table lists the parameters for the `deviceconnect` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deviceconnect.enabled` | Enable the component | `true` |
| `deviceconnect.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deviceconnect.image.registry` | Docker image registry | `docker.io` |
| `deviceconnect.image.repository` | Docker image repository | `mendersoftware/deviceconnect` |
| `deviceconnect.image.tag` | Docker image tag | `nil` |
| `deviceconnect.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deviceconnect.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `deviceconnect.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deviceconnect.podAnnotations` | add custom pod annotations | `nil` |
| `deviceconnect.replicas` | Number of replicas | `1` |
| `deviceconnect.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deviceconnect.resources.limits.cpu` | Resources CPU limit | `100m` |
| `deviceconnect.resources.limits.memory` | Resources memory limit | `128Mi` |
| `deviceconnect.resources.requests.cpu` | Resources CPU request | `100m` |
| `deviceconnect.resources.requests.memory` | Resources memory request | `128Mi` |
| `deviceconnect.service.name` | Name of the service | `mender-deviceconnect` |
| `deviceconnect.service.annotations` | Annotations map for the service | `{}` |
| `deviceconnect.service.type` | Service type | `ClusterIP` |
| `deviceconnect.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deviceconnect.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deviceconnect.service.port` | Port for the service | `8080` |
| `deviceconnect.service.nodePort` | Node port for the service | `nil` |
| `deviceconnect.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deviceconnect.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `deviceconnect.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `deviceconnect.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deviceconnect.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `deviceconnect.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `deviceconnect.hpa` | HorizontalPodAutoscaler support | `nil` |
| `deviceconnect.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `deviceconnect.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `deviceconnect.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `deviceconnect.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `deviceconnect.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `deviceconnect.gracefulShutdownTimeout` | Timeout for the graceful shutdown | `60s` |
| `deviceconnect.terminationGracePeriodSeconds` | Termination grace period in seconds | `65` |
| `deviceconnect.pdb.enabled` | PodDistruptionBudget enabled | `nil` |
| `deviceconnect.pdb.minAvailable` | PodDistruptionBudget minAvailable | `nil` |
| `deviceconnect.pdb.maxUnavailable` | PodDistruptionBudget maxUnavailable | `nil` |
| `deviceconnect.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `deviceconnect.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `deviceconnect.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `deviceconnect.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `deviceconnect.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `deviceconnect.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `deviceconnect.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: deviceconfig

The following table lists the parameters for the `deviceconfig` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deviceconfig.enabled` | Enable the component | `true` |
| `deviceconfig.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deviceconfig.image.registry` | Docker image registry | `docker.io` |
| `deviceconfig.image.repository` | Docker image repository | `mendersoftware/deviceconfig` |
| `deviceconfig.image.tag` | Docker image tag | `nil` |
| `deviceconfig.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deviceconfig.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `deviceconfig.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deviceconfig.podAnnotations` | add custom pod annotations | `nil` |
| `deviceconfig.replicas` | Number of replicas | `1` |
| `deviceconfig.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deviceconfig.resources.limits.cpu` | Resources CPU limit | `100m` |
| `deviceconfig.resources.limits.memory` | Resources memory limit | `128Mi` |
| `deviceconfig.resources.requests.cpu` | Resources CPU request | `100m` |
| `deviceconfig.resources.requests.memory` | Resources memory request | `128Mi` |
| `deviceconfig.service.name` | Name of the service | `mender-deviceconfig` |
| `deviceconfig.service.annotations` | Annotations map for the service | `{}` |
| `deviceconfig.service.type` | Service type | `ClusterIP` |
| `deviceconfig.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deviceconfig.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deviceconfig.service.port` | Port for the service | `8080` |
| `deviceconfig.service.nodePort` | Node port for the service | `nil` |
| `deviceconfig.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deviceconfig.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `deviceconfig.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `deviceconfig.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `deviceconfig.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `deviceconfig.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `deviceconfig.hpa` | HorizontalPodAutoscaler support | `nil` |
| `deviceconfig.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `deviceconfig.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `deviceconfig.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `deviceconfig.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `deviceconfig.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `deviceconfig.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `deviceconfig.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `deviceconfig.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `deviceconfig.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `deviceconfig.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `deviceconfig.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `deviceconfig.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: devicemonitor

The following table lists the parameters for the `devicemonitor` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `devicemonitor.enabled` | Enable the component | `true` |
| `devicemonitor.automigrate` | Enable automatic database migrations at service start up | `true` |
| `devicemonitor.image.registry` | Docker image registry | `registry.mender.io` |
| `devicemonitor.image.repository` | Docker image repository | `mendersoftware/devicemonitor` |
| `devicemonitor.image.tag` | Docker image tag | `nil` |
| `devicemonitor.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `devicemonotor.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `devicemonitor.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `devicemonitor.podAnnotations` | add custom pod annotations | `nil` |
| `devicemonitor.replicas` | Number of replicas | `1` |
| `devicemonitor.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `devicemonitor.resources.limits.cpu` | Resources CPU limit | `100m` |
| `devicemonitor.resources.limits.memory` | Resources memory limit | `128Mi` |
| `devicemonitor.resources.requests.cpu` | Resources CPU request | `100m` |
| `devicemonitor.resources.requests.memory` | Resources memory request | `128Mi` |
| `devicemonitor.service.name` | Name of the service | `mender-devicemonitor` |
| `devicemonitor.service.annotations` | Annotations map for the service | `{}` |
| `devicemonitor.service.type` | Service type | `ClusterIP` |
| `devicemonitor.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `devicemonitor.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `devicemonitor.service.port` | Port for the service | `8080` |
| `devicemonitor.service.nodePort` | Node port for the service | `nil` |
| `devicemonitor.env.DEVICEMONITOR_USERADM_URL` | Set the DEVICEMONITOR_USERADM_URL variable | `http://mender-useradm:8080/` |
| `devicemonitor.env.DEVICEMONITOR_WORKFLOWS_URL` | Set the DEVICEMONITOR_WORKFLOWS_URL variable | `http://mender-workflows-server:8080` |
| `devicemonitor.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `devicemonitor.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `devicemonitor.podSecurityContext.runAsUser` | User ID for the pod | `65534` |
| `devicemonitor.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `devicemonitor.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `devicemonitor.containerSecurityContext.runAsUser` | User ID for the container | `65534` |
| `devicemonitor.hpa` | HorizontalPodAutoscaler support | `nil` |
| `devicemonitor.hpa.enabled` | HorizontalPodAutoscaler enabled | `nil` |
| `devicemonitor.hpa.minReplicas` | HorizontalPodAutoscaler minReplicas | `nil` |
| `devicemonitor.hpa.maxReplicas` | HorizontalPodAutoscaler maxReplicas | `nil` |
| `devicemonitor.hpa.metrics` | HorizontalPodAutoscaler metrics as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#metricspec-v2-autoscaling) | `nil` |
| `devicemonitor.hpa.behavior` | HorizontalPodAutoscaler behavior as defined in the [reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/#horizontalpodautoscalerbehavior-v2-autoscaling) | `nil` |
| `devicemonitor.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `devicemonitor.migrationRestartPolicy` | Migration job: restartPolicy option | `Never` |
| `devicemonitor.migrationResources` | Migration job: optional K8s resources. If not specified, uses the deployment resources | `nil` |
| `devicemonitor.updateStrategy` | The strategy to use to update existing pods | `nil` |
| `devicemonitor.probesOverrides.successThreshold` | Override the `successThreshold` for every Readiness and Liveness probes. | `nil` |
| `devicemonitor.probesOverrides.timeoutSeconds` | Override the `timeoutSeconds` for every Readiness and Liveness probes. | `nil` |
| `devicemonitor.probesOverrides.failureThreshold` | Override the `failureThreshold` for every Readiness and Liveness probes. | `nil` |

### Parameters: generate_delta_worker
Please notice that this feature is still under active development and it is
disabled by default

The following table lists the parameters for the `generate-delta-worker` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `generate_delta_worker.enabled` | Enable the component | `false` |
| `generate_delta_worker.automigrate` | Enable automatic database migrations at service start up | `false` |
| `generate_delta_worker.image.registry` | Docker image registry | `registry.mender.io` |
| `generate_delta_worker.image.repository` | Docker image repository | `mendersoftware/generate-delta-worker` |
| `generate_delta_worker.image.tag` | Docker image tag | `nil` |
| `generate_delta_worker.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `generate_delta_worker.imagePullSecrets` | Optional list of existing Image Pull Secrets in the format of `- name: my-custom-secret` | `[]` |
| `generate_delta_worker.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `generate_delta_worker.podAnnotations` | add custom pod annotations | `nil` |
| `generate_delta_worker.replicas` | Number of replicas | `1` |
| `generate_delta_worker.persistence.enabled` | Enable persistence of the work directory (PVC template) | `true` |
| `generate_delta_worker.persistence.accessModes` | Access modes for the volumes created by the StatefulSet | `["ReadWriteOnce"]` |
| `generate_delta_worker.persistence.size` | Size of the volumes (per replica) | `40Gi` |
| `generate_delta_worker.persistence.storageClass` | Storage class for the volumes created by the StatefulSet | `""` (default) |
| `generate_delta_worker.persistence.retention.whenDeleted` | Volume retention policy when StatefulSet is deleted | `"Retain"` |
| `generate_delta_worker.persistence.retention.whenScaled` | Volume retention policy when StatefulSet is scaled (down) | `"Delete"` |
| `generate_delta_worker.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `generate_delta_worker.resources.limits.cpu` | Resources CPU limit | `100m` |
| `generate_delta_worker.resources.limits.memory` | Resources memory limit | `1024Mi` |
| `generate_delta_worker.resources.requests.cpu` | Resources CPU request | `100m` |
| `generate_delta_worker.resources.requests.memory` | Resources memory request | `128Mi` |
| `generate_delta_worker.priorityClassName` | Optional pre-existing priorityClassName to be assigned to the resource | `nil` |
| `generate_delta_worker.updateStrategy` | The strategy to use to update existing pods | `nil` |

### Parameters: redis

The following table lists the parameters for the `redis` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `redis.enabled` | Enable the component | `true` |
| `redis.image.registry` | Docker image registry | `docker.io` |
| `redis.image.repository` | Docker image repository | `redis` |
| `redis.image.tag` | Docker image tag | `6.0.16-alpine` |
| `redis.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `redis.replicas` | Number of replicas | `1` |
| `redis.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `redis.resources.limits.cpu` | Resources CPU limit | `50m` |
| `redis.resources.limits.memory` | Resources memory limit | `64Mi` |
| `redis.resources.requests.cpu` | Resources CPU request | `100m` |
| `redis.resources.requests.memory` | Resources memory request | `128Mi` |
| `redis.service.name` | Name of the service | `mender-redis` |
| `redis.service.annotations` | Annotations map for the service | `{}` |
| `redis.service.type` | Service type | `ClusterIP` |
| `redis.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `redis.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `redis.service.port` | Port for the service | `6379` |
| `redis.service.nodePort` | Node port for the service | `nil` |
| `redis.podSecurityContext.enabled` | Enable [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `redis.podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `redis.podSecurityContext.runAsUser` | User ID for the pod | `999` |
| `redis.containerSecurityContext.enabled` | Enable container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) | `false` |
| `redis.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for container | `false` |
| `redis.containerSecurityContext.runAsUser` | User ID for the container | `999` |

### Parameters: featureGates

The special parameter `featureGates` is used to enable specific features
that are still under development or are going to replace existing ones.

The following table lists the parameters:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `featureGates.k8sTlsSecrets` | Use K8s TLS Secret type for the API Gateway: `tls.crt` and `tls.key` instead of `cert.crt` and `private.key` | `false` |

## Create a tenant and a user from command line

### Enterprise version

You can create a tenant from the command line of the `tenantadm` pod; the value printed is the newly generated tenant ID:

```bash
tenantadm create-org --name demo --username "admin@mender.io" --password "adminadmin" --plan enterprise
5dcd71624143b30050e63bed
```

You can create additional useres from the command line of the `useradm` pod:

```bash
useradm-enterprise create-user --username "demo@mender.io" --password "demodemo" --tenant-id "5dcd71624143b30050e63bed"
187b8101-4431-500f-88da-54709f51f2e6
```

### Open Source version

If you are running the Open Source version of Mender, you won't have the `tenantadm` service.
You can create users directly in the `useradm` pod:

```bash
useradm create-user --username "demo@mender.io" --password "demodemo"
187b8101-4431-500f-88da-54709f51f2e6
```

## Test the service through the GUI

You can port-forward the `mender-api-gateway` Kubernetes service to verify the system is up and running:

```bash
kubectl port-forward service/mender-api-gateway 443:443
```

## Contributing

We welcome and ask for your contribution. If you would like to contribute to Mender, please read our guide on how to best get started [contributing code or
documentation](https://github.com/mendersoftware/mender/blob/master/CONTRIBUTING.md).

## License

Mender is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/mendersoftware/mender-helm/blob/master/LICENSE) for the
full license text.

## Security disclosure

We take security very seriously. If you come across any issue regarding
security, please disclose the information by sending an email to
[security@mender.io](security@mender.io). Please do not create a new public
issue. We thank you in advance for your cooperation.

## Connect with us

* Join the [Mender Hub discussion forum](https://hub.mender.io)
* Follow us on [Twitter](https://twitter.com/mender_io). Please
  feel free to tweet us questions.
* Fork us on [Github](https://github.com/mendersoftware)
* Create an issue in the [bugtracker](https://tracker.mender.io/projects/MEN)
* Email us at [contact@mender.io](mailto:contact@mender.io)
* Connect to the [#mender IRC channel on Libera](https://web.libera.chat/?#mender)
