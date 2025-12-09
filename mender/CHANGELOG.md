---
## mender-7.2.1 - 2025-11-25


### Bug fixes


- Bump traefik from 3.6.0 to 3.6.2 in /mender
 ([fb0f52f](https://github.com/mendersoftware/mender-helm/commit/fb0f52f087f69104dceb696f436504256e9db297))  by @dependabot[bot]


  Bumps traefik from 3.6.0 to 3.6.2.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.6.2
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Bump redis from 8.2.3-alpine to 8.4.0-alpine in /mender
 ([6969656](https://github.com/mendersoftware/mender-helm/commit/6969656e00dae57020932891d52e073f79a3aec5))  by @dependabot[bot]


  Bumps redis from 8.2.3-alpine to 8.4.0-alpine.

  ---
  updated-dependencies:
  - dependency-name: redis
    dependency-version: 8.4.0-alpine
    dependency-type: direct:production
    update-type: version-update:semver-minor
  ...






## mender-7.1.1 - 2025-11-13


### Bug fixes


- Right PodDisruptionBudget selector
 ([4ad0b5d](https://github.com/mendersoftware/mender-helm/commit/4ad0b5d08892139465cef69c0cf61e941e7c4d74))  by @oldgiova


  The selector label `run` was replaced by app.kubernetes.io/name






## mender-7.1.0 - 2025-11-12


### Bug fixes


- *(tenantadm)* Remove duplicate devicemonitor alert rate limit rule
([MEN-8984](https://northerntech.atlassian.net/browse/MEN-8984)) ([457ac3a](https://github.com/mendersoftware/mender-helm/commit/457ac3a37c2b7e774c95575d314459b43e6d6390))  by @frodeha


  Remove a duplicated devicemonitor alert rate limit burst rule from the
  default rate limit rules configured in tenantadm. The duplicated rule
  caused the rate limiter to always limit requests to the endpoint unless the
  default rules were overridden.





### Features


- Added value `api_gateway.customEnv`
 ([19eac9a](https://github.com/mendersoftware/mender-helm/commit/19eac9a2f28e53b98cadc5cede199c04c8d9815b))  by @alfrunes


  The value follows the same convention for setting custom environment
  variables as all other helm values with the same name.






## mender-7.0.4 - 2025-11-11


### Bug fixes


- Bump redis from 8.2.2-alpine to 8.2.3-alpine in /mender
 ([73d360a](https://github.com/mendersoftware/mender-helm/commit/73d360a22d6885c3e4a848022041232d6e464012))  by @dependabot[bot]


  Bumps redis from 8.2.2-alpine to 8.2.3-alpine.

  ---
  updated-dependencies:
  - dependency-name: redis
    dependency-version: 8.2.3-alpine
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Bump traefik from 3.5.4 to 3.6.0 in /mender
 ([55c62f6](https://github.com/mendersoftware/mender-helm/commit/55c62f6545cc7a10e0a978aef1f7160b061f1da7))  by @dependabot[bot]


  Bumps traefik from 3.5.4 to 3.6.0.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.6.0
    dependency-type: direct:production
    update-type: version-update:semver-minor
  ...






## mender-7.0.3 - 2025-11-04


### Bug fixes


- Bump traefik from 3.5.3 to 3.5.4 in /mender
 ([2432f56](https://github.com/mendersoftware/mender-helm/commit/2432f56f87a0c65cba4d53a1a12f13277a47d780))  by @dependabot[bot]


  Bumps traefik from 3.5.3 to 3.5.4.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.5.4
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...






## mender-7.0.2 - 2025-11-01


### Bug fixes


- Add missing podAnnotations for gui deployment
 ([5c531a6](https://github.com/mendersoftware/mender-helm/commit/5c531a6941700177059e473f8a978ea80e194115))  by @whiite






## mender-7.0.1 - 2025-10-07


### Bug fixes


- Bump redis from 8.2.1-alpine to 8.2.2-alpine in /mender
 ([97e70ec](https://github.com/mendersoftware/mender-helm/commit/97e70ecc547fa347fad902f6bfe958474bcd58b4))  by @dependabot[bot]


  Bumps redis from 8.2.1-alpine to 8.2.2-alpine.

  ---
  updated-dependencies:
  - dependency-name: redis
    dependency-version: 8.2.2-alpine
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Bump mongo from 8.0.14 to 8.0.15 in /mender
 ([4982e24](https://github.com/mendersoftware/mender-helm/commit/4982e24908b222c2405f6991e9fcc64b20ed2df3))  by @dependabot[bot]


  Bumps mongo from 8.0.14 to 8.0.15.

  ---
  updated-dependencies:
  - dependency-name: mongo
    dependency-version: 8.0.15
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...






## mender-7.0.0 - 2025-09-30


### Bug fixes


- Bump mongo from 8.0.13 to 8.0.14 in /mender
 ([00c53a4](https://github.com/mendersoftware/mender-helm/commit/00c53a4187793c6a3262cad222c910d6f9018e2e))  by @dependabot[bot]


  Bumps mongo from 8.0.13 to 8.0.14.

  ---
  updated-dependencies:
  - dependency-name: mongo
    dependency-version: 8.0.14
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Bump traefik from 3.5.2 to 3.5.3 in /mender
 ([0e9c6c4](https://github.com/mendersoftware/mender-helm/commit/0e9c6c4d42111b4f3d5eef4fd01f94d0692b3521))  by @dependabot[bot]


  Bumps traefik from 3.5.2 to 3.5.3.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.5.3
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Increase default limits for delta generator
([MEN-8765](https://northerntech.atlassian.net/browse/MEN-8765)) ([9d45e66](https://github.com/mendersoftware/mender-helm/commit/9d45e6655aed8b87793a64a3816965e6bd69e8f6))  by @merlin-northern




### Features


- Bitnami alternatives
 ([7a035bf](https://github.com/mendersoftware/mender-helm/commit/7a035bfa8fd6aae49a49b6cc088d8bd9bd291fb5))  by @oldgiova
  - **BREAKING**: bitnami alternatives


  Includes sample MongoDB and Redis instances for convenient testing
  and development use. These are not suitable for production environments.

  UPGRADE INSTRUCTIONS from 6.x to 7.x:
  If you are using an external MongoDB cluster, you are not affected by this upgrade.
  If you are using the MongoDB Bitnami subchart from the Mender Helm Chart v6.x, you must:

  1. Back up your MongoDB data before the upgrade
  2. Run the upgrade to 7.x
  3. Restore your MongoDB data after the upgrade

  Please note: The MongoDB setup provided with the Mender Helm Chart is
  intended for testing and development purposes only, not for production use.






## mender-6.9.0 - 2025-09-23


### Bug fixes


- *(generate-delta-worker)* Set automigrate to false by default
 ([3f3ded6](https://github.com/mendersoftware/mender-helm/commit/3f3ded61730edef52b4fe2e2074108ee9f6031be))  by @alfrunes

- Bump traefik from 3.5.0 to 3.5.1 in /mender
 ([c71511e](https://github.com/mendersoftware/mender-helm/commit/c71511ecc0fd890afa30d764cc7849b61b2dc0c5))  by @dependabot[bot]


  Bumps traefik from 3.5.0 to 3.5.1.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.5.1
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Bump traefik from 3.5.1 to 3.5.2 in /mender
 ([f773856](https://github.com/mendersoftware/mender-helm/commit/f7738569507109cee76926b740f5d989392afbda))  by @dependabot[bot]


  Bumps traefik from 3.5.1 to 3.5.2.

  ---
  updated-dependencies:
  - dependency-name: traefik
    dependency-version: 3.5.2
    dependency-type: direct:production
    update-type: version-update:semver-patch
  ...
- Reload api_gateway when configmap changes
 ([2a0c051](https://github.com/mendersoftware/mender-helm/commit/2a0c051863ab5494cd3ec5066618688fc2440667))  by @oldgiova




### Features


- *(deviceauth)* Add value `device_auth.mountSecrets`
 ([5a83683](https://github.com/mendersoftware/mender-helm/commit/5a83683269cd259c4d59a67bd3fdf367f11bc3e8))  by @alfrunes

- *(tenantadm)* Add value `tenantadm.mountSecrets`
 ([25077d0](https://github.com/mendersoftware/mender-helm/commit/25077d032fd64d798af2e63481138e3e3b62bdae))  by @alfrunes

- *(useradm)* Add value `useradm.mountSecrets`
 ([154336c](https://github.com/mendersoftware/mender-helm/commit/154336cedd7cfb8faf722313e967ee81f070fe9c))  by @alfrunes

- *(workflows)* Set HAVE_DEVICEMONITOR env variable
 ([264482e](https://github.com/mendersoftware/mender-helm/commit/264482e2057c38b6d992457ba1fbb7120a71f5c3))  by @frodeha







## mender-6.8.3 - 2025-08-20


### Bug fixes


- X-mender headers to customResponseHeaders
 ([eea61cf](https://github.com/mendersoftware/mender-helm/commit/eea61cfdb0207417cae9f88f175326503baffb13))  by @oldgiova


  To correctly expose the custom x-mender headers, we have to set them in
  the customResponseHeaders, instead of in the customRequestHeaders, which
  is for client to server communication only.






## mender-6.8.2 - 2025-08-19


### Bug fixes


- Correctly display x-mender headers
 ([9f6fe3a](https://github.com/mendersoftware/mender-helm/commit/9f6fe3a9451021bd91281a30fa8e7e6c43fe29db))  by @oldgiova






## mender-6.8.1 - 2025-08-14


### Bug fixes


- *(api-gateway)* Relax routing version regex to allow experimental
 ([939ce06](https://github.com/mendersoftware/mender-helm/commit/939ce06453cd228a57b192bcd16bbfcdc0ae3a4a))  by @alfrunes


  This commit does not provide any visible change to the application, but
  allows routing to future experimental API endpoints.







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

## [7.3.3](https://github.com/mendersoftware/mender-helm/compare/mender-7.3.2...mender-7.3.3) (2025-12-09)


### Bug Fixes

* **deployments:** handle prerelease configmap ([2305452](https://github.com/mendersoftware/mender-helm/commit/230545231eb171f73da102e875e916947ffd0251))

## [7.3.2](https://github.com/mendersoftware/mender-helm/compare/mender-7.3.1...mender-7.3.2) (2025-12-09)


### Bug Fixes

* bump traefik from 3.6.2 to 3.6.4 in /mender ([28b1fcd](https://github.com/mendersoftware/mender-helm/commit/28b1fcd95c23fb8c8bb87a0828dc77bab63d7438))

## [7.3.1](https://github.com/mendersoftware/mender-helm/compare/mender-7.3.0...mender-7.3.1) (2025-12-05)


### Bug Fixes

* bump mongo from 8.0.15 to 8.0.16 in /mender ([9ae6278](https://github.com/mendersoftware/mender-helm/commit/9ae627837a0dbf661853983ebc6dba37b86ea402))

## [7.3.0](https://github.com/mendersoftware/mender-helm/compare/mender-7.2.1...mender-7.3.0) (2025-12-04)


### Features

* **workflows:** add value `workflows.nats.replicas` ([c49f804](https://github.com/mendersoftware/mender-helm/commit/c49f8048e37b13717a7782553714144ff7135ae9))
* **workflows:** add value `workflows.nats.replicas` ([9c2b114](https://github.com/mendersoftware/mender-helm/commit/9c2b114e73a7f1b1fe6bcb77158c69248b0eb077))

## [7.2.1](https://github.com/mendersoftware/mender-helm/compare/mender-7.2.0...mender-7.2.1) (2025-11-25)


### Bug Fixes

* bump redis from 8.2.3-alpine to 8.4.0-alpine in /mender ([31f5eee](https://github.com/mendersoftware/mender-helm/commit/31f5eeeece12ac208b7f1cc49957567184528adc))
* bump redis from 8.2.3-alpine to 8.4.0-alpine in /mender ([6969656](https://github.com/mendersoftware/mender-helm/commit/6969656e00dae57020932891d52e073f79a3aec5))
* bump traefik from 3.6.0 to 3.6.2 in /mender ([6b65893](https://github.com/mendersoftware/mender-helm/commit/6b6589357b8eef003dcc0d4529c6c98dcafba068))
* bump traefik from 3.6.0 to 3.6.2 in /mender ([fb0f52f](https://github.com/mendersoftware/mender-helm/commit/fb0f52f087f69104dceb696f436504256e9db297))

## [7.2.0](https://github.com/mendersoftware/mender-helm/compare/mender-7.1.1...mender-7.2.0) (2025-11-24)


### Features

* Added value deployments.config for overwriting config.yaml ([c38e181](https://github.com/mendersoftware/mender-helm/commit/c38e181b07350f9d0be109257139e041fab5354f))

## [7.1.1](https://github.com/mendersoftware/mender-helm/compare/mender-7.1.0...mender-7.1.1) (2025-11-13)


### Bug Fixes

* right PodDisruptionBudget selector ([d4acbd9](https://github.com/mendersoftware/mender-helm/commit/d4acbd92ebb000a7513fb392a8c171900a187b8a))
* right PodDisruptionBudget selector ([4ad0b5d](https://github.com/mendersoftware/mender-helm/commit/4ad0b5d08892139465cef69c0cf61e941e7c4d74))

## [7.1.0](https://github.com/mendersoftware/mender-helm/compare/mender-7.0.4...mender-7.1.0) (2025-11-12)


### Features

* Added value `api_gateway.customEnv` ([7ec2f1a](https://github.com/mendersoftware/mender-helm/commit/7ec2f1a115e5455e58986f94b943b5acd4fd94a0))
* Added value `api_gateway.customEnv` ([19eac9a](https://github.com/mendersoftware/mender-helm/commit/19eac9a2f28e53b98cadc5cede199c04c8d9815b))


### Bug Fixes

* **tenantadm:** remove duplicate devicemonitor alert rate limit rule ([457ac3a](https://github.com/mendersoftware/mender-helm/commit/457ac3a37c2b7e774c95575d314459b43e6d6390))

## [7.0.4](https://github.com/mendersoftware/mender-helm/compare/mender-7.0.3...mender-7.0.4) (2025-11-11)


### Bug Fixes

* bump redis from 8.2.2-alpine to 8.2.3-alpine in /mender ([278e2f8](https://github.com/mendersoftware/mender-helm/commit/278e2f8c84baa63f2d0c0f4149b0b34867fa20e1))
* bump redis from 8.2.2-alpine to 8.2.3-alpine in /mender ([73d360a](https://github.com/mendersoftware/mender-helm/commit/73d360a22d6885c3e4a848022041232d6e464012))
* bump traefik from 3.5.4 to 3.6.0 in /mender ([e1ef882](https://github.com/mendersoftware/mender-helm/commit/e1ef882338b385c2c041cdea56fce9288c8eecb6))
* bump traefik from 3.5.4 to 3.6.0 in /mender ([55c62f6](https://github.com/mendersoftware/mender-helm/commit/55c62f6545cc7a10e0a978aef1f7160b061f1da7))

## [7.0.3](https://github.com/mendersoftware/mender-helm/compare/mender-7.0.2...mender-7.0.3) (2025-11-04)


### Bug Fixes

* bump traefik from 3.5.3 to 3.5.4 in /mender ([9e72bfa](https://github.com/mendersoftware/mender-helm/commit/9e72bfa74702a7cfce261d3115f1337774d510ee))
* bump traefik from 3.5.3 to 3.5.4 in /mender ([2432f56](https://github.com/mendersoftware/mender-helm/commit/2432f56f87a0c65cba4d53a1a12f13277a47d780))

## [7.0.2](https://github.com/mendersoftware/mender-helm/compare/mender-7.0.1...mender-7.0.2) (2025-11-01)


### Bug Fixes

* add missing podAnnotations for gui deployment ([3f08462](https://github.com/mendersoftware/mender-helm/commit/3f08462d526510aed6d9bb0d614e012e2b280b74))
* add missing podAnnotations for gui deployment ([5c531a6](https://github.com/mendersoftware/mender-helm/commit/5c531a6941700177059e473f8a978ea80e194115))

## [7.0.1](https://github.com/mendersoftware/mender-helm/compare/mender-7.0.0...mender-7.0.1) (2025-10-07)


### Bug Fixes

* bump mongo from 8.0.14 to 8.0.15 in /mender ([9940f36](https://github.com/mendersoftware/mender-helm/commit/9940f3660a04ddd245ff5cf04fb34492088ea622))
* bump mongo from 8.0.14 to 8.0.15 in /mender ([4982e24](https://github.com/mendersoftware/mender-helm/commit/4982e24908b222c2405f6991e9fcc64b20ed2df3))
* bump redis from 8.2.1-alpine to 8.2.2-alpine in /mender ([42aa4bf](https://github.com/mendersoftware/mender-helm/commit/42aa4bf6fb4ccb20039bc9f6f1d138ef2bfd0215))
* bump redis from 8.2.1-alpine to 8.2.2-alpine in /mender ([97e70ec](https://github.com/mendersoftware/mender-helm/commit/97e70ecc547fa347fad902f6bfe958474bcd58b4))

## [7.0.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.9.0...mender-7.0.0) (2025-09-30)

### Features
* bitnami alternatives ([7a035bf](https://github.com/mendersoftware/mender-helm/commit/7a035bfa8fd6aae49a49b6cc088d8bd9bd291fb5))

### Bug Fixes

* bump mongo from 8.0.13 to 8.0.14 in /mender ([809c3ea](https://github.com/mendersoftware/mender-helm/commit/809c3ea92f1c9ef91b3af2c45e6e2c025307f1f7))
* bump mongo from 8.0.13 to 8.0.14 in /mender ([00c53a4](https://github.com/mendersoftware/mender-helm/commit/00c53a4187793c6a3262cad222c910d6f9018e2e))
* bump traefik from 3.5.2 to 3.5.3 in /mender ([255ee65](https://github.com/mendersoftware/mender-helm/commit/255ee65a9356fecb30e50dd7299a7b10aa888b5c))
* bump traefik from 3.5.2 to 3.5.3 in /mender ([0e9c6c4](https://github.com/mendersoftware/mender-helm/commit/0e9c6c4d42111b4f3d5eef4fd01f94d0692b3521))
* increase default limits for delta generator ([b6430d2](https://github.com/mendersoftware/mender-helm/commit/b6430d26d8e0cc4381df41ae01b4bf8e6bae2e1b))
* increase default limits for delta generator ([9d45e66](https://github.com/mendersoftware/mender-helm/commit/9d45e6655aed8b87793a64a3816965e6bd69e8f6))


## [6.9.0](https://github.com/mendersoftware/mender-helm/compare/mender-6.8.3...mender-6.9.0) (2025-09-23)


### Features

* **deviceauth:** Add value `device_auth.mountSecrets` ([5a83683](https://github.com/mendersoftware/mender-helm/commit/5a83683269cd259c4d59a67bd3fdf367f11bc3e8))
* **tenantadm:** Add value `tenantadm.mountSecrets` ([25077d0](https://github.com/mendersoftware/mender-helm/commit/25077d032fd64d798af2e63481138e3e3b62bdae))
* **useradm:** Add value `useradm.mountSecrets` ([154336c](https://github.com/mendersoftware/mender-helm/commit/154336cedd7cfb8faf722313e967ee81f070fe9c))
* **workflows:** set HAVE_DEVICEMONITOR env variable ([264482e](https://github.com/mendersoftware/mender-helm/commit/264482e2057c38b6d992457ba1fbb7120a71f5c3))


### Bug Fixes

* bump traefik from 3.5.0 to 3.5.1 in /mender ([accc7e1](https://github.com/mendersoftware/mender-helm/commit/accc7e1f143a4e0d1d267e1754c8c57e372232c1))
* bump traefik from 3.5.0 to 3.5.1 in /mender ([c71511e](https://github.com/mendersoftware/mender-helm/commit/c71511ecc0fd890afa30d764cc7849b61b2dc0c5))
* bump traefik from 3.5.1 to 3.5.2 in /mender ([a31203d](https://github.com/mendersoftware/mender-helm/commit/a31203d79cf2dd3f0dc3f1731a068511b3c9c112))
* bump traefik from 3.5.1 to 3.5.2 in /mender ([f773856](https://github.com/mendersoftware/mender-helm/commit/f7738569507109cee76926b740f5d989392afbda))
* **generate-delta-worker:** Set automigrate to false by default ([82242b6](https://github.com/mendersoftware/mender-helm/commit/82242b6477d2cc3176a757f25730ccdf7221cf99))
* **generate-delta-worker:** Set automigrate to false by default ([3f3ded6](https://github.com/mendersoftware/mender-helm/commit/3f3ded61730edef52b4fe2e2074108ee9f6031be))
* reload api_gateway when configmap changes ([6efda3f](https://github.com/mendersoftware/mender-helm/commit/6efda3f2f84234ecb99e3593e9fcf10759843dc6))
* reload api_gateway when configmap changes ([2a0c051](https://github.com/mendersoftware/mender-helm/commit/2a0c051863ab5494cd3ec5066618688fc2440667))

## [6.8.3](https://github.com/mendersoftware/mender-helm/compare/mender-6.8.2...mender-6.8.3) (2025-08-20)


### Bug Fixes

* x-mender headers to customResponseHeaders ([f697f83](https://github.com/mendersoftware/mender-helm/commit/f697f8310bb46a4d4f03e531eadc616f22b4f59d))
* x-mender headers to customResponseHeaders ([eea61cf](https://github.com/mendersoftware/mender-helm/commit/eea61cfdb0207417cae9f88f175326503baffb13))

## [6.8.2](https://github.com/mendersoftware/mender-helm/compare/mender-6.8.1...mender-6.8.2) (2025-08-19)


### Bug Fixes

* correctly display x-mender headers ([13f0bb0](https://github.com/mendersoftware/mender-helm/commit/13f0bb0a204fa081fa7b04a7a81c41152268267d))
* correctly display x-mender headers ([9f6fe3a](https://github.com/mendersoftware/mender-helm/commit/9f6fe3a9451021bd91281a30fa8e7e6c43fe29db))

## [6.8.1](https://github.com/mendersoftware/mender-helm/compare/mender-6.8.0...mender-6.8.1) (2025-08-14)


### Bug Fixes

* **api-gateway:** Relax routing version regex to allow experimental ([e6c381a](https://github.com/mendersoftware/mender-helm/commit/e6c381a5ec0a6d68f2698f41dd61a409a4796ef0))
* **api-gateway:** Relax routing version regex to allow experimental ([939ce06](https://github.com/mendersoftware/mender-helm/commit/939ce06453cd228a57b192bcd16bbfcdc0ae3a4a))

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
