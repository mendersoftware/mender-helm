# Mender

[Mender](https://mender.io/) is a robust and secure way to update all your software and deploy your IoT devices at scale with support for customization.

## TL;DR;

Using `helm`:

```bash
$ make package
$ helm install mender ./mender-3.4.0.tgz
```

## Introduction

This chart bootstraps a [Mender](https://mender.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+

## External services required

This Helm chart does not install the following external services and dependencies which are required to run Mender:

- mongodb
- MinIO
- NATS

### Installing mongodb

You can install mongodb using the official mongodb Helm chart using `helm`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm repo update
$ helm install mongodb bitnami/mongodb --version 11.1.3 --set "image.tag=4.4.13-debian-10-r29" --set "auth.enabled=false"
```

### Installing MinIO

You can install MinIO using the official MinIO Helm chart using `helm`:

```bash
$ helm repo add minio https://helm.min.io/
$ helm repo update
$ helm install minio minio/minio --version 8.0.10 --set "image.tag=RELEASE.2021-02-14T04-01-33Z" --set "accessKey=myaccesskey,secretKey=mysecretkey" --set "resources.requests.memory=128M"
```

### Installing NATS

Follow instructions from https://nats-io.github.io/k8s using `helm`:

```bash
$ helm repo add nats https://nats-io.github.io/k8s/helm/charts/
$ helm repo update
$ helm install nats nats/nats --version 0.15.1 --set "nats.image=nats:2.7.4-alpine" --set "nats.jetstream.enabled=true"
```

## Installing the Chart

To install the chart with the release name `my-release` using `helm`:

```bash
$ helm install my-release -f values.yaml ./mender-3.4.0.tgz
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
$ openssl req -x509 -sha256 -nodes -days 3650 -newkey ec:<(openssl ecparam -name prime256v1) -keyout private.key -out certificate.crt -subj /CN="your.host.name"
```

You can generate the RSA private keys for `device-auth`, `tenantadm` and `useradm` using `openssl`:

```bash
$ openssl genpkey -algorithm RSA -out device_auth.key -pkeyopt rsa_keygen_bits:3072
$ openssl rsa -in device_auth.key -out device_auth_converted.key
$ mv device_auth_converted.key device_auth.key
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Complete list of parameters

The following table lists the global parameters supported by the chart and their default values.

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `global.enterprise` | Enable the enterprise features | `true` |
| `global.hosted` | Enabled Hosted Mender specific features | `false` |
| `global.image.registry` | Global Docker image registry | `registry.mender.io` |
| `global.image.username` | Global Docker image registry username | `nil` |
| `global.image.password` | Global Docker image registry username | `password` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)  |
| `global.mongodb.URL` | MongoDB URL | `mongodb://mongodb` |
| `global.nats.URL` | NATS URL | `nats://nats:4222` |
| `global.s3.AWS_URI` | AWS S3 / MinIO URI | value from `global.url` |
| `global.s3.AWS_EXTERNAL_URI` | External AWS S3 / MinIO URI | `null` |
| `global.s3.AWS_BUCKET` | AWS S3 / MinIO bucket | `minio-hosted-mender-artifacts` |
| `global.s3.AWS_REGION` | AWS S3 region | `us-east-1` |
| `global.s3.AWS_ACCESS_KEY_ID` | AWS S3 / MinIO key ID. An empty value will use credentials from the shared AWS credentials. | `myaccesskey` |
| `global.s3.AWS_SECRET_ACCESS_KEY` | AWS S3 / MinIO access key | `mysecretkey` |
| `global.s3.AWS_SERVICE_ACCOUNT_NAME` | Use K8s service account instead of `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to access the bucket. | `""` |
| `global.s3.AWS_FORCE_PATH_STYLE` | Set the AWS S3 URI style to path | `true` |
| `global.s3.AWS_TAG_ARTIFACT` | Tag the artifact in the AWS S3 storage service with the tenant ID | `true` |
| `global.smtp.EMAIL_SENDER` | SMTP email sender | `root@localhost` |
| `global.smtp.SMTP_ADDRESS` | SMTP server address | `smtp.mailtrap.io` |
| `global.smtp.SMTP_LOGIN` | SMTP server username | `null` |
| `global.smtp.SMTP_PASSWORD` | SMTP server password | `null` |
| `global.smtp.SMTP_SSL` | Enable the SSL connection to the SMTP server | `false` |
| `global.url` | Public URL of the Mender Server, replace with your domain | `https://mender-api-gateway` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
  ./mender-3.4.0.tgz
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml ./mender-3.4.0.tgz
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
| `api_gateway.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `api_gateway.podAnnotations` | add custom pod annotations | `nil` |
| `api_gateway.replicas` | Number of replicas | `1` |
| `api_gateway.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `api_gateway.httpPort` | Port for the HTTP listener in the container | `80` |
| `api_gateway.httpsPort` | Port for the HTTPS listener in the container | `443` |
| `api_gateway.resources.limits.cpu` | Resources CPU limit | `600m` |
| `api_gateway.resources.limits.memory` | Resources memory limit | `1G` |
| `api_gateway.resources.requests.cpu` | Resources CPU request | `600m` |
| `api_gateway.resources.requests.memory` | Resources memory request | `512M` |
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
| `api_gateway.minio.enabled` | Enable routing of S3 requests to the minio service | `true` |
| `api_gateway.minio.url` | URL of the minio service | `http://minio:9000` |
| `api_gateway.rateLimit.average` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `100` |
| `api_gateway.rateLimit.burst` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `100` |
| `api_gateway.rateLimit.period` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `1s` |
| `api_gateway.rateLimit.sourceCriterion` | See the [Traefik rate limit configuration options](https://doc.traefik.io/traefik/v2.6/middlewares/http/ratelimit/#configuration-options) | `{"ipStrategy": {"depth": 1}}` |


### Parameters: deployments

The following table lists the parameters for the `deployments` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deployments.enabled` | Enable the component | `true` |
| `deployments.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deployments.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `deployments.image.repository` | Docker image repository | `mendersoftware/deployments-enterprise` if `global.enterprise` is true, else `mendersoftware/deployments` |
| `deployments.image.tag` | Docker image tag | `mender-3.4.0` |
| `deployments.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deployments.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deployments.podAnnotations` | add custom pod annotations | `nil` |
| `deployments.replicas` | Number of replicas | `1` |
| `deployments.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deployments.resources.limits.cpu` | Resources CPU limit | `300m` |
| `deployments.resources.limits.memory` | Resources memory limit | `128M` |
| `deployments.resources.requests.cpu` | Resources CPU request | `300m` |
| `deployments.resources.requests.memory` | Resources memory request | `64M` |
| `deployments.service.name` | Name of the service | `mender-deployments` |
| `deployments.service.annotations` | Annotations map for the service | `{}` |
| `deployments.service.type` | Service type | `ClusterIP` |
| `deployments.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deployments.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deployments.service.port` | Port for the service | `8080` |
| `deployments.service.nodePort` | Node port for the service | `nil` |
| `deployments.env.DEPLOYMENTS_MIDDLEWARE` | Set the DEPLOYMENTS_MIDDLEWARE variable | `prod` |
| `deployments.env.DEPLOYMENTS_PRESIGN_SECRET` | Set the secret for generating signed url, must be a base64 encoded secret. | random value at start-up time |

### Parameters: device-auth

The following table lists the parameters for the `device-auth` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `device_auth.enabled` | Enable the component | `true` |
| `device_auth.automigrate` | Enable automatic database migrations at service start up | `true` |
| `device_auth.image.registry` | Docker image registry | `docker.io` |
| `device_auth.image.repository` | Docker image repository | `mendersoftware/deviceauth` |
| `device_auth.image.tag` | Docker image tag | `mender-3.4.0` |
| `device_auth.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `device_auth.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `device_auth.podAnnotations` | add custom pod annotations | `nil` |
| `device_auth.replicas` | Number of replicas | `1` |
| `device_auth.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `device_auth.resources.limits.cpu` | Resources CPU limit | `350m` |
| `device_auth.resources.limits.memory` | Resources memory limit | `128M` |
| `device_auth.resources.requests.cpu` | Resources CPU request | `350m` |
| `device_auth.resources.requests.memory` | Resources memory request | `128M` |
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
| `device_auth.env.DEVICEAUTH_REDIS_ADDR` | Set the DEVICEAUTH_REDIS_ADDR variable | `mender-redis:6379` |
| `device_auth.env.DEVICEAUTH_REDIS_USERNAME` | Set the DEVICEAUTH_REDIS_USERNAME variable | `""` |
| `device_auth.env.DEVICEAUTH_REDIS_PASSWORD` | Set the DEVICEAUTH_REDIS_PASSWORD variable | `""` |
| `device_auth.env.DEVICEAUTH_REDIS_DB` | Set the DEVICEAUTH_REDIS_DB variable | `1` |
| `device_auth.env.DEVICEAUTH_REDIS_TIMEOUT_SEC` | Set the DEVICEAUTH_REDIS_TIMEOUT_SEC variable | `1` |
| `device_auth.env.DEVICEAUTH_REDIS_LIMITS_EXPIRE_SEC` | Set the DEVICEAUTH_REDIS_LIMITS_EXPIRE_SEC variable | `3600` |
| `device_auth.env.DEVICEAUTH_TENANTADM_ADDR` | Set the DEVICEAUTH_TENANTADM_ADDR variable | `http://mender-tenantadm:8080` |

### Parameters: gui

The following table lists the parameters for the `gui` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `gui.enabled` | Enable the component | `true` |
| `gui.image.registry` | Docker image registry | `docker.io` |
| `gui.image.repository` | Docker image repository | `mendersoftware/gui` |
| `gui.image.tag` | Docker image tag | `mender-3.4.0` |
| `gui.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `gui.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `gui.podAnnotations` | add custom pod annotations | `nil` |
| `gui.replicas` | Number of replicas | `1` |
| `gui.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `gui.resources.limits.cpu` | Resources CPU limit | `20m` |
| `gui.resources.limits.memory` | Resources memory limit | `64M` |
| `gui.resources.requests.cpu` | Resources CPU request | `5m` |
| `gui.resources.requests.memory` | Resources memory request | `16M` |
| `gui.service.name` | Name of the service | `mender-gui` |
| `gui.service.annotations` | Annotations map for the service | `{}` |
| `gui.service.type` | Service type | `ClusterIP` |
| `gui.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `gui.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `gui.service.port` | Port for the service | `80` |
| `gui.service.nodePort` | Node port for the service | `nil` |

### Parameters: inventory

The following table lists the parameters for the `inventory` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `inventory.enabled` | Enable the component | `true` |
| `inventory.automigrate` | Enable automatic database migrations at service start up | `true` |
| `inventory.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `inventory.image.repository` | Docker image repository | `mendersoftware/inventory-enterprise` if `global.enterprise` is true, else `mendersoftware/inventory` |
| `inventory.image.tag` | Docker image tag | `mender-3.4.0` |
| `inventory.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `inventory.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `inventory.podAnnotations` | add custom pod annotations | `nil` |
| `inventory.replicas` | Number of replicas | `1` |
| `inventory.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `inventory.resources.limits.cpu` | Resources CPU limit | `300m` |
| `inventory.resources.limits.memory` | Resources memory limit | `128M` |
| `inventory.resources.requests.cpu` | Resources CPU request | `300m` |
| `inventory.resources.requests.memory` | Resources memory request | `128M` |
| `inventory.service.name` | Name of the service | `mender-inventory` |
| `inventory.service.annotations` | Annotations map for the service | `{}` |
| `inventory.service.type` | Service type | `ClusterIP` |
| `inventory.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `inventory.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `inventory.service.port` | Port for the service | `8080` |
| `inventory.service.nodePort` | Node port for the service | `nil` |
| `inventory.env.INVENTORY_MIDDLEWARE` | Set the INVENTORY_MIDDLEWARE variable | `prod` |

### Parameters: tenantadm

The following table lists the parameters for the `tenantadm` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `tenantadm.enabled` | Enable the component | `true` |
| `tenantadm.image.registry` | Docker image registry | `registry.mender.io` |
| `tenantadm.image.repository` | Docker image repository | `mendersoftware/tenantadm` |
| `tenantadm.image.tag` | Docker image tag | `mender-3.4.0` |
| `tenantadm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `tenantadm.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `tenantadm.podAnnotations` | add custom pod annotations | `nil` |
| `tenantadm.replicas` | Number of replicas | `1` |
| `tenantadm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `tenantadm.resources.limits.cpu` | Resources CPU limit | `150m` |
| `tenantadm.resources.limits.memory` | Resources memory limit | `128M` |
| `tenantadm.resources.requests.cpu` | Resources CPU request | `150m` |
| `tenantadm.resources.requests.memory` | Resources memory request | `64M` |
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
| `useradm.image.tag` | Docker image tag | `mender-3.4.0` |
| `useradm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `useradm.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `useradm.podAnnotations` | add custom pod annotations | `nil` |
| `useradm.replicas` | Number of replicas | `1` |
| `useradm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `useradm.resources.limits.cpu` | Resources CPU limit | `150m` |
| `useradm.resources.limits.memory` | Resources memory limit | `128M` |
| `useradm.resources.requests.cpu` | Resources CPU request | `150m` |
| `useradm.resources.requests.memory` | Resources memory request | `64M` |
| `useradm.service.name` | Name of the service | `mender-useradm` |
| `useradm.service.annotations` | Annotations map for the service | `{}` |
| `useradm.service.type` | Service type | `ClusterIP` |
| `useradm.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `useradm.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `useradm.service.port` | Port for the service | `8080` |
| `useradm.service.nodePort` | Node port for the service | `nil` |
| `useradm.env.USERADM_JWT_ISSUER` | Set the USERADM_JWT_ISSUER variable | `Mender Users` |
| `useradm.env.USERADM_JWT_EXP_TIMEOUT` | Set the USERADM_JWT_EXP_TIMEOUT variable | `604800` |
| `useradm.env.USERADM_MIDDLEWARE` | Set the USERADM_MIDDLEWARE variable | `prod` |
| `useradm.env.USERADM_REDIS_ADDR` | Set the USERADM_REDIS_ADDR variable | `mender-redis:6379` |
| `useradm.env.USERADM_REDIS_USERNAME` | Set the USERADM_REDIS_USERNAME variable | `""` |
| `useradm.env.USERADM_REDIS_PASSWORD` | Set the USERADM_REDIS_PASSWORD variable | `""` |
| `useradm.env.USERADM_REDIS_DB` | Set the USERADM_REDIS_DB variable | `2` |
| `useradm.env.USERADM_REDIS_TIMEOUT_SEC` | Set the USERADM_REDIS_TIMEOUT_SEC variable | `1` |
| `useradm.env.USERADM_REDIS_LIMITS_EXPIRE_SEC` | Set the USERADM_REDIS_LIMITS_EXPIRE_SEC variable | `3600` |
| `useradm.env.USERADM_TENANTADM_ADDR` | Set the USERADM_TENANTADM_ADDR variable | `http://mender-tenantadm:8080` |
| `useradm.env.USERADM_TOTP_ISSUER` | Set the USERADM_TOTP_ISSUER variable | `Mender` |

### Parameters: workflows

The following table lists the parameters for the `workflows-server` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `workflows.enabled` | Enable the component | `true` |
| `workflows.automigrate` | Enable automatic database migrations at service start up | `true` |
| `workflows.image.registry` | Docker image registry | `registry.mender.io` if `global.enterprise` is true, else `docker.io` |
| `workflows.image.repository` | Docker image repository | `mendersoftware/workflows-enterprise` if `global.enterprise` is true, else `mendersoftware/workflows` |
| `workflows.image.tag` | Docker image tag | `mender-3.4.0` |
| `workflows.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `workflows.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `workflows.podAnnotations` | add custom pod annotations | `nil` |
| `workflows.replicas` | Number of replicas | `1` |
| `workflows.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `workflows.resources.limits.cpu` | Resources CPU limit | `100m` |
| `workflows.resources.limits.memory` | Resources memory limit | `128M` |
| `workflows.resources.requests.cpu` | Resources CPU request | `10m` |
| `workflows.resources.requests.memory` | Resources memory request | `64M` |
| `workflows.service.name` | Name of the service | `mender-workflows-server` |
| `workflows.service.annotations` | Annotations map for the service | `{}` |
| `workflows.service.type` | Service type | `ClusterIP` |
| `workflows.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `workflows.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `workflows.service.port` | Port for the service | `8080` |
| `workflows.service.nodePort` | Node port for the service | `nil` |

### Parameters: create_artifact_worker

The following table lists the parameters for the `create-artifact-worker` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `create_artifact_worker.enabled` | Enable the component | `true` |
| `create_artifact_worker.automigrate` | Enable automatic database migrations at service start up | `true` |
| `create_artifact_worker.image.registry` | Docker image registry | `docker.io` |
| `create_artifact_worker.image.repository` | Docker image repository | `mendersoftware/create-artifact-worker` |
| `create_artifact_worker.image.tag` | Docker image tag | `mender-3.4.0` |
| `create_artifact_worker.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `create_artifact_worker.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `create_artifact_worker.podAnnotations` | add custom pod annotations | `nil` |
| `create_artifact_worker.replicas` | Number of replicas | `1` |
| `create_artifact_worker.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `create_artifact_worker.resources.limits.cpu` | Resources CPU limit | `100m` |
| `create_artifact_worker.resources.limits.memory` | Resources memory limit | `1024M` |
| `create_artifact_worker.resources.requests.cpu` | Resources CPU request | `100m` |
| `create_artifact_worker.resources.requests.memory` | Resources memory request | `128M` |

### Parameters: auditlogs

The following table lists the parameters for the `auditlogs` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `auditlogs.enabled` | Enable the component | `true` |
| `auditlogs.automigrate` | Enable automatic database migrations at service start up | `true` |
| `auditlogs.image.registry` | Docker image registry | `registry.mender.io` |
| `auditlogs.image.repository` | Docker image repository | `mendersoftware/auditlogs` |
| `auditlogs.image.tag` | Docker image tag | `mender-3.4.0` |
| `auditlogs.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `auditlogs.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `auditlogs.podAnnotations` | add custom pod annotations | `nil` |
| `auditlogs.replicas` | Number of replicas | `1` |
| `auditlogs.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `auditlogs.resources.limits.cpu` | Resources CPU limit | `50m` |
| `auditlogs.resources.limits.memory` | Resources memory limit | `128M` |
| `auditlogs.resources.requests.cpu` | Resources CPU request | `50m` |
| `auditlogs.resources.requests.memory` | Resources memory request | `128M` |
| `auditlogs.service.name` | Name of the service | `mender-auditlogs` |
| `auditlogs.service.annotations` | Annotations map for the service | `{}` |
| `auditlogs.service.type` | Service type | `ClusterIP` |
| `auditlogs.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `auditlogs.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `auditlogs.service.port` | Port for the service | `8080` |
| `auditlogs.service.nodePort` | Node port for the service | `nil` |


### Parameters: iot-manager

The following table lists the parameters for the `iot-manager` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `iot_manager.enabled` | Enable the component | `true` |
| `iot_manager.automigrate` | Enable automatic database migrations at service start up | `true` |
| `iot_manager.image.registry` | Docker image registry | `docker.io` |
| `iot_manager.image.repository` | Docker image repository | `mendersoftware/iot-manager` |
| `iot_manager.image.tag` | Docker image tag | `mender-3.4.0` |
| `iot_manager.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `iot_manager.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `iot_manager.image.podAnnotations` | add custom pod annotations | `nil` |
| `iot_manager.replicas` | Number of replicas | `1` |
| `iot_manager.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `iot_manager.resources.limits.cpu` | Resources CPU limit | `50m` |
| `iot_manager.resources.limits.memory` | Resources memory limit | `128M` |
| `iot_manager.resources.requests.cpu` | Resources CPU request | `50m` |
| `iot_manager.resources.requests.memory` | Resources memory request | `128M` |
| `iot_manager.service.name` | Name of the service | `mender-iot_manager` |
| `iot_manager.service.annotations` | Annotations map for the service | `{}` |
| `iot_manager.service.type` | Service type | `ClusterIP` |
| `iot_manager.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `iot_manager.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `iot_manager.service.port` | Port for the service | `8080` |
| `iot_manager.service.nodePort` | Node port for the service | `nil` |

### Parameters: deviceconnect

The following table lists the parameters for the `deviceconnect` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deviceconnect.enabled` | Enable the component | `true` |
| `deviceconnect.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deviceconnect.image.registry` | Docker image registry | `docker.io` |
| `deviceconnect.image.repository` | Docker image repository | `mendersoftware/deviceconnect` |
| `deviceconnect.image.tag` | Docker image tag | `mender-3.4.0` |
| `deviceconnect.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deviceconnect.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deviceconnect.podAnnotations` | add custom pod annotations | `nil` |
| `deviceconnect.replicas` | Number of replicas | `1` |
| `deviceconnect.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deviceconnect.resources.limits.cpu` | Resources CPU limit | `100m` |
| `deviceconnect.resources.limits.memory` | Resources memory limit | `128M` |
| `deviceconnect.resources.requests.cpu` | Resources CPU request | `100m` |
| `deviceconnect.resources.requests.memory` | Resources memory request | `128M` |
| `deviceconnect.service.name` | Name of the service | `mender-deviceconnect` |
| `deviceconnect.service.annotations` | Annotations map for the service | `{}` |
| `deviceconnect.service.type` | Service type | `ClusterIP` |
| `deviceconnect.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deviceconnect.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deviceconnect.service.port` | Port for the service | `8080` |
| `deviceconnect.service.nodePort` | Node port for the service | `nil` |

### Parameters: deviceconfig

The following table lists the parameters for the `deviceconfig` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deviceconfig.enabled` | Enable the component | `true` |
| `deviceconfig.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deviceconfig.image.registry` | Docker image registry | `docker.io` |
| `deviceconfig.image.repository` | Docker image repository | `mendersoftware/deviceconfig` |
| `deviceconfig.image.tag` | Docker image tag | `mender-3.4.0` |
| `deviceconfig.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deviceconfig.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `deviceconfig.podAnnotations` | add custom pod annotations | `nil` |
| `deviceconfig.replicas` | Number of replicas | `1` |
| `deviceconfig.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deviceconfig.resources.limits.cpu` | Resources CPU limit | `100m` |
| `deviceconfig.resources.limits.memory` | Resources memory limit | `128M` |
| `deviceconfig.resources.requests.cpu` | Resources CPU request | `100m` |
| `deviceconfig.resources.requests.memory` | Resources memory request | `128M` |
| `deviceconfig.service.name` | Name of the service | `mender-deviceconfig` |
| `deviceconfig.service.annotations` | Annotations map for the service | `{}` |
| `deviceconfig.service.type` | Service type | `ClusterIP` |
| `deviceconfig.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deviceconfig.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deviceconfig.service.port` | Port for the service | `8080` |
| `deviceconfig.service.nodePort` | Node port for the service | `nil` |

### Parameters: devicemonitor

The following table lists the parameters for the `devicemonitor` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `devicemonitor.enabled` | Enable the component | `true` |
| `devicemonitor.automigrate` | Enable automatic database migrations at service start up | `true` |
| `devicemonitor.image.registry` | Docker image registry | `registry.mender.io` |
| `devicemonitor.image.repository` | Docker image repository | `mendersoftware/devicemonitor` |
| `devicemonitor.image.tag` | Docker image tag | `mender-3.4.0` |
| `devicemonitor.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `devicemonitor.nodeSelector` | [Node selection](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}` |
| `devicemonitor.podAnnotations` | add custom pod annotations | `nil` |
| `devicemonitor.replicas` | Number of replicas | `1` |
| `devicemonitor.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `devicemonitor.resources.limits.cpu` | Resources CPU limit | `100m` |
| `devicemonitor.resources.limits.memory` | Resources memory limit | `128M` |
| `devicemonitor.resources.requests.cpu` | Resources CPU request | `100m` |
| `devicemonitor.resources.requests.memory` | Resources memory request | `128M` |
| `devicemonitor.service.name` | Name of the service | `mender-devicemonitor` |
| `devicemonitor.service.annotations` | Annotations map for the service | `{}` |
| `devicemonitor.service.type` | Service type | `ClusterIP` |
| `devicemonitor.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `devicemonitor.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `devicemonitor.service.port` | Port for the service | `8080` |
| `devicemonitor.service.nodePort` | Node port for the service | `nil` |
| `devicemonitor.env.DEVICEMONITOR_USERADM_URL` | Set the DEVICEMONITOR_USERADM_URL variable | `http://mender-useradm:8080/` |
| `devicemonitor.env.DEVICEMONITOR_WORKFLOWS_URL` | Set the DEVICEMONITOR_WORKFLOWS_URL variable | `http://mender-workflows-server:8080` |

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
| `redis.resources.limits.memory` | Resources memory limit | `64M` |
| `redis.resources.requests.cpu` | Resources CPU request | `100m` |
| `redis.resources.requests.memory` | Resources memory request | `128M` |
| `redis.service.name` | Name of the service | `mender-redis` |
| `redis.service.annotations` | Annotations map for the service | `{}` |
| `redis.service.type` | Service type | `ClusterIP` |
| `redis.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `redis.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `redis.service.port` | Port for the service | `6379` |
| `redis.service.nodePort` | Node port for the service | `nil` |

## Create a tenant and a user from command line

### Enterprise version

You can create a tenant from the command line of the `tenantadm` pod; the value printed is the newly generated tenant ID:

```bash
$ tenantadm create-org --name demo --username "admin@mender.io" --password "adminadmin" --plan enterprise
5dcd71624143b30050e63bed
```

You can create additional useres from the command line of the `useradm` pod:

```bash
$ useradm-enterprise create-user --username "demo@mender.io" --password "demodemo" --tenant-id "5dcd71624143b30050e63bed"
187b8101-4431-500f-88da-54709f51f2e6
```

### Open Source version

If you are running the Open Source version of Mender, you won't have the `tenantadm` service.
You can create users directly in the `useradm` pod:

```bash
$ useradm create-user --username "demo@mender.io" --password "demodemo"
187b8101-4431-500f-88da-54709f51f2e6
```

## Test the service through the GUI

You can port-forward the `mender-api-gateway` Kubernetes service to verify the system is up and running:

```bash
$ kubectl port-forward service/mender-api-gateway 443:443
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
