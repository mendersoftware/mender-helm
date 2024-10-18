# Mender Helm chart

## Version 6.0.0
* **BREAKING** Incompatible with mender-server < v4.0
* **BREAKING** Update docker image references to follow new repository scheme
  * Default registry is inferred from value `global.enterprise`
    * If true:  registry.mender.io/mender-server-enterprise
    * If false: docker.io/mendersoftware
  * Default tag follows {{ Chart.AppVersion }} (starting from v4.0.0)
  * Enterprise Docker repository changed to registry.mender.io/mender-server-enterprise
  * Changes to enterprise images:
   - registry.mender.io/mendersoftware/deployments-enterprise -> registry.mender.io/mender-server-enterprise/deployments
   - registry.mender.io/mendersoftware/deviceauth-enterprise -> registry.mender.io/mender-server-enterprise/deviceauth
   - registry.mender.io/mendersoftware/inventory-enterprise -> registry.mender.io/mender-server-enterprise/inventory
   - registry.mender.io/mendersoftware/useradm-enterprise -> registry.mender.io/mender-server-enterprise/useradm
   - registry.mender.io/mendersoftware/workflows-enterprise -> registry.mender.io/mender-server-enterprise/workflows
  * workflows-worker and workflows-server uses the same image
    - docker.io/mendersoftware/workflows-worker -> docker.io/mendersoftware/workflows
    - registry.mender.io/mendersoftware/workflows-enterprise-worker -> registry.mender.io/mender-server-enterprise/workflows
* **DEPRECATION** `global.image` value is now deprecated and scheduled for removal
  * The new `default.image` is used as default image for all Mender components
  * `global.image.username` and `global.image.password` is deprecated and scheduled for removal
    * Superseded by `default.imagePullSecrets`
* All default values for service level `image` values have been unset
  * The image is resolved from `default.image`
* `tenantadm.certs.key` is no longer required.
* Autogenerate missing required secrets.
  * `device_auth.certs.key` and `useradm.certs.key` are automatically generated if value is missing.
* Changed gui httpPort default from privileged 80 to unpriviliged 8090
* Changed default `api_gateway.env.SSL` to `false`
* Changed default `global.enterprise` to `false`
* Removed deprecated redis configurations
  * `redis.username`, `redis.password`, `redis.addr`
  * These have all been replaced by the redis connection string format:
  * `redis://<username>:<password>@addr[/<db>]`
* Requires helm >= 3.10.0
