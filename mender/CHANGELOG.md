# Mender Helm chart

# Version 4.0.0
* Added OpenSearch dependency as a Sub-Chart.
* Decoupling Helm Chart version (`version: 4.0.0`) from Mender version (`appVersion: "3.5.1"`): from now on, they can be updated independently.
* **BREAKING CHANGE**: drop Helm v2 support: bump Helm ApiVersion to v2.
