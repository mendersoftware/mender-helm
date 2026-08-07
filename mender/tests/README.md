# Mender Helm Chart Unit Tests

This directory contains Helm unit tests for the Mender chart using [helm-unittest](https://github.com/helm-unittest/helm-unittest).

## Test Suites

### 1. Database Migrations (`migrations_test.yaml`)
Tests the Helm hook migration jobs for database schema migrations.

**Coverage:**
- **Common migrations** (Open Source + Enterprise):
  - device-auth, deployments, deviceconfig, deviceconnect
  - inventory, iot-manager, useradm, workflows
- **Enterprise-only migrations**:
  - auditlogs, devicemonitor, tenantadm
- **Verification:**
  - Jobs are created when `dbmigration.enable: true`
  - Jobs respect service enabled/disabled state
  - Enterprise migrations only run when `global.enterprise: true`
  - Correct Helm hook annotations (pre-install, pre-upgrade)
  - Correct hook weight and delete policy

### 2. Open Source Backing Services (`opensource-backing-services_test.yaml`)
Tests the integrated MongoDB deployment for open source installations.

**Coverage:**
- **MongoDB Deployment:**
  - Creation when `mongodb.enabled: true`
  - Container configuration (image, env vars, ports)
  - Health probes (liveness, readiness)
  - Volume mounts (data persistence)
- **MongoDB Service:**
  - ClusterIP service on port 27017
  - Correct selectors
- **MongoDB Secret:**
  - Root password stored as base64
- **MongoDB PersistentVolumeClaim:**
  - Created when `mongodb.persistence.enabled: true`
  - Storage class configuration
  - Access modes and size

### 3. NATS Integration (`nats-integration_test.yaml`)
Tests the NATS message broker integration for open source installations.

**Coverage:**
- **NATS Environment Variables:**
  - WORKFLOWS_NATS_URI configuration
  - WORKFLOWS_NATS_STREAM_REPLICAS configuration
- **Configuration Modes:**
  - Integrated NATS (nats.enabled: true)
  - External NATS (via global.nats.URL)
  - NATS credentials from existing secret
- **Open Source Defaults:**
  - NATS enabled by default
  - JetStream replicas configured correctly

### 4. Workflows HPA (`workflows-hpa_test.yaml`)
Tests the Horizontal Pod Autoscaler for the workflows service.

**Coverage:**
- HPA creation conditions
- External metrics configuration
- Scale behavior policies
- Replica configuration

## Running Tests

### Run all tests:
```bash
helm unittest mender
```

### Run specific test suite:
```bash
helm unittest mender --file 'tests/migrations_test.yaml'
helm unittest mender --file 'tests/opensource-backing-services_test.yaml'
helm unittest mender --file 'tests/nats-integration_test.yaml'
helm unittest mender --file 'tests/workflows-hpa_test.yaml'
```

## Test Statistics

- **Total Test Suites:** 4
- **Total Tests:** 61
- **Coverage:**
  - Database migrations: 20 tests
  - MongoDB (Open Source): 25 tests
  - NATS integration: 7 tests
  - Workflows HPA: 9 tests

## Open Source vs Enterprise

The tests verify that the correct backing services are deployed based on the deployment type:

### Open Source Deployment
- **Integrated MongoDB** (`mongodb.enabled: true`)
- **Integrated NATS** (`nats.enabled: true`)
- **8 common migration jobs**

### Enterprise Deployment
- **External MongoDB** (via connection string)
- **External NATS** (via `global.nats.URL`)
- **11 migration jobs** (8 common + 3 enterprise-only)

## Prerequisites

Install the helm-unittest plugin:
```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```
