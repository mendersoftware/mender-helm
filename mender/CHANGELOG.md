---
## mender-6.0.0 - 2024-10-31


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




### Documentation


- Added remark about global.image.username/password to changelog
 ([360ed7a](https://github.com/mendersoftware/mender-helm/commit/360ed7aac1e024fb9655f5e5bb9e9a7b241a23d6))  by @alfrunes
- New v6.x setup
 ([df07622](https://github.com/mendersoftware/mender-helm/commit/df076223f8c5c6fb60714eeb26cef101098b1b1a))  by @oldgiova


  With Seaweedfs, v6 breaking changes, and a dedicated upgrade document




### Features


- Update docker image references to follow new repository scheme
 ([cd1a87a](https://github.com/mendersoftware/mender-helm/commit/cd1a87aafd1e539a618b8417b83537d5c2c72bcb))  by @alfrunes
  - **BREAKING**: See CHANGELOG.md
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




### Refactor


- *(workflows)* Made workflows template arguments easier to read
 ([87c10ff](https://github.com/mendersoftware/mender-helm/commit/87c10ff848583eb3a982eb5c2565436d5fad6224))  by @alfrunes





## mender-5.11.0 - 2024-10-14


### Bug Fixes


- Traefik container ports optionals
([MEN-7595](https://northerntech.atlassian.net/browse/MEN-7595)) ([12dc357](https://github.com/mendersoftware/mender-helm/commit/12dc357184f39edf878105f4cde2787dbcd1b0b7))  by @oldgiova


  You can choose to not to set either httpPort or httpsPort in the
  api_gateway, to prevent upload timeout with the Mender Cli, as reported
  by customers.




### Features


- Add gui hpa
 ([8f6d9f4](https://github.com/mendersoftware/mender-helm/commit/8f6d9f46c0c9db16939a8c851ed4bda21e7ca5f3))  by @oldgiova


  Added Horizontal Pod Autoscaler resource to the gui container, to scale
  it automatically when the service experiences more load.




## 5.10.1 - 2024-08-21


### Bug Fixes


- *(traefik v3)* Invalid regex for default storage proxy Traefik rule
 ([52db4f1](https://github.com/mendersoftware/mender-helm/commit/52db4f14d21096f397cbc188fa5b3685f315afbb))  by @alfrunes


  The regular expression in the hostname rule was using incompatible
  Traefik v2 regex.





## 5.10.0 - 2024-08-15


### Features


- Change `generate-delta-worker` to StatefulSet and add persistence
 ([3ad97fb](https://github.com/mendersoftware/mender-helm/commit/3ad97fb8d9f96ee757701528907cf59a68c8d601))  by @alfrunes


  Changes the `generate-delta-worker` workload from Deployment to
  StatefulSet and exposes volume claim template parameters in the values.
- Upgrade Traefik major version to v3
 ([be245a8](https://github.com/mendersoftware/mender-helm/commit/be245a84c61e8fc8bc578bd3925bab6d75bf21da))  by @alfrunes




## 5.9.2 - 2024-06-24


### Bug Fixes


- Generate delta mongo secret
 ([9474045](https://github.com/mendersoftware/mender-helm/commit/9474045200cce0c805918bd5608169f70c8d3546))  by @oldgiova


  Fix using an external secret in the generate delta worker service, when
  using MongoDB subchart.




## 5.8.3 - 2024-06-07


### Bug Fixes


- Display integrations button on 3.6
 ([21162a4](https://github.com/mendersoftware/mender-helm/commit/21162a4b302e52bbea7b759d74a22539e7696786))  by @oldgiova


  This fix allows displaying the integration button on the Mender 3.6
  release




## 5.8.2 - 2024-06-04


### Bug Fixes


- Correctly setup the Mender Version
 ([2419ba0](https://github.com/mendersoftware/mender-helm/commit/2419ba07361d0b91ed9ddd6b6453f9cc73920cff))  by @oldgiova


  in the iot-manager service




## 5.8.1 - 2024-05-31


### Bug Fixes


- Using device_auth key
 ([b929e9c](https://github.com/mendersoftware/mender-helm/commit/b929e9c704030953ed64e114b444b41a2c09e622))  by @oldgiova
- Managing redis existingSecret when set
 ([5d95b75](https://github.com/mendersoftware/mender-helm/commit/5d95b75c6d2447ab2abd013ad86c34004544274c))  by @oldgiova




### Features


- Redis connection to the deployments
 ([8e34cbb](https://github.com/mendersoftware/mender-helm/commit/8e34cbb64f86c75c65bbe9a0ead5725a17391cdc))  by @oldgiova


  The deployments service needs to reach the Redis cache. Adding the
  settings




## 5.7.1 - 2024-05-29


### Bug Fixes


- Added global.smtp.existingSecret
 ([8542709](https://github.com/mendersoftware/mender-helm/commit/85427092d30b6a56bbf85ebaa9ed9411d0215e75))  by @oldgiova


  Don't create the smtp secret when an existingSecret is created




## 5.7.0 - 2024-05-20


### Bug Fixes


- Don't enforce tags for the delta image
 ([6eaed95](https://github.com/mendersoftware/mender-helm/commit/6eaed955dab792ee3ba0ab761f04bbeb2a98f95d))  by @oldgiova


  The generate_delta_worker image was set to mender-3.5.0. Unsetting it so
  it inherits the default for the release.
- Mongodb override with global existingsecret
 ([01307da](https://github.com/mendersoftware/mender-helm/commit/01307da6858e11d53540d8eaf12a99f306c360a5))  by @oldgiova


  When a global.mongodb.existingSecret is set, the mongodb override for
  the inventory doesn't work. This fixes it.




### Features


- Added mongodb secret override
 ([92805ce](https://github.com/mendersoftware/mender-helm/commit/92805ce1d9ac5acf110c151db075cbf37e00210a))  by @oldgiova


  With this override, you can choose a different secret for the inventory
  service, for example a secondary connection
- PodMonitor for monitoring traefik
 ([dd06c38](https://github.com/mendersoftware/mender-helm/commit/dd06c38f899fc31ae7dea666b1d1caf6adc92379))  by @oldgiova
- ProbesOverrides to override probes
 ([1d9be14](https://github.com/mendersoftware/mender-helm/commit/1d9be148cefbe14c1811d4bd1defe7886d1ea951))  by @oldgiova


  Added probesOverride to override Readiness and Liveness probes.




## 5.6.0 - 2024-03-22


### Features


- Upgrade MongoDB major version from 5.0 to 6.0
 ([f495ca4](https://github.com/mendersoftware/mender-helm/commit/f495ca4c18a784e4ae651bd7054275c031e0da26))  by @alfrunes
- Bump chart version to 5.6.0
 ([08c53bc](https://github.com/mendersoftware/mender-helm/commit/08c53bce2b3e78533d64a07e365f01546d1a186d))  by @alfrunes




## 5.5.4 - 2024-02-26


### Bug Fixes


- Malformed auth header when authRateLimit is set
 ([949d21e](https://github.com/mendersoftware/mender-helm/commit/949d21e9022e582541696c47415d05afebbd94b7))  by @oldgiova


  When the api_gateway.authRateLimit is set, a malformed authorization
  header error is displayed at login. This fix solves the issue




## 5.5.3 - 2024-02-15


### Bug Fixes


- Some devicemonitor variables not initialized
 ([8e0989b](https://github.com/mendersoftware/mender-helm/commit/8e0989b837add2bbba3e6b30339c2d75754b57ec))  by @oldgiova


  Some devicemonitor variables was not correctly initialized




### Features


- Added support to external AES encryption key
 ([06148b1](https://github.com/mendersoftware/mender-helm/commit/06148b17daabf55b58a6507f81e06f765c678c7d))  by @oldgiova


  For the IoT manager service
- Secret file mounted into the workflows
 ([f53b23f](https://github.com/mendersoftware/mender-helm/commit/f53b23f00f063f1b652f6f6f6cfd8ca5328ab2c4))  by @oldgiova


  Added optional volumeMounts support to the workflows service. You can
  mount a secret as a file into the service.




## 5.5.1 - 2024-02-13


### Bug Fixes


- Added missing auditlog
 ([b243ae1](https://github.com/mendersoftware/mender-helm/commit/b243ae128fe64d11a69b86099939a1e19f1e5bb5))  by @oldgiova


  The device auth service is missing auditlogs feature.
- Right key value for redis limit expire
 ([fd3ba87](https://github.com/mendersoftware/mender-helm/commit/fd3ba8725a9defbbd3626ad2144b0d60cc073a05))  by @oldgiova
- Redis connection string condition
 ([33e99b4](https://github.com/mendersoftware/mender-helm/commit/33e99b423ce156c0b63499c89256c5d216a2fe7a))  by @oldgiova


  When using an external provided Redis instance, the global.redis.URL is
  ignored and this fix solves this behavior.




### Features


- Support for X-MEN-RBAC-Releases-Tags
([MEN-6350](https://northerntech.atlassian.net/browse/MEN-6350)) ([317d60c](https://github.com/mendersoftware/mender-helm/commit/317d60cd48bfd6d7000746b0729e0ec37f0b7ba4))  by @merlin-northern
- Allow existing secret for the presign
 ([c0ebbda](https://github.com/mendersoftware/mender-helm/commit/c0ebbda1fe3d481bcf39f85ada3e7e1153afd1cd))  by @oldgiova


  You can use an existing external secret to populate the variable
  DEPLOYMENTS_PRESIGN_SECRET. The secret must have PRESIGN_SECRET as a
  key.
- Added redis existing secret option
 ([3bcd1d2](https://github.com/mendersoftware/mender-helm/commit/3bcd1d2e1a2d90434cae290aa7367187935cdd72))  by @oldgiova


  You can optionally use an existing secret to configure the
  REDIS_CONNECTION_STRING value. This option is not compatible with
  .Value.global.redis.URL and cannot be set when the internal Redis chart
  is enabled with .redis.enabled: true




## 5.5.0 - 2024-02-01


### Features


- Add OpenId Connect endpoints as unauth ones
([MEN-6611](https://northerntech.atlassian.net/browse/MEN-6611)) ([06d2ca6](https://github.com/mendersoftware/mender-helm/commit/06d2ca668b025636187eabd0849370d93203d80e))  by @merlin-northern
- Added customEnv option
 ([3cfbfdb](https://github.com/mendersoftware/mender-helm/commit/3cfbfdb5e4104588a5fc9053969d5966fa2f3df6))  by @oldgiova


  You can add a default.customEnv list of environment variables to every
  service, or a customEnv list for single services.




## 5.4.0 - 2024-01-01


### Features


- Upgrade to Mender 3.7.0, bump Helm chart version to 5.4.0
 ([a3d5b39](https://github.com/mendersoftware/mender-helm/commit/a3d5b39da10c0ace1413b47fdb9bd03821239651))  by @tranchitella
- Update the Redis settings to use a connection string
 ([e40d498](https://github.com/mendersoftware/mender-helm/commit/e40d498d44d893c29fa70c8c2fa9cd58b3b16f8e))  by @tranchitella




## 5.2.6 - 2023-10-12


### Bug Fixes


- Indent cronjob annotations correctly
 ([d4a863e](https://github.com/mendersoftware/mender-helm/commit/d4a863ede60dfef4d1376176b7155f329cce5a5c))  by @vphoikka
- Graceful shutdown for deviceconnect and terminationGracePeriodSeconds
 ([5a4f531](https://github.com/mendersoftware/mender-helm/commit/5a4f5310fcc821a6d931d079ff4c0e7df20d2bd6))  by @tranchitella




### Features


- Graceful shutdown for deviceconnect
 ([572c20d](https://github.com/mendersoftware/mender-helm/commit/572c20d4cf56cf6aaaba35b7d725d64db74fd582))  by @tranchitella




## 5.2.5 - 2023-10-09


### Bug Fixes


- Using prerelease secret with migration jobs
 ([5089a91](https://github.com/mendersoftware/mender-helm/commit/5089a912cf885ec90719dc6fdbf285e3115d1fc6))  by @oldgiova
- Added missing end
 ([1335784](https://github.com/mendersoftware/mender-helm/commit/13357846e1477cbeec3bed7db0dcd738b89b1a18))  by @oldgiova




### Features


- Added support to additional args to the api_gateway container
 ([c0156af](https://github.com/mendersoftware/mender-helm/commit/c0156af5ba18132c69200381f1bcf2da294e2ad9))  by @oldgiova
- Added support to existing external Docker registry secrets
 ([6351a7d](https://github.com/mendersoftware/mender-helm/commit/6351a7d0046395bb0d9ebceb7466b91aa374b263))  by @oldgiova
- Managing priorityClassNames for the Mender Deployments resources
 ([b6fa986](https://github.com/mendersoftware/mender-helm/commit/b6fa9863b7472f2f2a760942f92cf0be4f91d672))  by @oldgiova
- Added pdb to most important services
 ([6b28826](https://github.com/mendersoftware/mender-helm/commit/6b288262a46c2f345fc45f1db7d610a3ce460eee))  by @oldgiova
- Add option to use existingSecret for useradm
 ([b6f86a9](https://github.com/mendersoftware/mender-helm/commit/b6f86a926ddb7683f94e05841982e512c7f7df3f))  by @bdomars
- Add option to use existingSecret for tenantadm
 ([003f04c](https://github.com/mendersoftware/mender-helm/commit/003f04cd974bfc7d381cc8b87ed9ed39ca83192a))  by @bdomars
- Add option to use existingSecret for device-auth
 ([4067754](https://github.com/mendersoftware/mender-helm/commit/406775459430556b3594b07ef95cd9467e899f93))  by @bdomars
- Add option to use existingSecret for api_gateway
 ([1955019](https://github.com/mendersoftware/mender-helm/commit/1955019b590a7b7cc7f84154322b27ba04c162d5))  by @bdomars
- Allow to use external secret for mongodb
 ([0f95631](https://github.com/mendersoftware/mender-helm/commit/0f95631b56fb4113875a15a1801bd0255724a5ae))  by @benjamin-texier
- Allow to use external secret for nats
 ([ec9e5c7](https://github.com/mendersoftware/mender-helm/commit/ec9e5c70b44627e2e737831f9e589fa93430552e))  by @benjamin-texier




## 5.2.4 - 2023-09-21


### Bug Fixes


- Don't run test jobs when RUN_PLAYGROUND = "true"
 ([be3982e](https://github.com/mendersoftware/mender-helm/commit/be3982e49b4c3c14d247f38e4083728a1c474ccd))  by @oldgiova
- Automigrate command newline fix
 ([906ae09](https://github.com/mendersoftware/mender-helm/commit/906ae09ad05dced1ed54176332f96778fcc6abbf))  by @oldgiova




### Features


- Added Mender Opensource test setup
 ([f247515](https://github.com/mendersoftware/mender-helm/commit/f247515ffba153872b3d63643a0fe26240ed2cc9))  by @oldgiova
- Added HorizontalPodAutoscaler resources
 ([a816ee4](https://github.com/mendersoftware/mender-helm/commit/a816ee4024e79688208608181134674880d63c9b))  by @oldgiova




## 5.2.3 - 2023-08-26


### Features


- Added Port for the Error server block on the gui
 ([9109fdf](https://github.com/mendersoftware/mender-helm/commit/9109fdfc8bfd23a4aefd64aa1f6e17f14bd7bb95))  by @oldgiova


  To align HM with the Helm Chart
- Set Mender 3.6.2 image tags
 ([ee67fb6](https://github.com/mendersoftware/mender-helm/commit/ee67fb610d3820a99c7292602be7d891b6f15047))  by @tranchitella




## 5.2.2 - 2023-08-21


### Bug Fixes


- Failing tests because of lack of resources
 ([c5ed120](https://github.com/mendersoftware/mender-helm/commit/c5ed1205f1e0ee05345601f0179aa7575b93498d))  by @oldgiova
- Use the `deployments.directUpload.jitter` parameter
 ([dfc8b6a](https://github.com/mendersoftware/mender-helm/commit/dfc8b6a5399685d7c7e81ab5193b455785184018))  by @tranchitella


  ...in the deployments-storage-daemon cronjob.




### Features


- Add the `deployments.directUpload.skipVerify` parameter
 ([0009e08](https://github.com/mendersoftware/mender-helm/commit/0009e0878b2a26326d75f25cce6011acead4efec))  by @tranchitella




## 5.2.1 - 2023-08-19


### Features


- Upgrade MongoDB dependency to 5.0
 ([c279c9f](https://github.com/mendersoftware/mender-helm/commit/c279c9f879689fcd72dfd44819fba9a923c69517))  by @alfrunes
- Define default PodDisruptionBudget and updateStrategy for mongodb
 ([3a5f7a7](https://github.com/mendersoftware/mender-helm/commit/3a5f7a7ce1d3130b4451d75b351c216de269c602))  by @alfrunes




## 5.1.0 - 2023-07-31


### Bug Fixes


- Missing WORKFLOWS_NATS_URI in the db-migration-job
 ([bc39ccd](https://github.com/mendersoftware/mender-helm/commit/bc39ccd4ca34f460bf451cfd531e8e433aea6e41))  by @tranchitella




## 5.0.3 - 2023-07-28


### Bug Fixes


- Renamed to the correct variables for useradm auditlogs
 ([2386a91](https://github.com/mendersoftware/mender-helm/commit/2386a91fd693fbfe877b167b2b91238cbdfe82ca))  by @oldgiova




## 5.0.2 - 2023-07-26


### Bug Fixes


- Auditlog retention seconds format
 ([b07cff9](https://github.com/mendersoftware/mender-helm/commit/b07cff9a2fe27c9a598a4767a4c1e2f0ad502acf))  by @oldgiova
- Avoid Redis restarting every upgrade
 ([4c3d3a4](https://github.com/mendersoftware/mender-helm/commit/4c3d3a47ff0aa6f82dc6e45240bf26a8f88fcf6a))  by @oldgiova
- Fixed Redis master address
 ([98b640e](https://github.com/mendersoftware/mender-helm/commit/98b640e1d6b8ec45139c2452a56e5bc679a4a09d))  by @oldgiova
- Renamed to the correct variables for useradm auditlogs
 ([90762ba](https://github.com/mendersoftware/mender-helm/commit/90762baad6007f3fd1af93f556cf9a8ea39594a3))  by @oldgiova




### Features


- Added internal Ingress resource
 ([97a2ac3](https://github.com/mendersoftware/mender-helm/commit/97a2ac3a7e9154e877c883e9d16cd2217a81718b))  by @oldgiova
- Added AWS LB capability
 ([4cee30e](https://github.com/mendersoftware/mender-helm/commit/4cee30e70292805e55dd4dbfe9a50ef67beff12c))  by @oldgiova
- Added ingress tests
 ([c397405](https://github.com/mendersoftware/mender-helm/commit/c397405316c068495dd8165dd0fdb681caf3b897))  by @oldgiova
- Traefik compression parametrized
 ([c449d20](https://github.com/mendersoftware/mender-helm/commit/c449d20c8792dba5fe1ff191dfb6aa92a144ecf2))  by @oldgiova
- Added optional security redirect
 ([227d6f3](https://github.com/mendersoftware/mender-helm/commit/227d6f3877d8b3e715c9e9470954514a1d5562a3))  by @oldgiova
- Added custom redirect for MinIO rule
 ([89e724d](https://github.com/mendersoftware/mender-helm/commit/89e724d1bdcd80138c9523f18d22859e78e72c7b))  by @oldgiova
- Added custom ratelimit for the auth module only
 ([3c94242](https://github.com/mendersoftware/mender-helm/commit/3c942422640a799d68e171020ff14da04918bbf2))  by @oldgiova
- Add contentTypeNosniff to the Traefik configuration
 ([9e769cd](https://github.com/mendersoftware/mender-helm/commit/9e769cd8a9f8cd0321c0804a0fbbacc6c8e75420))  by @oldgiova




## 5.0.1 - 2023-07-03


### Bug Fixes


- Issues with replicaset and authentication
 ([3a71575](https://github.com/mendersoftware/mender-helm/commit/3a7157507db87c6dc4687afb8fdadb88405b0deb))  by @oldgiova




## 5.0.0 - 2023-06-26


### Bug Fixes


- Backward compatible AWS_BUCKET var
 ([b478af6](https://github.com/mendersoftware/mender-helm/commit/b478af67a34d2e08a9fc41c350a3d2f2e697ca37))  by @oldgiova




### Chore


- Added sub-charts tests
 ([ad8e955](https://github.com/mendersoftware/mender-helm/commit/ad8e95520a07bb7890baf3f404c0eb6722b6bc9d))  by @oldgiova




### Features


- Adding temporary EKS cluster for testing helm integration
 ([6bc442f](https://github.com/mendersoftware/mender-helm/commit/6bc442fd785a8293b80f7ed6c5b74d80fc7d8589))  by @oldgiova
- Added helm upgrades tests
 ([00cff45](https://github.com/mendersoftware/mender-helm/commit/00cff45b8631419dfdb8646a018c1a542b88ebf6))  by @oldgiova
- Added kubeconform tests
 ([7164479](https://github.com/mendersoftware/mender-helm/commit/71644794f4a20113c901138ec0e10b419a55ed07))  by @oldgiova
- Using dedicated redis helm chart
 ([fa0fbff](https://github.com/mendersoftware/mender-helm/commit/fa0fbff89cc6b562e27391e644576120d3f510bc))  by @oldgiova
- Resource names with release name suffix
 ([77383ea](https://github.com/mendersoftware/mender-helm/commit/77383eac243407a8df9e194b6d0096aacbb3b202))  by @oldgiova
- Added mongodb as a sub-chart
 ([bec2d16](https://github.com/mendersoftware/mender-helm/commit/bec2d1658d3f28b2f7682baea84e6117770f48fd))  by @oldgiova
- Added nats as a sub-chart
 ([81132e1](https://github.com/mendersoftware/mender-helm/commit/81132e137bbaaea26c37940799d9b54605e93773))  by @oldgiova




### Refac


- Helm chart install over temporary EKS cluster
 ([31c039b](https://github.com/mendersoftware/mender-helm/commit/31c039bf61fb4475e3115b9ced9cbe056c6d6c6d))  by @oldgiova




## 4.0.3 - 2023-05-18


### Bug Fixes


- Workaround to permissions error with S3 bucket
([MEN-6482](https://northerntech.atlassian.net/browse/MEN-6482)) ([df95913](https://github.com/mendersoftware/mender-helm/commit/df959133ec16425274f45fb3d3c4017b9af57f1e))  by @oldgiova




## 4.0.2 - 2023-05-15


### Bug Fixes


- Device-auth-license-count ImagePullBackOff
 ([4d8587c](https://github.com/mendersoftware/mender-helm/commit/4d8587cb00efb80b340a4b1cb7f04dd77fdf119c))  by @moto-timo


  As described in 'feat: Device count via deviceauth-enterprise cli.'
  in the documentation [1], Device License Count is only available
  with Enterprise.
  
  Avoid ImagePullBackOff and ErrImagePull by not deploying the
  device-auth-license-count cron job when global.enterprise is
  disabled.
  
  [1] https://github.com/mendersoftware/mender-docs/commit/0f4ca50dbee9fd98f131e6e15ae7c0572b7d79d7




### Features


- Add device_license_count variable
 ([3a168fc](https://github.com/mendersoftware/mender-helm/commit/3a168fc72c9a614311b34e7e96a579ca8e8cdb1f))  by @moto-timo


  To make enabling the device-auth-license-count cron job
  even more robust, add a new variable to control this
  preview feature.
  
  Thank you to @oldgiova for the suggestion [1].
  
  [1] https://github.com/mendersoftware/mender-helm/pull/151#discussion_r1193086966




## 4.0.1 - 2023-05-08


### Bug Fixes


- Using relative url, not s3 one
 ([80c208d](https://github.com/mendersoftware/mender-helm/commit/80c208da3bfc54dc81c21a3c214d077040e012d4))  by @oldgiova




### Features


- Using global registry.image.tag instead of specifying it in every deployment
 ([90fbe64](https://github.com/mendersoftware/mender-helm/commit/90fbe6487ea83cd759c41d9f6a633931d2c25720))  by @oldgiova




## 4.0.0 - 2023-05-04


### Bug Fixes


- Added required secret to the pre-release hook
 ([ef60e6f](https://github.com/mendersoftware/mender-helm/commit/ef60e6fc09c7ca2825e575d71b565c1a29535b0f))  by @oldgiova
- Prevents job already exists error
 ([fe75b38](https://github.com/mendersoftware/mender-helm/commit/fe75b38de057025fa18978649fbb6b27061c0c6c))  by @oldgiova
- Avoid appling index job if reporting is disabled
 ([7d3023e](https://github.com/mendersoftware/mender-helm/commit/7d3023e6a9a1cf8daaa5a8d03f70223011f7c155))  by @oldgiova
- Skip DEPLOYMENTS_REPORTING_ADDR env var if disabled
 ([52eb180](https://github.com/mendersoftware/mender-helm/commit/52eb180b347d87424bfa13755f1f92530d0bb687))  by @oldgiova
- Use correct docker image for storage daemon
 ([c7f272b](https://github.com/mendersoftware/mender-helm/commit/c7f272bcabf00d415e47b6925f1580cef543d029))  by @alfrunes
- Fix test affinity
 ([35cb33a](https://github.com/mendersoftware/mender-helm/commit/35cb33a7eaa0e62820e94add3e25182e4456660d))  by @oldgiova




### Features


- Added db migration helm hook
 ([5d7521b](https://github.com/mendersoftware/mender-helm/commit/5d7521b165e29af016fbd5fc359e51bead836522))  by @oldgiova
- Added tolerations
 ([3dd4a8f](https://github.com/mendersoftware/mender-helm/commit/3dd4a8faca52d405802ebf321bc2a8e7d2056fe5))  by @oldgiova
- Add artifact direct upload feature toggle
([MEN-6346](https://northerntech.atlassian.net/browse/MEN-6346)) ([cb78ae9](https://github.com/mendersoftware/mender-helm/commit/cb78ae959d0b122e5c86da2779b0626434d345fc))  by @alfrunes
- Added Opensearch as sub-chart
 ([b5b50d7](https://github.com/mendersoftware/mender-helm/commit/b5b50d763fb7188d6e3f004bb6addbfd635f24c5))  by @oldgiova
- Bump apiVersion to v2 and decoupling helm chart version
 ([f78dfe8](https://github.com/mendersoftware/mender-helm/commit/f78dfe805f2a6b7cfb19e31ae57d07368cf718d8))  by @oldgiova
- Publishing helm chart automation
 ([aaf0ea9](https://github.com/mendersoftware/mender-helm/commit/aaf0ea91d74997c82936fec9a9cf0c4a24efad69))  by @oldgiova




## 3.5.0 - 2023-02-23


### Features


- *(storage)* Add support for Azure Blob Storage type
([MEN-5961](https://northerntech.atlassian.net/browse/MEN-5961)) ([d8c30dd](https://github.com/mendersoftware/mender-helm/commit/d8c30dd971540854a42b6b1d2ddc5604b9fd7519))  by @MaciejTe

- Add reporting service and opensearch
([MEN-5972](https://northerntech.atlassian.net/browse/MEN-5972)) ([caa1633](https://github.com/mendersoftware/mender-helm/commit/caa1633c96b465a0dcbea72cb8353a0928bf883b))  by @tranchitella
- Add generate delta worker to the application stack
 ([49ee066](https://github.com/mendersoftware/mender-helm/commit/49ee066ef537f27a7ec55756762a0362363217d9))  by @alfrunes
- Upgrade to Mender 3.5.0
 ([bb5a0eb](https://github.com/mendersoftware/mender-helm/commit/bb5a0eba7bb70ab5fe89dfe90b6a2b01cb81c82e))  by @tranchitella




### Refac


- Reindex reporting hook Helm values and naming
 ([1736bd0](https://github.com/mendersoftware/mender-helm/commit/1736bd01de8defee3a0d323e55f8cc3330a54611))  by @alfrunes




## 3.4.0 - 2022-09-28


### Bug Fixes


- Gui deployment resource requests/limits from incorrect values
([MEN-5774](https://northerntech.atlassian.net/browse/MEN-5774)) ([bf6cf1b](https://github.com/mendersoftware/mender-helm/commit/bf6cf1b35988e1af95f6a2d78bbc46dfe1ea762f))  by @alfrunes


  The gui container takes the resource configurations from the device_auth
  helm values which uses higher resource requests and limits by default.
- AWS_EXTERNAL_URI not base64 encoded
([MEN-5775](https://northerntech.atlassian.net/browse/MEN-5775)) ([c70e21c](https://github.com/mendersoftware/mender-helm/commit/c70e21cd88aa1a537acc4009801c457ce41e155a))  by @alfrunes




### Features


- Configurable container ports for api-gateway
 ([a3d7e36](https://github.com/mendersoftware/mender-helm/commit/a3d7e365ec4e5e41a58bdcf1212bf98992560838))  by @WalterMoar




## 3.3.0 - 2022-07-04


### Bug Fixes


- *(gui-deploy)* Add imagePullSecrets
 ([23f53fd](https://github.com/mendersoftware/mender-helm/commit/23f53fddc6dc042e59c0f294a77b8f6be5df1b31))  by @chris13524

- *(security)* Set the allowed origins for deviceconnect service
 ([1f7a14a](https://github.com/mendersoftware/mender-helm/commit/1f7a14aa38c585cc4bf58ce3740c9cb8598ea81b))  by @alfrunes


  CWE-352
  changelog: title

- Allow configuring SMTP settings for sending emails
([MEN-5374](https://northerntech.atlassian.net/browse/MEN-5374)) ([e3cbac7](https://github.com/mendersoftware/mender-helm/commit/e3cbac70b3dffbdadceb734e4dafdd2e901cda3a))  by @alfrunes


  The values was previously ineffectual - the created secret was unused.
  Ticket: MEN-5374
  changelog: title
- Replace Hosted Mender references with `global.url` in workflows
([MEN-5375](https://northerntech.atlassian.net/browse/MEN-5375)) ([8101418](https://github.com/mendersoftware/mender-helm/commit/8101418ce6985979749b2ae562602fbb2e200289))  by @alfrunes
- Iot-manager service is not enterprise-only
 ([8788de3](https://github.com/mendersoftware/mender-helm/commit/8788de3d7ac30067c01dfdb7fbfa7c5b4f398501))  by @tranchitella
- Remove duplicated env variable
 ([65574b6](https://github.com/mendersoftware/mender-helm/commit/65574b64194b2ec63eeceba2a242fd9e76463b70))  by @tranchitella
- Enforce global.s3.AWS_FORCE_PATH_STYLE value
 ([9c76d98](https://github.com/mendersoftware/mender-helm/commit/9c76d989a7b8fa82d79eba7eecc0de267876f8bb))  by @alfrunes




### Features


- *(rate limits)* Set default rate limits and caching in Mender Enterprise
([MEN-5270](https://northerntech.atlassian.net/browse/MEN-5270)) ([87147f0](https://github.com/mendersoftware/mender-helm/commit/87147f0807a8fb27fc4c9f40ad4637dcad73a154))  by @tranchitella


  Add a redis pod and configure deviceauth and useradm to connect to it
  enabling rate limits and caching of JWT tokens. At the same time, set
  default rate limits in tenantadm.

- *(rate limits)* Add the ratelimit middleware to Traefik
([MEN-5270](https://northerntech.atlassian.net/browse/MEN-5270)) ([d4c02a5](https://github.com/mendersoftware/mender-helm/commit/d4c02a5f286230b06a0aff52092bb8339759fd56))  by @tranchitella


  Set a default average/burst rate limit of 100 requests per second.

- *(tenantadm)* Enable self-service sign-up if `hosted` is `true`
 ([fdf6382](https://github.com/mendersoftware/mender-helm/commit/fdf6382f916c71e7ffe5e744cd6c4f55a93bfa3c))  by @tranchitella

- Upgrade the Mender versions to the latest stable (3.2.1)
 ([3845212](https://github.com/mendersoftware/mender-helm/commit/3845212964cfd97081a1bfeda22775dfee26160e))  by @tranchitella
- Update default Docker tags to mender-3.2.2
 ([3303520](https://github.com/mendersoftware/mender-helm/commit/33035208ed6e6fe8ec2cd8374e36cc9e16ef676d))  by @tranchitella
- Add support for the AWS_EXTERNAL_URI deployments' setting
([MEN-5280](https://northerntech.atlassian.net/browse/MEN-5280)) ([a301c3e](https://github.com/mendersoftware/mender-helm/commit/a301c3e70ce2f1c9c7e69ef53eb65552df576ec9))  by @tranchitella


  Setting a value for the AWS_EXTERNAL_URI env variable in the deployments
  service, it is possible to use an external URL for the S3 storage when
  generating presigned download URLs and an internal URL for all the other
  API calls (e.g., uploading of artifacts).
- Add podAnnotations for all deployments
([MEN-5619](https://northerntech.atlassian.net/browse/MEN-5619)) ([7911391](https://github.com/mendersoftware/mender-helm/commit/7911391bc2d269c9e6811a2481ab32842badb1bc))  by @benjamin-texier
- Fallback on AWS_* environment variables if missing static credentials
 ([eb7101d](https://github.com/mendersoftware/mender-helm/commit/eb7101d1a740c33cf3dcac947c12e517a4d0ef13))  by @alfrunes
- Reuse service port for api-gateway entrypoints
 ([2ebbc48](https://github.com/mendersoftware/mender-helm/commit/2ebbc48818f3eacd812395a954a38b6de4b114ba))  by @alfrunes
- Mender 3.3.0 release
 ([01cba03](https://github.com/mendersoftware/mender-helm/commit/01cba03e37e1ae10eaaca67adbde8b02c795a541))  by @tranchitella




### Fix


- Set WORKFLOWS_NATS_URI for the components based on workflows
 ([26cad76](https://github.com/mendersoftware/mender-helm/commit/26cad76e7f00b50a608ebd21adb39cc98490c57c))  by @tranchitella
- Docker image name for tenantadm
 ([9d47ea1](https://github.com/mendersoftware/mender-helm/commit/9d47ea1b5ba7efcc822ba26e08ded450586131f5))  by @tranchitella
- Docker image for iot-manager in README
 ([26f64c4](https://github.com/mendersoftware/mender-helm/commit/26f64c42c3497d6ff6bf531040b4fbe3515f91a1))  by @tranchitella




## 2.7.0 - 2021-07-12


### Changelog


- Use k8s service account to access s3 bucket
 ([48d36d9](https://github.com/mendersoftware/mender-helm/commit/48d36d9ba2b8da99b0b51cc8acb4cd4f11ac1e88))  by @ffoysal




## 2.6.0 - 2021-03-12


### MEN-4486


- [pipeline] Run tests in Hosted Mender staging cluster
([MEN-4486](https://northerntech.atlassian.net/browse/MEN-4486)) ([5161914](https://github.com/mendersoftware/mender-helm/commit/5161914e18fa6b1787b0b94e4e6be68f5ed89c20))  by @lluiscampos


  This commit reworks the test job and the helper scripts to run the tests
  in HM staging, namespace mender-helm-tests.
  
  It assumes only one CI pipeline is running in parallel.
- Update chart for Mender 2.6.0
([MEN-4486](https://northerntech.atlassian.net/browse/MEN-4486)) ([f009fb9](https://github.com/mendersoftware/mender-helm/commit/f009fb9549fba5943b8c7340d358321b3d8b9343))  by @lluiscampos


  Adding new services auditlogs and deviceconnect.




## 2.5.0 - 2020-09-29


### README


- Install minio and mongodb from upstream charts instead of stable
 ([5bee4dc](https://github.com/mendersoftware/mender-helm/commit/5bee4dca5db22e009e0ebbf953c5adf2cb97ec3a))  by @tranchitella




---
