# Mender Helm chart


# version 10.0.1
* Included MongoDB as optional dependency
* Included NATS as optional dependency
* added `_helpers.tpl` file
* added internal Ingress resource
* added support for plain `.dockerconfigjson` to create an `imagePullSecret` resource
* autogenerate private keys by default if no key is set
* migrated to appVersion: v2 dropping support from Helm v2


# Version 4.0.2
* [fix: device-auth-license-count ImagePullBackOff](https://github.com/mendersoftware/mender-helm/pull/151)

# Version 4.0.1
* Using global `registry.image.tag` instead of specifying it in every deployment

# Version 4.0.2
* [fix: device-auth-license-count ImagePullBackOff](https://github.com/mendersoftware/mender-helm/pull/151)

# Version 4.0.1
* Using global `registry.image.tag` instead of specifying it in every deployment

# Version 4.0.0
* **BREAKING CHANGE**: drop Helm v2 support: bump Helm ApiVersion to v2.
* Decoupling Helm Chart version (`version: 4.0.0`) from Mender version (`appVersion: "3.4.0"`): from now on, they can be updated independently.
* Secret `s3-artifacts` renamed to `artifacts-storage`
* Fixed variables for the `smtp` secret
* Changed `api-gateway` container ports from `80-443` to `9080-9443`
* Added `deployments-storage-daemon` cronjob
* Added `device-auth-license-count` cronjob
* Added Security Context
* Added Helm Chart Hooks: it runs db migration before the a Helm upgrade/install.
