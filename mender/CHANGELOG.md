# Mender Helm chart

## Version 5.9.2
* Fix: generate delta worker mongodb secret when using an external secret and
  the mongodb subchart is enabled.

## Version 5.9.1
* Upgrade to Mender version `3.7.5`

## Version 5.9.0
* Added `pdb.maxUnavailable` option.
* Added `deviceconnect` PodDisruptionBudget

## Version 5.8.3
* Fix: correctly setup the Integration Version.

## Version 5.8.2
* Fix: correctly setup the Mender Version in the iot-manager service.

## Version 5.8.1
* Fix: managing redis connection string in the `deployments` service, when using an external Redis.

## Version 5.8.0
* Added helm chart tests.
* Default `updateStrategy.rollingUpdate.maxUnavailable` to 0 to complete the helm upgrade with
  all the services running.
* Removed `helm.sh/chart` annotation to avoid a full restart every release.
* Added Redis to the Deployments service

## Version 5.7.1
* Fix: skipping smtp secret creation when using `global.smtp.existingSecret`.
* Fix: the NATS image were not aligned with the subchart version

## Version 5.7.0
* `generate_delta_worker`: don't enforce tags for the image.
* Added `api_gateway.accesslogs` parameter to enable/disable access logs.
* Bump traefik image to v2.11.2
* Move from megabytes to mebibytes for consistency.
* Added `inventory.mongodbExistingSecret` to override the default MongoDB secret.
* Not using `HAVE_ENTERPRISE` when in hosted mode.
* Added `podMonitor` resource for monitoring the `api-gateway` service (Traefik metrics).
* Allow overriding fullname (thanks @ignatiusreza)
* Removed unused `mender.name` function.
* Added `probesOverrides` to override the default timeout for readiness and liveness probes.
* Fix naming problem in templates using api_gateway and NodePort (thanks @j-rivero)

## Version 5.6.2
* Upgrade to Mender version `3.7.4`.

## Version 5.6.1
* Upgrade NATS to version `2.9.20` with the subchart `0.19.17`.

## Version 5.6.0
* MongoDB sub-chart
  * Bump chart version to 13.18.5
  * Bump app version to MongoDB 6.0 (tag: `6.0.13`)
* Upgrade to Mender version `3.7.3`.

