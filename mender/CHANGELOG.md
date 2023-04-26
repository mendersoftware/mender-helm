# Mender Helm chart

# Version 4.0.0
* Restored last Mender stable version: `3.4.0`.
* Decoupling Helm Chart version (`version: 4.0.0`) from Mender version (`appVersion: "3.4.0"`): from now on, they can be updated independently.
* **BREAKING CHANGE**: drop Helm v2 support: bump Helm ApiVersion to v2.
* **BREAKING CHANGE**: added `dbmigration` option to run DB migrations before every
  new rollout. This change is enabled by default.

