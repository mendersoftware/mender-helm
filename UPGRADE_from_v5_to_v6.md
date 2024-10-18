# Upgrading from Helm Chart 5.x and Meneder Server 3.7.x

With the latest changes in the Helm Chart for the Mender Server,
starting from version 4.0 of the Mender Server, we’ve made some important
architectural shifts that may impact the way you use the chart and configure
your deployments. These changes are meant to streamline the way
services are handled, improve security, and fix issues with
sub-chart compatibility. For this reason, we recommend that you review the
following upgrade advices.

Until the helm chart version 5.x, the chart is compatible with both
Mender 3.6 and 3.7. Starting from Mender Server 4.0, you have to use at least the
chart version 6.0.x.

## Before you start
Ensure you have the mender values file from the previous installation.
You will need it as a base for the new installation:

```bash
cp mender-3.7.7.yml mender-values.yml
```

You can now start editing the `mender-values.yml` file with the following
changes.

## Helm Chart v6.x.x deprecations

### Global section deprecations
The `global` section is internally dedicated to the global configuration,
for sub-charts also. So we are moving the Mender resources from the `global`
key to the `default` key. For this reason, the `global.image` key is
moved to the `default.image` key: please make sure to comment out
your `global.image` key:
```yaml
global:
  # image:
  #   tag: mender-3.7.7
```

### New repositories location
Following a migration from multiple repositories to a single Monorepo, the
Container repositories has been moved to respect the new structure.
Additionally, the `mender-x.y` tag has been replaced with the `vx.y` tag.
* Enterprise registry:
  From `registry.mender.io/mendersoftware/deployments-enterprise:mender-3.7`
  to `registry.mender.io/mender-server-enterprise/deployments:v4.0`

* Open Source registry:
  From `docker.io/mendersoftware/deployments:mender-3.7`
  to `docker.io/mendersoftware/deployments:v4.0`

The new repository structure is already reflected in the default `values.yaml`
file; please make sure to not override it in your `mender-values.yaml` file.

In more details, the services without the `-enterprise` suffix in the
base name has not changed.
For the Enterprise version, all the microservices are available in the
enterprise registry as opposed to previously where the opensource ones
were residing in the Docker Hub.

### Drop the "mender-" prefix in the tags names
The new image tags drop the `mender-` prefix, so this is no longer valid:

```yaml
# previous version no longer valid
global:
  image:
    tag: mender-3.7.7
```
Instead the new tag is simply `v4.0.0`:

```yaml
# new version
default:
  image:
    tag: v4.0.0
```
The default values is handling this already, so you don't need to change it.

```yaml
global:
#  image:

default:
#  image:
```


### ImagePullSecrets instead cleartext credentials:
**Enterprise version only**: for improved security, the `global.image.username`
and `global.image.password` are deprecated in favor of `default:imagePullSecrets`:
with this new Helm Chart release, you have to manually create a new Docker
Registry secret, like this:
```bash
export MENDER_REGISTRY_USERNAME="replace-with-your-username"
export MENDER_REGISTRY_PASSWORD="replace-with-your-password"
export MENDER_REGISTRY_EMAIL="replace-with-your-email"

kubectl create secret docker-registry my-mender-pull-secret \
  --docker-username=${MENDER_REGISTRY_USERNAME} \
  --docker-password=${MENDER_REGISTRY_PASSWORD} \
  --docker-email=${MENDER_REGISTRY_EMAIL} \
  --docker-server=registry.mender.io
```
and reference it in the `mender-values.yaml` file:

```yaml
global:
  # image:
  #   username: "redacted"
  #   password: "redacted"
default:
  imagePullSecrets:
    - name: my-mender-pull-secret
```

### Rootless gui container
For improved security, the `gui` container is now rootles; this means that
the `gui.httpPort` is switched from `80` to the unprivileged `8090` port.
Make sure you are not overriding the `gui.httpPort` in your
`mender-values.yaml` file.

### Service Keys automatically generated
You can choose to specify the `device_auth.certs.key`,
`useradm.certs.key`, and `tenantadm.certs.key` keys in
the `mender-values.yaml` file, but it is not mandatory anymore.
If you don't specify them, the Helm Chart will generate them for you.

### NATS and MongoDB subcharts enabled by default
To facilitate the first Helm Chart installation, the MongoDB and NATS
subcharts are enabled by default:
```yaml
mongodb:
  enabled: true

nats:
  enabled: true
```
If you are using an external MongoDB or NATS instance, please make sure to
explicitly disable them before the upgrade:
```yaml
mongodb:
  enabled: false

nats:
  enabled: false
```

### Redis subchart disabled by default
The Redis subchart is disabled by default, because not used in the Open
Source version. If you want to use it in the Enterprise version, please
make sure to enable it:
```yaml
redis:
  enabled: true
```

### Enterprise false by default
The Enterprise version is disabled by default. If you are using it, please
make sure to enable it:
```yaml
global:
  enterprise: true
```

### Storage Proxy enabled by default
By default, the Storage Proxy is enabled. If you don't want to use it, please
restore the previous configuration:
```yaml
api_gateway:
  storage_proxy:
    enabled: false

deployments:
  customEnvs: []
```

But if you want to use it, you have to set the `DEPLOYMENTS_STORAGE_PROXY_URI`
environment variable to the URL exposed, the bucket name in the
API Gateway configuration, and the `s3.AWS_URI` to the storage endpoint:
```yaml
global:
  s3:
    AWS_URI: "${STORAGE_ENDPOINT:?must be set to your bucket endpoint URL}"
    AWS_FORCE_PATH_STYLE: "true"

api_gateway:
  storage_proxy:
    enabled: true
    url: "${STORAGE_ENDPOINT}"
    customRule: "PathRegexp(`^/${STORAGE_BUCKET:?must be set to your bucket name}`)"
    passHostHeader: false

deployments:
  customEnvs:
    - name: DEPLOYMENTS_STORAGE_PROXY_URI
      value: "https://${MENDER_SERVER_DOMAIN:?must be set to your server domain}"
```

where:
* `MENDER_SERVER_DOMAIN` is the domain of the Mender Server, e.g:
  `mender.example.com`
* `STORAGE_ENDPOINT` is the endpoint of the storage, e.g:
  `https://s3.${AWS_REGION}.amazonaws.com`
* `AWS_BUCKET` is the name of the bucket, e.g: `mender-artifacts`


## Upgrade procedure
Now you can upgrade the Helm Chart:

```bash
helm upgrade my-release -f values.yaml ./mender
```
