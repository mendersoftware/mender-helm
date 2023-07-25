# Mender Helm chart

## Version x
* Added optional `api_gateway.compression` parameter for Traefik compression
* Added optional `api_gateway.security_redirect` parameter to add a custom redirection to a company security policy
* Added optional `api_gateway.minio.customRule` to custom redirects

## Version 5.1.0
* Upgrade to Mender version `3.6.0`.
* Added `auditlogs.logRetentionSeconds` conf parameter for tuning auditlog settings
* Added Mender Ingress Resource
* **BREAKING CHANGES**:
  * This version of the Helm chart is not compatible with Mender versions older than `3.6.0`.

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
