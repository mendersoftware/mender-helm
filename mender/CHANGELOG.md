---
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
