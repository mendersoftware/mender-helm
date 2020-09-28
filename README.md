# Mender

[Mender](https://mender.io/) is a robust and secure way to update all your software and deploy your IoT devices at scale with support for customization.

## TL;DR;

```bash
$ helm install ./mender-2.5.0.tgz
```

## Introduction

This chart bootstraps a [Mender](https://mender.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release` using `helm2`:

```bash
$ helm install --name my-release -f values.yaml ./mender-2.5.0.tgz
```

or using `helm3`:

```bash
$ helm install my-release -f values.yaml ./mender-2.5.0.tgz
```

The command deploys Mender on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

This is the minimum `values.yaml` file needed to install Mender:

```yaml
***REMOVED***
***REMOVED***
    username: <your_user>
    password: <your_password>

***REMOVED***
***REMOVED***
    dhparam: |-
      LS0...
***REMOVED***
***REMOVED***
      MIIFcjCCBFq...
***REMOVED***
***REMOVED***
      MIIEvgIBADA...

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
      MIIEvgIBADA...

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
      MIIEvgIBADA...

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
      MIIEvgIBADA...
```

You can generate your `dhparam`, `cert` and `key` for `api-gareway` using `openssl`:

```bash
$ openssl dhparam -out dhparam.pem 2048
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
| `global.image.registry` | Global Docker image registry | `registry.mender.io` |
| `global.image.username` | Global Docker image registry username | `nil` |
| `global.image.password` | Global Docker image registry username | `password` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)  |
| `global.mongodb.URL` | MongoDB URL | `mongodb://mongodb` |
| `global.s3.AWS_URI` | AWS S3 / MinIO URI | `http://minio:9000` |
| `global.s3.AWS_BUCKET` | AWS S3 / MinIO bucket | `minio-hosted-mender-artifacts` |
| `global.s3.AWS_ACCESS_KEY_ID` | AWS S3 / MinIO key ID | `myaccesskey` |
| `global.s3.AWS_SECRET_ACCESS_KEY` | AWS S3 / MinIO access key | `mysecretkey` |
| `global.smtp.EMAIL_SENDER` | SMTP email sender | `root@localhost` |
| `global.smtp.SMTP_ADDRESS` | SMTP server address | `smtp.mailtrap.io` |
| `global.smtp.SMTP_LOGIN` | SMTP server username | `null` |
| `global.smtp.SMTP_PASSWORD` | SMTP server password | `null` |
| `global.smtp.SMTP_SSL` | Enable the SSL connection to the SMTP server | `false` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
    stable/Mender
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml ./mender-2.5.0.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Parameters: api-gateway

The following table lists the parameters for the `api-gateway` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `api_gateway.enabled` | Enable the component | `true` |
| `api_gateway.image.registry` | Docker image registry | `docker.io` |
| `api_gateway.image.repository` | Docker image repository | `mendersoftware/api-gateway` |
| `api_gateway.image.tag` | Docker image tag | `mender-2.5.0` |
| `api_gateway.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `api_gateway.replicas` | Number of replicas | `1` |
| `api_gateway.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `api_gateway.resources.limits.cpu` | Resources CPU limit | `500m` |
| `api_gateway.resources.limits.cpu` | Resources memory limit | `128M` |
| `api_gateway.resources.requests.cpu` | Resources CPU limit | `100m` |
| `api_gateway.resources.requests.cpu` | Resources memory limit | `50M` |
| `api_gateway.service.name` | Name of the service | `mender-api-gateway` |
| `api_gateway.service.annotations` | Annotations map for the service | `{}` |
| `api_gateway.service.type` | Service type | `ClusterIP` |
| `api_gateway.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `api_gateway.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `api_gateway.service.httpPort` | Port for the HTTP service | `80` |
| `api_gateway.service.httpsPort` | Port for the HTTPS service | `443` |
| `api_gateway.service.httpNodePort` | Node port for the HTTP service | `nil` |
| `api_gateway.service.httpsNodePort` | Node port for the HTTPS service | `nil` |
| `api_gateway.env.HAVE_MULTITENANT` | Set the HAVE_MULTITENANT variable | `true` |
| `api_gateway.env.DNS_NAMES` | Set the HAVE_MULTITENANT variable | `mender-tenantadm mender-useradm mender-inventory mender-deployments mender-device-auth mender-gui` |
| `api_gateway.env.IS_LOGS_FORMAT_JSON` | Set the HAVE_MULTITENANT variable | `true` |
| `api_gateway.env.ALLOWED_HOSTS` | Set the HAVE_MULTITENANT variable | `[a-zA-Z0-9:.]+` |

### Parameters: deployments

The following table lists the parameters for the `deployments` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `deployments.enabled` | Enable the component | `true` |
| `deployments.automigrate` | Enable automatic database migrations at service start up | `true` |
| `deployments.image.registry` | Docker image registry | `registry.mender.io` |
| `deployments.image.repository` | Docker image repository | `mendersoftware/deployments-enterprise` |
| `deployments.image.tag` | Docker image tag | `mender-2.5.0` |
| `deployments.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `deployments.replicas` | Number of replicas | `1` |
| `deployments.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `deployments.resources.limits.cpu` | Resources CPU limit | `500m` |
| `deployments.resources.limits.cpu` | Resources memory limit | `128M` |
| `deployments.resources.requests.cpu` | Resources CPU limit | `200m` |
| `deployments.resources.requests.cpu` | Resources memory limit | `50M` |
| `deployments.service.name` | Name of the service | `mender-deployments` |
| `deployments.service.annotations` | Annotations map for the service | `{}` |
| `deployments.service.type` | Service type | `ClusterIP` |
| `deployments.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `deployments.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `deployments.service.port` | Port for the service | `8080` |
| `deployments.service.nodePort` | Node port for the service | `nil` |
| `deployments.env.DEPLOYMENTS_MIDDLEWARE` | Set the DEPLOYMENTS_MIDDLEWARE variable | `prod` |
| `deployments.env.DEPLOYMENTS_AWS_TAG_ARTIFACT` | Set the DEPLOYMENTS_AWS_TAG_ARTIFACT variable | `true` |

### Parameters: device-auth

The following table lists the parameters for the `device-auth` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `device_auth.enabled` | Enable the component | `true` |
| `device_auth.automigrate` | Enable automatic database migrations at service start up | `true` |
| `device_auth.image.registry` | Docker image registry | `docker.io` |
| `device_auth.image.repository` | Docker image repository | `mendersoftware/deviceauth` |
| `device_auth.image.tag` | Docker image tag | `mender-2.5.0` |
| `device_auth.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `device_auth.replicas` | Number of replicas | `1` |
| `device_auth.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `device_auth.resources.limits.cpu` | Resources CPU limit | `500m` |
| `device_auth.resources.limits.cpu` | Resources memory limit | `128M` |
| `device_auth.resources.requests.cpu` | Resources CPU limit | `200m` |
| `device_auth.resources.requests.cpu` | Resources memory limit | `50M` |
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
| `device_auth.env.DEVICEAUTH_TENANTADM_ADDR` | Set the DEVICEAUTH_TENANTADM_ADDR variable | `http://mender-***REMOVED***8080` |
| `device_auth.env.DEVICEAUTH_MAX_DEVICES_LIMIT_DEFAULT` | Set the DEVICEAUTH_MAX_DEVICES_LIMIT_DEFAULT variable | `500` |

### Parameters: gui

The following table lists the parameters for the `gui` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `gui.enabled` | Enable the component | `true` |
| `gui.image.registry` | Docker image registry | `docker.io` |
| `gui.image.repository` | Docker image repository | `mendersoftware/gui` |
| `gui.image.tag` | Docker image tag | `mender-2.5.0` |
| `gui.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `gui.replicas` | Number of replicas | `1` |
| `gui.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `gui.resources.limits.cpu` | Resources CPU limit | `20m` |
| `gui.resources.limits.cpu` | Resources memory limit | `64M` |
| `gui.resources.requests.cpu` | Resources CPU limit | `5m` |
| `gui.resources.requests.cpu` | Resources memory limit | `16m` |
| `gui.service.name` | Name of the service | `mender-gui` |
| `gui.service.annotations` | Annotations map for the service | `{}` |
| `gui.service.type` | Service type | `ClusterIP` |
| `gui.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `gui.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `gui.service.port` | Port for the service | `80` |
| `gui.service.nodePort` | Node port for the service | `nil` |
| `gui.env.HAVE_MULTITENANT` | Set the HAVE_MULTITENANT variable | `true` |
| `gui.env.MENDER_HOSTED` | Set the MENDER_HOSTED variable | `true` |
| `gui.env.HAVE_ENTERPRISE` | Set the HAVE_ENTERPRISE variable | `true` |
| `gui.env.GATEWAY_IP` | Set the GATEWAY_IP variable | `k8s.hosted.mender.io` |
| `gui.env.GATEWAY_PORT` | Set the GATEWAY_PORT variable | `443` |

### Parameters: inventory

The following table lists the parameters for the `inventory` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `inventory.enabled` | Enable the component | `true` |
| `inventory.automigrate` | Enable automatic database migrations at service start up | `true` |
| `inventory.image.registry` | Docker image registry | `docker.io` |
| `inventory.image.repository` | Docker image repository | `mendersoftware/inventory-enterprise` |
| `inventory.image.tag` | Docker image tag | `mender-2.5.0` |
| `inventory.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `inventory.replicas` | Number of replicas | `1` |
| `inventory.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `inventory.resources.limits.cpu` | Resources CPU limit | `500m` |
| `inventory.resources.limits.cpu` | Resources memory limit | `128M` |
| `inventory.resources.requests.cpu` | Resources CPU limit | `100m` |
| `inventory.resources.requests.cpu` | Resources memory limit | `50M` |
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
| `tenantadm.image.repository` | Docker image repository | `mendersoftware/tenantadm-enterprise` |
| `tenantadm.image.tag` | Docker image tag | `mender-2.5.0` |
| `tenantadm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `tenantadm.replicas` | Number of replicas | `1` |
| `tenantadm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `tenantadm.resources.limits.cpu` | Resources CPU limit | `500m` |
| `tenantadm.resources.limits.cpu` | Resources memory limit | `128M` |
| `tenantadm.resources.requests.cpu` | Resources CPU limit | `200m` |
| `tenantadm.resources.requests.cpu` | Resources memory limit | `50M` |
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

### Parameters: useradm

The following table lists the parameters for the `useradm` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `useradm.enabled` | Enable the component | `true` |
| `useradm.automigrate` | Enable automatic database migrations at service start up | `true` |
| `useradm.image.registry` | Docker image registry | `registry.mender.io` |
| `useradm.image.repository` | Docker image repository | `mendersoftware/useradm-enterprise` |
| `useradm.image.tag` | Docker image tag | `mender-2.5.0` |
| `useradm.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `useradm.replicas` | Number of replicas | `1` |
| `useradm.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `useradm.resources.limits.cpu` | Resources CPU limit | `500m` |
| `useradm.resources.limits.cpu` | Resources memory limit | `128M` |
| `useradm.resources.requests.cpu` | Resources CPU limit | `100m` |
| `useradm.resources.requests.cpu` | Resources memory limit | `50M` |
| `useradm.service.name` | Name of the service | `mender-useradm` |
| `useradm.service.annotations` | Annotations map for the service | `{}` |
| `useradm.service.type` | Service type | `ClusterIP` |
| `useradm.service.loadBalancerIP` | Service load balancer IP | `nil` |
| `useradm.service.loadBalancerSourceRanges` | Service load balancer source ranges | `nil` |
| `useradm.service.port` | Port for the service | `8080` |
| `useradm.service.nodePort` | Node port for the service | `nil` |
| `useradm.env.USERADM_JWT_ISSUER` | Set the USERADM_JWT_ISSUER variable | `Mender Users` |
| `useradm.env.USERADM_JWT_EXP_TIMEOUT` | Set the USERADM_JWT_EXP_TIMEOUT variable | `604800` |
| `useradm.env.USERADM_SERVER_PRIV_KEY_PATH` | Set the USERADM_SERVER_PRIV_KEY_PATH variable | `/etc/useradm/rsa/private.pem` |
| `useradm.env.USERADM_MIDDLEWARE` | Set the USERADM_MIDDLEWARE variable | `prod` |
| `useradm.env.USERADM_TENANTADM_ADDR` | Set the USERADM_TENANTADM_ADDR variable | `http://mender-***REMOVED***8080` |
| `useradm.env.USERADM_TOTP_ISSUER` | Set the USERADM_TOTP_ISSUER variable | `Mender` |

### Parameters: workflows

The following table lists the parameters for the `workflows-server` component and their default values:

| Parameter | Description | Default |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `workflows.enabled` | Enable the component | `true` |
| `workflows.automigrate` | Enable automatic database migrations at service start up | `true` |
| `workflows.image.registry` | Docker image registry | `docker.io` |
| `workflows.image.repository` | Docker image repository | `mendersoftware/workflows-enterprise` |
| `workflows.image.tag` | Docker image tag | `mender-2.5.0` |
| `workflows.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `workflows.replicas` | Number of replicas | `1` |
| `workflows.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `workflows.resources.limits.cpu` | Resources CPU limit | `500m` |
| `workflows.resources.limits.cpu` | Resources memory limit | `128M` |
| `workflows.resources.requests.cpu` | Resources CPU limit | `200m` |
| `workflows.resources.requests.cpu` | Resources memory limit | `50M` |
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
| `create_artifact_worker.image.tag` | Docker image tag | `mender-2.5.0` |
| `create_artifact_worker.image.imagePullPolicy` | Docker image pull policy | `IfNotPresent` |
| `create_artifact_worker.replicas` | Number of replicas | `1` |
| `create_artifact_worker.affinity` | [Affinity map](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for the POD | `{}` |
| `create_artifact_worker.resources.limits.cpu` | Resources CPU limit | `500m` |
| `create_artifact_worker.resources.limits.cpu` | Resources memory limit | `128M` |
| `create_artifact_worker.resources.requests.cpu` | Resources CPU limit | `200m` |
| `create_artifact_worker.resources.requests.cpu` | Resources memory limit | `50M` |

## External services required

- mongodb
- MinIO

### Installing mongodb

You can install mongodb using the official mongodb helm chart using `helm2`:

```bash
$ helm install --name mongodb --set "usePassword=false" stable/mongodb
```

or using `helm3`:

```bash
$ helm install mongodb --set "usePassword=false" stable/mongodb
```

### Installing MinIO

You can install MinIO using the official MinIO helm chart using `helm2`:

```bash
$ helm install --name minio --set "accessKey=myaccesskey,secretKey=mysecretkey" stable/minio
```

or using `helm3`:

```bash
$ helm install minio --set "accessKey=myaccesskey,secretKey=mysecretkey" stable/minio
```

## Create a tenant and a user from command line

You can create a tenant from the command line of the `tenantadm` pod; the value printed is the newly generated tenant ID:

```bash
$ tenantadm create-org --name demo --username "admin@mender.io" --password "adminadmin"
5dcd71624143b30050e63bed
```

You can create a user from the command line of the `useradm` pod:

```bash
$ useradm create-user --username "demo@mender.io" --password "demodemo" --tenant-id "5dcd71624143b30050e63bed"
```

## Test the service through the GUI

You can port-forward the `mender-api-gateway` Kubernetes service to verify the system is up and running:

```bash
$ kubectl port-forward service/mender-api-gateway 8443:443
```
