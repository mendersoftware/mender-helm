# Mender Helm chart

## Version 5.2.5
* Added support to external Image Pull Secrets
* Added support to extraArgs to the `api_gateway` service

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
