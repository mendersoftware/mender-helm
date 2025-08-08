---
## mender-6.8.0 - 2025-08-05


### Bug fixes


- Bump traefik from 3.4.3 to 3.4.4 in /mender
 ([819130c](https://github.com/mendersoftware/mender-helm/commit/819130ca4e9742c02caaf2229bd5b9e1fc09dea5))  by @dependabot[bot]


  Bumps traefik from 3.4.3 to 3.4.4.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.4.4
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Mongodb poddistruptionbudget
 ([c3636cc](https://github.com/mendersoftware/mender-helm/commit/c3636ccade33013588a4a3991338fd0488902bf8))  by @oldgiova


  Don't specify both maxUnavailable and minAvailable which collide in a
  PodDisruptionBudget resource. By default only minAvailable: 1 is kept
  within the internal MongoDB.
- Bump traefik from 3.4.4 to 3.5.0 in /mender
 ([4018692](https://github.com/mendersoftware/mender-helm/commit/4018692ab0d342eaba29c9310d0863e5844d3e76))  by @dependabot[bot]


  Bumps traefik from 3.4.4 to 3.5.0.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.5.0
    dependency-type: direct:production
    update-type: version-update:semver-minor
  ...




### Features


- Update dependency bitnami/mongodb to 16.5.32 (AppVersion: 8.0.11)
([MEN-8594](https://northerntech.atlassian.net/browse/MEN-8594)) ([26854df](https://github.com/mendersoftware/mender-helm/commit/26854df6bf00beff29f7e3fac20195cac8d7d76b))  by @alfrunes


  Upgraded MongoDB to version 8.0. Please refer to MongoDB documentation
  before upgrading https://www.mongodb.com/docs/manual/release-notes/8.0/
  Review the "Upgrade from 7.0 to 8.0" before proceeding with the upgrade.






## mender-6.7.0 - 2025-07-02


### Bug fixes


- Device license count active by default
 ([76d2bb6](https://github.com/mendersoftware/mender-helm/commit/76d2bb66881b6f583705f0e2246f7a7170ce0cc7))  by @oldgiova
- Bump traefik from 3.4.1 to 3.4.3 in /mender
 ([8b20307](https://github.com/mendersoftware/mender-helm/commit/8b20307ebbc6a06a5f50db943ba078ce0663c07e))  by @dependabot[bot]


  Bumps traefik from 3.4.1 to 3.4.3.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.4.3
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...




### Features


- *(api-gateway)* Add deployment annotations to template
 ([15b5998](https://github.com/mendersoftware/mender-helm/commit/15b5998bd110744b631165b117f1305a0abcdf56))  by @chriswiggins







## mender-6.6.1 - 2025-06-18


### Bug Fixes


- Removed duplicated PeriodSeconds
 ([8c2ad46](https://github.com/mendersoftware/mender-helm/commit/8c2ad46d2f5d2459c867fc89bd7329ae4c745ec9))  by @oldgiova






## mender-6.6.0 - 2025-06-18


### Bug Fixes


- Some migration jobs don't run for open source
 ([c9dec92](https://github.com/mendersoftware/mender-helm/commit/c9dec9298954fcc356fe7dd37f1c47e1a1e3cc6e))  by @oldgiova


  The migration jobs for the Workflows and Useradm service are not running
  for the Open Source helm chart by default. This fix enables them.
- Avoid useless gui wait start
 ([0bee899](https://github.com/mendersoftware/mender-helm/commit/0bee899f32b026b7e569761017ba96d38513ac40))  by @oldgiova


  The gui container used to have a js minify build which has been
  refactored long ago and this waiting time is a leftover. Removing it.




### Features


- Automigrate false by default
 ([5ebb642](https://github.com/mendersoftware/mender-helm/commit/5ebb642507e4b35c9ff64ea74b6c7ab1275c5bec))  by @oldgiova


  Switching off the automigrate feature from the services when they start:
  the migration is completely delegated to the jobs invoked by Helm
  Install/Upgrade hooks
- Add value ingress.extraPaths.backend.servicePortNumber
 ([3a4856a](https://github.com/mendersoftware/mender-helm/commit/3a4856aa63110362d664814659d13a8ca0241af0))  by @alfrunes


  The new parameter allows specifying a numeric port number instead of
  name to configure additional ingress routes.






## mender-6.5.0 - 2025-06-06


### Bug Fixes


- Bump traefik from 3.4.0 to 3.4.1 in /mender
 ([a4fd9a3](https://github.com/mendersoftware/mender-helm/commit/a4fd9a302950a93b9f445c7e167e34d19249ebf2))  by @dependabot[bot]


  Bumps traefik from 3.4.0 to 3.4.1.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.4.1
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Display Mender Version
 ([41a0d0d](https://github.com/mendersoftware/mender-helm/commit/41a0d0d7bcc245a4404ca50a076f7b86ae151799))  by @oldgiova


  Avoid nil pointer exception when default.image.tag is not set




### Features


- Add configurable artifacts upload size
 ([bae5288](https://github.com/mendersoftware/mender-helm/commit/bae5288c8a9c6ee25ae053b8544d207e8c9c6e58))  by @oldgiova
- Add configurable requests data size
 ([da4bc9a](https://github.com/mendersoftware/mender-helm/commit/da4bc9a96762abe98ddf481e0d9d455bfaa16df4))  by @oldgiova






## mender-6.4.2 - 2025-05-27


### Bug Fixes


- Mender server update to 4.0.1
 ([2949f8a](https://github.com/mendersoftware/mender-helm/commit/2949f8a76bde79ed852e859624939e9476481e70))  by @kjaskiewiczz
- Display Mender Version
 ([ef9463d](https://github.com/mendersoftware/mender-helm/commit/ef9463d63092ddb79199e941d53c943b43f64f9e))  by @oldgiova


  Display the actual Mender version based on the computed Tag, not just on
  Chart.Appversion






## mender-6.4.1 - 2025-05-20


### Bug Fixes


- Bump traefik from 3.3.6 to 3.4.0 in /mender
 ([0b970c2](https://github.com/mendersoftware/mender-helm/commit/0b970c2e10332ca232e2329da4fa69cd383a3a52))  by @dependabot[bot]


  Bumps traefik from 3.3.6 to 3.4.0.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.4.0
    dependency-type: direct:production
    update-type: version-update:semver-minor
  ...






## mender-6.4.0 - 2025-05-09


### Bug Fixes


- Bump traefik from 3.3.5 to 3.3.6 in /mender
 ([34da58e](https://github.com/mendersoftware/mender-helm/commit/34da58ed75c81e91c29fe5725b298ab59cf3a36a))  by @dependabot[bot]


  Bumps traefik from 3.3.5 to 3.3.6.
  
  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.3.6
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...




### Documentation


- Update yaml customize links
 ([3492bef](https://github.com/mendersoftware/mender-helm/commit/3492bef1a84a2b27811d19e778ce7ddaf1d34421))  by @guspan-tanadi




### Features


- Added Mender HTTP headers to display the chart version + name
 ([f513a45](https://github.com/mendersoftware/mender-helm/commit/f513a450651328a158a6b4ac63ca5684be5e83af))  by @mzedel
- Add minReadySeconds
 ([fa14a2d](https://github.com/mendersoftware/mender-helm/commit/fa14a2db7387691b8222c1236ddbd315259dd9a1))  by @oldgiova


  minReadySeconds could be useful when a new deployment came, and you
  have to coinsider the pod ready some time after the readinessProbe
- Slow gui start to startupProbe
 ([f19bdd1](https://github.com/mendersoftware/mender-helm/commit/f19bdd10f7bf5c3306f4e63b2e632ed2685566eb))  by @oldgiova


  The gui container is slow starting because of js minify at container
  startup. Previously, the slow start was managed by minReadySeconds, this
  commit moves it to the startupProbe instead, with an initialDelaySeconds
  of 120s






## mender-6.3.2 - 2025-04-08


### Bug Fixes


- Set ingress namespace explicit
 ([64dba39](https://github.com/mendersoftware/mender-helm/commit/64dba399d3cf7761a159a69179b25f4be36035e9))  by @oldgiova


  When templating the helm chart, the ingress doesn't came with a named
  namespace. This could be an issue when you apply the manifests generated
  from the helm template
- Bump traefik from 3.3.4 to 3.3.5 in /mender
 ([38621a7](https://github.com/mendersoftware/mender-helm/commit/38621a7460bc3aedf58d51dce77f8c0793fa25d3))  by @dependabot[bot]


  Bumps traefik from 3.3.4 to 3.3.5.





### Documentation


- Fixed documented default for redis state
 ([b3c6ecd](https://github.com/mendersoftware/mender-helm/commit/b3c6ecd97dd21a346a6a907e72011f0bc4a93ab6))  by @nickanderson






## mender-6.3.1 - 2025-03-12


### Bug Fixes


- Bump traefik from 3.3.3 to 3.3.4 in /mender
 ([ee48fe1](https://github.com/mendersoftware/mender-helm/commit/ee48fe19502662a28cac58a1ef1ed4d6ebab3b1a))  by @dependabot[bot]


  Bumps traefik from 3.3.3 to 3.3.4.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Use mongodb secret variable if present
 ([1c5e091](https://github.com/mendersoftware/mender-helm/commit/1c5e091e3f702f079bbe5157904f9b6db6fccd6a))  by @thall


  If mongodb secret is configured, cronjob will fail to start with error
  message `secret "mongodb-common" not found: CreateContainerConfigError`,
  since the hardcoded secret will be used instead of the configured one.

  This should probably have been updated when this PR was submitted:
  https://github.com/mendersoftware/mender-helm/pull/392






## mender-6.3.0 - 2025-02-27


### Features


- *(api-gateway)* Switch tls certificate to k8s tls type
 ([58687a0](https://github.com/mendersoftware/mender-helm/commit/58687a0a22b809c8c6229f255a981165f8acb4bf))  by @chriswiggins

- Enable featureGates parameter for the k8sTlsSecrets
 ([3c907b6](https://github.com/mendersoftware/mender-helm/commit/3c907b6be200296f9f3cc80028cc9b04de5f3a11))  by @oldgiova


  Commit 58687a0a22b809c8c6229f255a981165f8acb4bf introduces a breaking
  change when using api_gateway.certs.existingSecrets; by introducing the
  featureGates.k8sTlsSecrets option, the new feature is optional.






## mender-6.2.1 - 2025-02-26


### Revert


- "Merge pull request #443 from chriswiggins/feat/apigateway-tls-secret"
 ([3b831be](https://github.com/mendersoftware/mender-helm/commit/3b831be9b25e72f45626ca592cc19ec9fc04a85c))  by @alfrunes


  Retracting breaking change from mender-helm v6.2

  This reverts commit d6979f7529c5a779a1af7a37b64c8811cdd84f29, reversing
  changes made to 7a61679d5b70e0f070a665fd499f4b99e3beb260.






## mender-6.2.0 - 2025-02-26


### Features


- *(api-gateway)* Switch tls certificate to k8s tls type
 ([2117620](https://github.com/mendersoftware/mender-helm/commit/21176200d44d5ab2a4dcad3b5dad45f34f832f63))  by @chriswiggins







## mender-6.1.0 - 2025-02-19


### Features


- Optionals deviceauth cronjobs
 ([a170750](https://github.com/mendersoftware/mender-helm/commit/a17075072d55d5ca7fa2f76d6c40d744357344a5))  by @oldgiova


  You can create custom cronjobs based on the deviceauth service.
  This feature is going to deprecate the device_license_count feature,
  that could be installed as a custom cronjob, with the provided example
  in the Values file.
  The device_license_count key will be removed in the future.






## mender-6.0.1 - 2025-02-12


### Bug Fixes


- Bump traefik from v3.3.1 to 3.3.3 in /mender
 ([c70fe05](https://github.com/mendersoftware/mender-helm/commit/c70fe0504df3a8cf7939a7ad5e5f8e5621b368ac))  by @dependabot[bot]






# Changelog

## [6.8.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.7.0...mender-6.8.0) (2025-08-05)


### Features

* Update dependency bitnami/mongodb to 16.5.32 (AppVersion: 8.0.11) ([de817b5](https://github.com/mendersoftware/mender-helm/commit/de817b563c186f33fbbff5c86cb27b9bb7ce0bcc))
* Update dependency bitnami/mongodb to 16.5.32 (AppVersion: 8.0.11) ([26854df](https://github.com/mendersoftware/mender-helm/commit/26854df6bf00beff29f7e3fac20195cac8d7d76b))


### Bug Fixes

* bump traefik from 3.4.3 to 3.4.4 in /mender ([44bca94](https://github.com/mendersoftware/mender-helm/commit/44bca94c15f2d6d610fc995abf1d661b3e0c00f6))
* bump traefik from 3.4.3 to 3.4.4 in /mender ([819130c](https://github.com/mendersoftware/mender-helm/commit/819130ca4e9742c02caaf2229bd5b9e1fc09dea5))
* bump traefik from 3.4.4 to 3.5.0 in /mender ([ae29c3d](https://github.com/mendersoftware/mender-helm/commit/ae29c3df2280da5fafa64a76d89eaaed5152a1f5))
* bump traefik from 3.4.4 to 3.5.0 in /mender ([4018692](https://github.com/mendersoftware/mender-helm/commit/4018692ab0d342eaba29c9310d0863e5844d3e76))
* mongodb poddistruptionbudget ([968b474](https://github.com/mendersoftware/mender-helm/commit/968b4744b0d996d068f5b6a6cb7f3dc635499d73))
* mongodb poddistruptionbudget ([c3636cc](https://github.com/mendersoftware/mender-helm/commit/c3636ccade33013588a4a3991338fd0488902bf8))

## [6.7.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.6.1...mender-6.7.0) (2025-07-02)


### Features

* **api-gateway:** add deployment annotations to template ([15b5998](https://github.com/mendersoftware/mender-helm/commit/15b5998bd110744b631165b117f1305a0abcdf56))


### Bug Fixes

* bump traefik from 3.4.1 to 3.4.3 in /mender ([b2ad3da](https://github.com/mendersoftware/mender-helm/commit/b2ad3da54f6f5f622865d34758137946c5a3a831))
* bump traefik from 3.4.1 to 3.4.3 in /mender ([8b20307](https://github.com/mendersoftware/mender-helm/commit/8b20307ebbc6a06a5f50db943ba078ce0663c07e))

## [6.6.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.6.0...mender-6.6.1) (2025-06-18)


### Bug Fixes

* removed duplicated PeriodSeconds ([f0a313c](https://github.com/mendersoftware/mender-helm/commit/f0a313c373de4e0f6d452a2e0c00a31adb75ca1d))
* removed duplicated PeriodSeconds ([8c2ad46](https://github.com/mendersoftware/mender-helm/commit/8c2ad46d2f5d2459c867fc89bd7329ae4c745ec9))

## [6.6.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.5.0...mender-6.6.0) (2025-06-18)


### Features

* Add value ingress.extraPaths.backend.servicePortNumber ([c11e7b0](https://github.com/mendersoftware/mender-helm/commit/c11e7b0ca5b8725f22d270a650428a8e00ed9a99))
* Add value ingress.extraPaths.backend.servicePortNumber ([3a4856a](https://github.com/mendersoftware/mender-helm/commit/3a4856aa63110362d664814659d13a8ca0241af0))
* automigrate false by default ([63ace82](https://github.com/mendersoftware/mender-helm/commit/63ace820be478c6a51e0664b9d8e087f84df2cb1))
* automigrate false by default ([5ebb642](https://github.com/mendersoftware/mender-helm/commit/5ebb642507e4b35c9ff64ea74b6c7ab1275c5bec))


### Bug Fixes

* avoid useless gui wait start ([46e148d](https://github.com/mendersoftware/mender-helm/commit/46e148d17ab125001ecf0ab47895086b84a2b76d))
* avoid useless gui wait start ([0bee899](https://github.com/mendersoftware/mender-helm/commit/0bee899f32b026b7e569761017ba96d38513ac40))
* some migration jobs don't run for open source ([4601995](https://github.com/mendersoftware/mender-helm/commit/4601995e5b91036244f2ed5ab8ed2bed85e9dcf5))
* some migration jobs don't run for open source ([c9dec92](https://github.com/mendersoftware/mender-helm/commit/c9dec9298954fcc356fe7dd37f1c47e1a1e3cc6e))

## [6.5.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.4.2...mender-6.5.0) (2025-06-06)


### Features

* add configurable artifacts upload size ([4b919ce](https://github.com/mendersoftware/mender-helm/commit/4b919ce09a49809fc67c00df5d754a1d408ffa3a))
* add configurable artifacts upload size ([bae5288](https://github.com/mendersoftware/mender-helm/commit/bae5288c8a9c6ee25ae053b8544d207e8c9c6e58))
* add configurable requests data size ([da4bc9a](https://github.com/mendersoftware/mender-helm/commit/da4bc9a96762abe98ddf481e0d9d455bfaa16df4))


### Bug Fixes

* bump traefik from 3.4.0 to 3.4.1 in /mender ([f796911](https://github.com/mendersoftware/mender-helm/commit/f7969118dff2b103006078fa62a3471c110e47c0))
* bump traefik from 3.4.0 to 3.4.1 in /mender ([a4fd9a3](https://github.com/mendersoftware/mender-helm/commit/a4fd9a302950a93b9f445c7e167e34d19249ebf2))
* display Mender Version ([1c30c47](https://github.com/mendersoftware/mender-helm/commit/1c30c472b38302f76e3f50f78da5a9220256cef2))
* display Mender Version ([41a0d0d](https://github.com/mendersoftware/mender-helm/commit/41a0d0d7bcc245a4404ca50a076f7b86ae151799))

## [6.4.2](https://github.com/mendersoftware/mender-helm/compare/mender-6.4.1...mender-6.4.2) (2025-05-27)


### Bug Fixes

* display Mender Version ([1c04381](https://github.com/mendersoftware/mender-helm/commit/1c04381a20f8c4a0f65b4b1d1051b2b30a492175))
* display Mender Version ([ef9463d](https://github.com/mendersoftware/mender-helm/commit/ef9463d63092ddb79199e941d53c943b43f64f9e))
* mender server update to 4.0.1 ([e7eebad](https://github.com/mendersoftware/mender-helm/commit/e7eebad013e35461e5aff1499d909bc1b50c54a9))
* mender server update to 4.0.1 ([2949f8a](https://github.com/mendersoftware/mender-helm/commit/2949f8a76bde79ed852e859624939e9476481e70))

## [6.4.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.4.0...mender-6.4.1) (2025-05-20)


### Bug Fixes

* bump traefik from 3.3.6 to 3.4.0 in /mender ([32bb851](https://github.com/mendersoftware/mender-helm/commit/32bb851fb406c9814d0c8ee7198f6c6853e29ade))
* bump traefik from 3.3.6 to 3.4.0 in /mender ([0b970c2](https://github.com/mendersoftware/mender-helm/commit/0b970c2e10332ca232e2329da4fa69cd383a3a52))

## [6.4.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.3.2...mender-6.4.0) (2025-05-09)


### Features

* add minReadySeconds ([c752189](https://github.com/mendersoftware/mender-helm/commit/c752189084afd4daa06a2c8eeca3eb08b64fe712))
* add minReadySeconds ([fa14a2d](https://github.com/mendersoftware/mender-helm/commit/fa14a2db7387691b8222c1236ddbd315259dd9a1))
* added Mender HTTP headers to display the chart version + name ([f513a45](https://github.com/mendersoftware/mender-helm/commit/f513a450651328a158a6b4ac63ca5684be5e83af))
* slow gui start to startupProbe ([f19bdd1](https://github.com/mendersoftware/mender-helm/commit/f19bdd10f7bf5c3306f4e63b2e632ed2685566eb))


### Bug Fixes

* bump traefik from 3.3.5 to 3.3.6 in /mender ([801926b](https://github.com/mendersoftware/mender-helm/commit/801926b598743470b2d91013ed2b5c2a8ac803c6))
* bump traefik from 3.3.5 to 3.3.6 in /mender ([34da58e](https://github.com/mendersoftware/mender-helm/commit/34da58ed75c81e91c29fe5725b298ab59cf3a36a))

## [6.3.2](https://github.com/mendersoftware/mender-helm/compare/mender-6.3.1...mender-6.3.2) (2025-04-08)


### Bug Fixes

* bump traefik from 3.3.4 to 3.3.5 in /mender ([7aa788c](https://github.com/mendersoftware/mender-helm/commit/7aa788c331823f92526e7982c3d593c37f237900))
* bump traefik from 3.3.4 to 3.3.5 in /mender ([38621a7](https://github.com/mendersoftware/mender-helm/commit/38621a7460bc3aedf58d51dce77f8c0793fa25d3))
* set ingress namespace explicit ([3604252](https://github.com/mendersoftware/mender-helm/commit/3604252e21fbe9c83790377810bdbf12e2669dc1))
* set ingress namespace explicit ([64dba39](https://github.com/mendersoftware/mender-helm/commit/64dba399d3cf7761a159a69179b25f4be36035e9))

## [6.3.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.3.0...mender-6.3.1) (2025-03-12)


### Bug Fixes

* bump traefik from 3.3.3 to 3.3.4 in /mender ([55b8e3c](https://github.com/mendersoftware/mender-helm/commit/55b8e3c01f317c10426273de23b6e3c67b0d799f))
* bump traefik from 3.3.3 to 3.3.4 in /mender ([ee48fe1](https://github.com/mendersoftware/mender-helm/commit/ee48fe19502662a28cac58a1ef1ed4d6ebab3b1a))
* **deployments:** use mongodb secret variable if present ([884ca84](https://github.com/mendersoftware/mender-helm/commit/884ca840c494372c1b2122b12f86318309767b7c))
* use mongodb secret variable if present ([1c5e091](https://github.com/mendersoftware/mender-helm/commit/1c5e091e3f702f079bbe5157904f9b6db6fccd6a))

## [6.3.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.2.1...mender-6.3.0) (2025-02-27)


### Features

* **api-gateway:** switch tls certificate to k8s tls type ([58687a0](https://github.com/mendersoftware/mender-helm/commit/58687a0a22b809c8c6229f255a981165f8acb4bf))
* enable featureGates parameter for the k8sTlsSecrets ([3c907b6](https://github.com/mendersoftware/mender-helm/commit/3c907b6be200296f9f3cc80028cc9b04de5f3a11))

## [6.2.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.2.0...mender-6.2.1) (2025-02-26)


### Reverts

* "Merge pull request [#443](https://github.com/mendersoftware/mender-helm/issues/443) from chriswiggins/feat/apigateway-tl… ([f22031c](https://github.com/mendersoftware/mender-helm/commit/f22031ce7e5a537956b59c2a932ddfe7311d87c4))
* "Merge pull request [#443](https://github.com/mendersoftware/mender-helm/issues/443) from chriswiggins/feat/apigateway-tls-secret" ([3b831be](https://github.com/mendersoftware/mender-helm/commit/3b831be9b25e72f45626ca592cc19ec9fc04a85c))

## [6.2.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.1.0...mender-6.2.0) (2025-02-26)


### Features

* **api-gateway:** switch tls certificate to k8s tls type ([2117620](https://github.com/mendersoftware/mender-helm/commit/21176200d44d5ab2a4dcad3b5dad45f34f832f63))

## [6.1.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.0.1...mender-6.1.0) (2025-02-19)


### Features

* optionals deviceauth cronjobs ([a170750](https://github.com/mendersoftware/mender-helm/commit/a17075072d55d5ca7fa2f76d6c40d744357344a5))

## [6.0.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.0.0...mender-6.0.1) (2025-02-12)


### Bug Fixes

* bump traefik from v3.3.1 to 3.3.3 in /mender ([c70fe05](https://github.com/mendersoftware/mender-helm/commit/c70fe0504df3a8cf7939a7ad5e5f8e5621b368ac))


## mender-6.0.0 - 2025-02-11


### Bug Fixes


- Passing string to object value `nats.image`
 ([31faa8a](https://github.com/mendersoftware/mender-helm/commit/31faa8ae5025b8be378b480cbef6b180754583fb))  by @alfrunes
- `tenantadm.certs` are no longer required
 ([d74b41c](https://github.com/mendersoftware/mender-helm/commit/d74b41c975529024f5a80ebe391fd8df0ded0dc2))  by @alfrunes
  - **BREAKING**: `tenantadm.certs` are no longer required


  Starting with Mender server v4.0.0 the secret is no longer in used.
  The secret is not created/mounted to the service unless explicitly
  specified.
- Change gui default targetPort to 8090
 ([9f42928](https://github.com/mendersoftware/mender-helm/commit/9f42928daebc7d377db6f074a0e9be1cd099962e))  by @alfrunes
  - **BREAKING**: Change gui default targetPort to 8090
- Changed default `global.enterprise` to false
 ([fd7676d](https://github.com/mendersoftware/mender-helm/commit/fd7676d78d483daa73e8661776e10f06fc5df77c))  by @alfrunes
- Remove deprecated redis values
 ([356a3eb](https://github.com/mendersoftware/mender-helm/commit/356a3eb4eb624f82e7442ae9ff7380c7b8d1e0a2))  by @alfrunes
- Traefik container ports optionals
([MEN-7595](https://northerntech.atlassian.net/browse/MEN-7595)) ([9654235](https://github.com/mendersoftware/mender-helm/commit/9654235292dfeeeb0d1f9d203e5faffc5b9ed230))  by @oldgiova


  You can choose to not to set either httpPort or httpsPort in the
  api_gateway, to prevent upload timeout with the Mender Cli, as reported
  by customers.
- Add http timeouts, only apply https timeouts when https is enabled
 ([9ead1c8](https://github.com/mendersoftware/mender-helm/commit/9ead1c8e3b7942b80e1d238a0b535c7ff1b58087))  by @chriswiggins
- Tenantadm endpoint fix
 ([14f15a1](https://github.com/mendersoftware/mender-helm/commit/14f15a16faf3ede3b49eefb5a820be8695a69f10))  by @oldgiova
- Consistency between nats_uri declaration
 ([e904956](https://github.com/mendersoftware/mender-helm/commit/e904956f1ad3ef1915aade0844582ac7b9dedcbc))  by @oldgiova


  Aligned the nats_uri of the deviceconnect and the workflows definitions to the other services.
  Commit: 98d383249b909ae1920a0aba5c97f36c49f307ac
- Remove errorPort from gui
 ([88f0a43](https://github.com/mendersoftware/mender-helm/commit/88f0a4355bae41b3ebe1fd316f791eb22b3a22ce))  by @oldgiova
  - **BREAKING**: remove errorPort from gui


  Follow up removing the error reponder middleware from Traefik
- Bump Traefik to v3.3.1
 ([8fff88e](https://github.com/mendersoftware/mender-helm/commit/8fff88ea6734ef16315ab8d0847f0974f2a96dd8))  by @alfrunes
- Use more sensible defaults when storage proxy is enabled
 ([fdfa432](https://github.com/mendersoftware/mender-helm/commit/fdfa43231bc7cfec35cc8572fc7142cb057c7bdd))  by @alfrunes


  Set storage.proxy_uri setting in deployments to the public URL
  {{.Values.global.url}}.
- Use sample global.url to avoid confusion
 ([99ab65e](https://github.com/mendersoftware/mender-helm/commit/99ab65ebfe0258b2f9d6688c05662ffeffaa91c7))  by @oldgiova


  Set default .Values.global.url to the sample public URL to avoid
  confusion.
- Remove tenantadm.env.TENANTADM_ORCHESTRATOR_ADDR value
 ([c4f6f2d](https://github.com/mendersoftware/mender-helm/commit/c4f6f2dfbdcefa4c20287cd80e50addd339652ed))  by @alfrunes


  The value should be inferred from the workflows service name and port.
- Add and replace configuration values for internal addresses
 ([aae4180](https://github.com/mendersoftware/mender-helm/commit/aae4180cc2a919b8f01f7eebd38d15644e36b2d2))  by @alfrunes


  The internal addresses are uniquely determined from the name and port of
  the respective service. They should not be configurable. The following
  values have been removed and will be ineffectual:
  - `device_auth.env.DEVICEAUTH_INVENTORY_ADDR`
  - `device_auth.env.DEVICEAUTH_ORCHESTRATOR_ADDR`
  - `device_auth.env.DEVICEAUTH_TENANTADM_ADDR`
  - `useradm.env.USERADM_TENANTADM_ADDR`
  - `devicemonitor.env.DEVICEMONITOR_USERADM_URL`
  - `devicemonitor.env.DEVICEMONITOR_WORKFLOWS_URL`
- Use correct device_auth key
 ([a138560](https://github.com/mendersoftware/mender-helm/commit/a138560c3cd46c2061ea0c8dbc3ea9686d3e7969))  by @oldgiova




### Documentation


- Added remark about global.image.username/password to changelog
 ([360ed7a](https://github.com/mendersoftware/mender-helm/commit/360ed7aac1e024fb9655f5e5bb9e9a7b241a23d6))  by @alfrunes
- New v6.x setup
 ([df07622](https://github.com/mendersoftware/mender-helm/commit/df076223f8c5c6fb60714eeb26cef101098b1b1a))  by @oldgiova


  With Seaweedfs, v6 breaking changes, and a dedicated upgrade document
- Fix typo in default value for IoT Manager service name
 ([178e89d](https://github.com/mendersoftware/mender-helm/commit/178e89deaf25e040a21ef6db83ed6d28724e2785))  by @alfrunes




### Features


- Update docker image references to follow new repository scheme
 ([cd1a87a](https://github.com/mendersoftware/mender-helm/commit/cd1a87aafd1e539a618b8417b83537d5c2c72bcb))  by @alfrunes
  - **BREAKING**: See UPGRADE_from_v5_to_v6.md
- Autogenerate required useradm/deviceauth secrets
 ([501dfaf](https://github.com/mendersoftware/mender-helm/commit/501dfaf6988b41ec7b918e7f62ffc55be4c63c0c))  by @alfrunes
- Add gui hpa
 ([44a693a](https://github.com/mendersoftware/mender-helm/commit/44a693ab6d83a6b488df45409121e7df9704e066))  by @oldgiova


  Added Horizontal Pod Autoscaler resource to the gui container, to scale
  it automatically when the service experiences more load.
- Mongodb sub-chart enabled by default
 ([7d21622](https://github.com/mendersoftware/mender-helm/commit/7d216224eada725facf37405d9b4456b0970e92c))  by @oldgiova
  - **BREAKING**: mongodb sub-chart enabled by default


  To ease the Mender Server onboarding for Open source users.
  If you want to use an external provided MongoDB, make sure to disable
  it.
- NATS sub-chart enabled by default
 ([9218f04](https://github.com/mendersoftware/mender-helm/commit/9218f047f8968aa16549132f6f536b7c6f7ba97b))  by @oldgiova
  - **BREAKING**: NATS sub-chart enabled by default


  To ease the Mender Server onboarding for Open source users.
  If you want to use an external provided NATS, make sure to disable
  it.
- Redis subchart disabled by default
 ([2a7790a](https://github.com/mendersoftware/mender-helm/commit/2a7790ae5f60a77290aafc9aa67aa861cfe0f2ba))  by @oldgiova
  - **BREAKING**: redis subchart disabled by default


  Redis is not used by default in the Open source version. Letting it
  enabled generates confusion, so let's disable it.
- Storage proxy enabled by default
 ([3b9cfd2](https://github.com/mendersoftware/mender-helm/commit/3b9cfd23f2fa7e31fc8f59769d78c8cf63e7fc17))  by @oldgiova
  - **BREAKING**: storage proxy enabled by default


  The default install proposes the storage proxy feature enabled by
  default to a simplify onboarding experience
- Added mongodb secret override
([MEN-6493](https://northerntech.atlassian.net/browse/MEN-6493)) ([e7e4326](https://github.com/mendersoftware/mender-helm/commit/e7e4326cfdb24840154312e13077f692be74f377))  by @oldgiova


  With this override, you can choose a different secret for the
  deployments service, for example a secondary connection or a admin
  connection
- Maintenance cronjobs
 ([78e5ff3](https://github.com/mendersoftware/mender-helm/commit/78e5ff366ac23a6d1a10f4fd78983167c4f90f76))  by @oldgiova


  Added optional cronjobs for tenantadm and iot-manager services. A
  possible use case is to periodically delete suspended tenants that has
  been created for testing purposes.
- Upgrade dependency MongoDB to 7.0
 ([5a2fb43](https://github.com/mendersoftware/mender-helm/commit/5a2fb43ed0b8201ce4cbbf99096182126076a7ed))  by @alfrunes
  - **BREAKING**: Upgrade MongoDB dependency from 6.0 to 7.0


  In this release we have upgraded mongodb to the next major version.
  Please ensure you have a recent backup of the database before proceeding
  with the upgrade.
  Please consult with the official MongoDB documentation before proceeding
  https://www.mongodb.com/docs/manual/release-notes/7.0-upgrade-replica-set/




### Refactor


- *(workflows)* Made workflows template arguments easier to read
 ([87c10ff](https://github.com/mendersoftware/mender-helm/commit/87c10ff848583eb3a982eb5c2565436d5fad6224))  by @alfrunes

- Consistency between nats_uri declaration
 ([5cd5841](https://github.com/mendersoftware/mender-helm/commit/5cd5841a9a95f125442dd84827ef69157148f87e))  by @oldgiova


  Aligned the nats_uri of the deviceconnect and the workflows definitions to the other services.
  Commit: 98d383249b909ae1920a0aba5c97f36c49f307ac


- Consistency between nats_uri declaration
 ([98d3832](https://github.com/mendersoftware/mender-helm/commit/98d383249b909ae1920a0aba5c97f36c49f307ac))  by @oldgiova


  Aligned the nats_uri of the deviceconnect and the workflows definitions to the other services




### Typo


- Update UPGRADE_from_v5_to_v6.md
 ([f4256fc](https://github.com/mendersoftware/mender-helm/commit/f4256fcc4d4d876a827fa60510ddb51df31857a2))  by @LinAnt


  Fixes typo in the header





---