> If your running an existing cluster with MongoDB 5.0, we recommend following
> the upgrade procedure from the
> [official documentation](https://www.mongodb.com/docs/manual/release-notes/6.0-upgrade-replica-set/).

## 5.5.4
* fix malformed Authorization header when authRateLimit is set
* Bump traefik image to v2.11.0

## 5.5.3
* create artifact worker: change container name from workflows
* generate delta worker: change container name from workflows
* fix devicemonitor env variables
* IoT Manager: added support for an external secret containing an AES encryption key
* Workflows: added support for custom secret file mounted as a volume

## 5.5.2
* Upgrade to Mender version `3.7.2`.
* By default, `automigrate` is set to `false` for the generate delta worker and the create artifac worker services:
  the migrations are performed by migration jobs.

## 5.5.1
* Fix NATS address when `global.nats.existingSecret` is defined
* Fix indent issue when using multiple custom imagePullSecrets
* Fix artifact storage secret for the Deployments storage daemon
  when using an existing external secret
* Forcing Traefik `passHostHeader` option to `false` when using the `api_gateway.storage_proxy`
* Added `referrerPolicy: "no-referrer"` by default in Traefik
* Bump to traefik `2.10.7`
* feat: support for X-MEN-RBAC-Releases-Tags
* feat: support for custom updateStrategy
* fix missing auditlog variable in the device auth service
* fix Redis environment variables when using an external Redis
* Added `global.redis.existingSecret` option

## 5.5.0
* Fix mongodb uri creation when using the mongodb subchart and replicast architecture
* Added customEnv option to set default or per-service custom env variables
* Added generic `storage_proxy` service, that could
  work for both minio and Amazon S3, and it's going to replace the `api_gateway.minio` configuration.
* Add OpenID Connect authentication API to user authentication routes in the gateway.
* **Deprecations**:
  * `api_gateway.minio` is deprecated in favor of `api_gateway.storage_proxy`.
    This entry could be used, but it is no longer maintained, and could be removed
    in future releases.
    **How to upgrade**:
    * set `api_gateway.minio.enabled=false`
    * set `api_gateway.storage_proxy.enabled=true`
    * set `api_gateway.storage_proxy.url` to the external storage url that you want to map externally. For example `https://fleetstorage.example.com`.
      If you leave it empty, it uses the Amazon S3 external URL.


## Version 5.4.1
* Upgrade to Mender version `3.7.1`.
* Removed useless variables from the gui container.
* Added custom service account support (thanks @bdomars)

## Version 5.4.0
* Upgrade to Mender version `3.7.0`.
* Update the Redis settings to use a connection string, required by Mender 3.7.0
* **Deprecations**:
  * `global.redis.username` and `global.redis.password` are deprecated in Mender 3.7.0.
    Use redis connection string format in the `global.redis.URL`:
    * Standalone mode:
    ```
    (redis|rediss|unix)://[<user>:<password>@](<host>|<socket path>)[:<port>[/<db_number>]][?option=value]
    ```
    * Cluster mode:
    ```
    (redis|rediss|unix)[+srv]://[<user>:<password>@]<host1>[,<host2>[,...]][:<port>][?option=value]
    ```
  * `device_auth.env.DEVICEAUTH_REDIS_DB`: use the new redis connection string format instead.
  * `device_auth.env.DEVICEAUTH_REDIS_TIMEOUT_SEC`: use the new redis connection string format instead.
  * `device_auth.env.USERADM_REDIS_DB`: use the new redis connection string format instead.
  * `device_auth.env.USERADM_REDIS_TIMEOUT_SEC`: use the new redis connection string format instead.

## Version 5.3.0
* Split single db-migration job into multiple jobs
* Traefik updated to `v2.10.5`
* Upgrade to Mender version `3.6.3`.

## Version 5.2.6
* Add graceful shutdown for deviceconnect, defaults to `60s`.
* Fix: indent cronjob annotations correctly (thanks @vphoikka)

## Version 5.2.5
* Added support to external Image Pull Secrets
* Added support to extraArgs to the `api_gateway` service
* Traefik updated to `v2.10.4`
* You can now add pre-existing `priorityClassName` to the resources
* Added PodDisruptionBudget resources to the most critical services
* Added option to use existing secrets for certificates (thanks @bdomars)
* Allow to use external secrets for NATS, MongoDB, and S3 (thanks @benjamin-texier)

## Version 5.2.4
* Added HPA to the most critical services
* Reorganized `templates` directory with service subfolders
* Fixed an issue with automigrate: false

## Version 5.2.3
* `gui` service: added option for the error server block
* Upgrade to Mender version `3.6.2`.

## Version 5.2.2
* Added the `deployments.directUpload.skipVerify` parameter, defaults to `false`.
* Fix: use the `deployments.directUpload.jitter` parameter in the deployments-storage-daemon cronjob.

## Version 5.2.1
* Upgrade to Mender version `3.6.1`.

## Version 5.2.0
* MongoDB sub-chart
  * Bump app version to MongoDB 5.0 (tag: `5.0.19-debian-11-r13`)
  * Set default update strategy
  * Set default Pod Disruption Budget

> If your running an existing cluster with MongoDB 4.4, we recommend following
> the upgrade procedure from the
> [official documentation](https://www.mongodb.com/docs/manual/release-notes/5.0-upgrade-replica-set/).

## Version 5.1.0
* Upgrade to Mender version `3.6.0`.
* Added `auditlogs.logRetentionSeconds` conf parameter for tuning auditlog settings
* Added Mender Ingress Resource
* **BREAKING CHANGES**:
  * This version of the Helm chart is not compatible with Mender versions older than `3.6.0`.
* Added optional `api_gateway.compression` parameter for Traefik compression
* Added optional `api_gateway.security_redirect` parameter to add a custom redirection to a company security policy
* Added optional `api_gateway.minio.customRule` to custom redirects
* Added optional `api_gateway.authRateLimit` as a custom ratelimit for Auth module only
* Added `contentTypeNosniff` to the Traefik configuration
* Fix: missing WORKFLOWS_NATS_URI in the db-migration-job

## Version 5.0.3
* Fix: using the correct variables for useradm auditlogs settings

## Version 5.0.2
* Fix: always using the redis `master` address instead of the `headless` one, which leads to sporadic errors in writing when you have replicas in place.

## Version 5.0.1
* Fix: workaround for a [known issue](https://github.com/bitnami/charts/issues/10843) with `bitnami/mongodb` when replicaset and auth are enabled

## Version 5.0.0
* **BREAKING CHANGES**:
  * Switch Redis service to an optional sub Chart: now Redis is a global
    service: the same Redis Cluster is used by both `useradm` and `device-auth`
    services. You cannot use two different Redis Clusters.
    It's recommended to use an external Redis Cluster in Production, instead
    of the integrated sub-chart, which is enabled by default.
* Added Chart Name prefix to the Resource names
* Switch MongoDB service to optional sub Chart
* Switch NATS service to optional sub Chart

## Version 4.0.3
* [fix: issues with Amazon S3 artifact storage](https://northerntech.atlassian.net/browse/MEN-6482)

## Version 4.0.2
* [fix: device-auth-license-count ImagePullBackOff](https://github.com/mendersoftware/mender-helm/pull/151)

## Version 4.0.1
* Using global `registry.image.tag` instead of specifying it in every deployment

## Version 4.0.0
* **BREAKING CHANGE**: drop Helm v2 support: bump Helm ApiVersion to v2.
* Decoupling Helm Chart version (`version: 4.0.0`) from Mender version (`appVersion: "3.4.0"`): from now on, they can be updated independently.
* Secret `s3-artifacts` renamed to `artifacts-storage`
* Fixed variables for the `smtp` secret
* Changed `api-gateway` container ports from `80-443` to `9080-9443`
* Added `deployments-storage-daemon` cronjob
* Added `device-auth-license-count` cronjob
* Added Security Context
* Added Helm Chart Hooks: it runs db migration before the a Helm upgrade/install.
