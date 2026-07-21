# Upgrading from Helm Chart 7.x to 8.x

The Helm Chart 8.x upgrades the bundled NATS subchart from 0.19.17 to
2.14.0. As a result, several values keys changed path, a behavioral
default changed, and in-place upgrades of existing NATS clusters are not
supported by this release.

Three additional breaking changes are bundled in this release:

- The `featureGates.k8sTlsSecrets` feature gate is removed; the
  `kubernetes.io/tls` Secret type is now the only supported behavior.
- The `device_license_count` feature is removed; use `device_auth.cronjobs`
  instead.
- `global.nats.existingSecret` and `global.nats.URL` are deprecated in
  favour of `nats.existingSecret` and `nats.URL`.

## Before you start

Ensure you have your current values override file from the previous
installation and review **all sections below** before running the upgrade.
This release contains multiple breaking changes.

```bash
cp mender-7.x.yml mender-values.yml
```

## NATS subchart values schema change

The NATS subchart 2.x reorganised all configuration under a `config:` key.
If you have any of the following keys in your override values file, you
must remap them before upgrading:

| Old key (7.x) | New key (8.x) |
|---|---|
| `nats.replicas` | removed - set `nats.config.cluster.replicas` instead |
| `nats.cluster.enabled` | `nats.config.cluster.enabled` |
| `nats.cluster.replicas` | `nats.config.cluster.replicas` |
| `nats.nats.image.tag` | removed - use chart default or `nats.container.image.tag` |
| `nats.nats.jetstream.enabled` | `nats.config.jetstream.enabled` |
| `nats.nats.jetstream.memStorage.enabled` | `nats.config.jetstream.memoryStore.enabled` |
| `nats.nats.jetstream.memStorage.size` | `nats.config.jetstream.memoryStore.maxSize` |
| `nats.nats.jetstream.fileStorage.enabled` | `nats.config.jetstream.fileStore.enabled` |
| `nats.nats.jetstream.fileStorage.size` | `nats.config.jetstream.fileStore.pvc.size` |
| `nats.nats.jetstream.fileStorage.storageDirectory` | `nats.config.jetstream.fileStore.dir` |
| `nats.nats.jetstream.fileStorage.storageClassName` | `nats.config.jetstream.fileStore.pvc.storageClassName` |

**Important:** Helm does not error on unknown subchart values - old keys
are silently discarded. If you skip this migration your custom NATS
settings (storage class, PVC size, cluster topology) will revert to chart
defaults without any warning.

Example migration for a custom JetStream storage class:

```yaml
# 7.x - no longer has any effect in 8.x
nats:
  nats:
    jetstream:
      fileStorage:
        size: "50Gi"
        storageClassName: "fast-ssd"

# 8.x - correct path
nats:
  config:
    jetstream:
      fileStore:
        pvc:
          size: "50Gi"
          storageClassName: "fast-ssd"
```

## JetStream stream replication factor change

The `WORKFLOWS_NATS_STREAM_REPLICAS` environment variable, which controls
the JetStream stream replication factor used by the workflows service,
changes from `1` to `3` in the default configuration.

If you are running a single-node NATS setup, set this explicitly to match:

```yaml
# 8.x - single-node setup
nats:
  config:
    cluster:
      enabled: false
      replicas: 1

workflows:
  nats:
    replicas: 1
```

## In-place NATS upgrades are not supported

The 0.x to 2.x NATS chart upgrade changes Kubernetes resource names and
StatefulSet selector labels. Performing a `helm upgrade` on an existing
cluster without additional migration steps will cause Helm to fail or
leave resources in an inconsistent state.

**Supported upgrade path:** provision a new NATS cluster alongside the
existing one, drain JetStream state if required, then switch over. The
NATS project publishes guidance on cluster migration in its documentation.

If you are running NATS with `global.nats.URL` or `nats.URL` pointing to
an external cluster, this does not apply - simply upgrade normally.

## Deprecated: global.nats.existingSecret and global.nats.URL

The `global.nats.existingSecret` and `global.nats.URL` values are
deprecated. They continue to work in 8.x but will be removed in 9.x.
Migrate to the new keys at your convenience:

```yaml
# 7.x - still works in 8.x but deprecated
global:
  nats:
    existingSecret: "my-nats-secret"
    URL: "nats://external-nats:4222"

# 8.x - preferred
nats:
  existingSecret: "my-nats-secret"
  URL: "nats://external-nats:4222"
```

## API Gateway TLS Secret type change (SSL installs only)

**Affects:** installs with `api_gateway.env.SSL: true`.
**Non-SSL installs:** no action required, skip this section.

In v8, the API Gateway TLS Secret always uses the standard
`kubernetes.io/tls` type with key names `tls.crt` and `tls.key`.
Previously the Secret was an Opaque type with `cert.crt`/`private.key`.

**Kubernetes does not allow changing a Secret's type in-place.**
Before upgrading, delete the existing secret:

```bash
kubectl delete secret api-gateway -n <your-namespace>
```

Helm will recreate it with the correct type during `helm upgrade`.

If you use `api_gateway.certs.existingSecret` pointing to a Secret you
manage yourself, recreate that Secret with the new key names:

```bash
kubectl create secret tls <your-secret-name> \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n <your-namespace>
```

The `featureGates.k8sTlsSecrets` value is removed. If you had it set,
remove it from your override file:

```yaml
# remove this block entirely
featureGates:
  k8sTlsSecrets: true  # or false - no longer used
```

## Removal of device_license_count

The `device_license_count` feature was deprecated in v7 and is now
removed. The `device_auth.cronjobs` mechanism replaces it and is
**enabled by default in v8** with the `device-auth-license-count` job
pre-configured.

If you had `device_license_count` enabled, delete the old CronJob
before upgrading to avoid a name conflict:

```bash
kubectl delete cronjob <release-name>-device-auth-license-count \
  -n <your-namespace>
```

If you had `device_license_count.enabled: false`, disable the
replacement job in your override file:

```yaml
device_auth:
  cronjobs:
    enabled: false
```

## Deprecated values (still work in 8.x, removed in 9.x)

| Deprecated key | Use instead |
|---|---|
| `global.nats.existingSecret` | `nats.existingSecret` |
| `global.nats.URL` | `nats.URL` |

## Upgrade procedure

After applying all changes above to your values file:

```bash
helm upgrade my-release -f mender-values.yml ./mender
```
