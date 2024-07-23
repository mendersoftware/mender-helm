{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mender.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride }}
{{- else if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mender.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mender.labels" -}}
{{- $dot := (ternary . .dot (empty .dot)) -}}
app.kubernetes.io/managed-by: {{ $dot.Release.Service }}
app.kubernetes.io/part-of: mender
app.kubernetes.io/instance: {{ $dot.Release.Name }}
app.kubernetes.io/version: {{ $dot.Chart.AppVersion | quote }}
{{ include "mender.selectorLabels" . -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mender.selectorLabels" -}}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- if .component -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "mender.fullname" $dot) .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Redis address
*/}}
{{- define "redis_address" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
  {{- if and $dot.Values.redis.enabled ( not $dot.Values.global.redis.URL ) }}
    {{- printf "%s-master:6379" ( include "common.names.fullname" $dot.Subcharts.redis ) -}}
  {{- else }}
    {{- printf $dot.Values.global.redis.URL | quote }}
  {{- end }}
{{- end }}

{{/*
Validate Redis configuration
*/}}
{{- define "redis_conf_validation" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- if and $dot.Values.redis.enabled ( or $dot.Values.global.redis.URL $dot.Values.global.redis.existingSecret ) }}
{{- fail "When internal redis is enabled, both global.redis.URL and global.redis.existingSecret have to be unset" }}
{{- end }}
{{- if and $dot.Values.global.redis.URL $dot.Values.global.redis.existingSecret }}
{{- fail "Please set either global.redis.URL or global.redis.existingSecret, not both" }}
{{- end }}
{{- end }}

{{/*
Redis connection string
*/}}
{{- define "redis_connection_string" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
  {{- if and $dot.Values.redis.enabled ( not $dot.Values.global.redis.URL ) }}
    {{- printf "redis://%s-master:6379/0" ( include "common.names.fullname" $dot.Subcharts.redis ) -}}
  {{- else }}
    {{- printf $dot.Values.global.redis.URL | quote }}
  {{- end }}
{{- end }}

{{/*
MongoDB URI
*/}}
{{- define "mongodb_uri" }}
  {{- if and .Values.mongodb.enabled ( not .Values.global.mongodb.URL ) }}
    {{- if and (eq .Values.mongodb.architecture "replicaset") .Values.mongodb.externalAccess.enabled (eq .Values.mongodb.externalAccess.service.type "ClusterIP") }}
      {{- if and .Values.mongodb.auth.enabled .Values.mongodb.auth.rootPassword }}
        {{- printf "mongodb://root:%s@%s-0" .Values.mongodb.auth.rootPassword ( include "mongodb.fullname" .Subcharts.mongodb ) | b64enc | quote -}}
      {{- else }}
        {{- printf "mongodb://%s-0" ( include "mongodb.fullname" .Subcharts.mongodb ) | b64enc | quote -}}
      {{- end }}
    {{- else if not (eq .Values.mongodb.architecture "replicaset") }}
      {{- if and .Values.mongodb.auth.enabled .Values.mongodb.auth.rootPassword  }}
        {{- printf "mongodb://root:%s@%s" .Values.mongodb.auth.rootPassword ( include "mongodb.service.nameOverride" .Subcharts.mongodb ) | b64enc | quote -}}
      {{- else }}
        {{- printf "mongodb://%s" ( include "mongodb.service.nameOverride" .Subcharts.mongodb ) | b64enc | quote -}}
      {{- end }}
    {{- else if and (eq .Values.mongodb.architecture "replicaset") (not .Values.mongodb.externalAccess.enabled) }}
      {{- if and .Values.mongodb.auth.enabled .Values.mongodb.auth.rootPassword  }}
        {{- printf "mongodb+srv://root:%s@%s.%s.svc.cluster.local/?tls=false" .Values.mongodb.auth.rootPassword ( include "mongodb.service.nameOverride" .Subcharts.mongodb ) .Release.Namespace | b64enc | quote -}}
      {{- else }}
        {{- printf "mongodb://%s" ( include "mongodb.service.nameOverride" .Subcharts.mongodb ) | b64enc | quote -}}
      {{- end }}
    {{- else }}
      {{- fail "Failed: not implemented here." }}
    {{- end }}
  {{- else }}
    {{- printf .Values.global.mongodb.URL | b64enc | quote }}
  {{- end }}
{{- end }}

{{/*
nats_uri
*/}}
{{- define "nats_uri" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
  {{- if and $dot.Values.nats.enabled ( not $dot.Values.global.nats.URL ) }}
    {{- printf "nats://%s" ( include "nats.fullname" $dot.Subcharts.nats ) -}}
  {{- else }}
    {{- printf $dot.Values.global.nats.URL | quote }}
  {{- end }}
{{- end }}

{{/*
Ingress rules
*/}}
{{- define "mender.serviceName" -}}
{{- printf .Values.api_gateway.service.name | default "mender-api-gateway"}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "mender.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}


{{/*
Return if ingress is stable.
*/}}
{{- define "mender.ingress.isStable" -}}
  {{- eq (include "mender.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}
{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "mender.ingress.supportsIngressClassName" -}}
  {{- or (eq (include "mender.ingress.isStable" .) "true") (and (eq (include "mender.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
MinIO Rule
*/}}
{{- define "minioRule" -}}
  {{- if .Values.api_gateway.minio.customRule }}
    {{- printf .Values.api_gateway.minio.customRule | quote }}
  {{- else }}
    {{- printf "HeadersRegexp(`X-Amz-Date`, `.+`) || PathPrefix(`/%s`)" .Values.global.s3.AWS_BUCKET | quote }}
  {{- end }}
{{- end -}}

{{- define "mender.autoscaler" -}}
{{- $autoscaling := dict }}
{{- if .default.hpa }}
{{- $_ := (mergeOverwrite $autoscaling .default.hpa) }}
{{- end }}
{{- if .override.hpa }}
{{- $_ := (mergeOverwrite $autoscaling .override.hpa) }}
{{- end }}
{{- if and $autoscaling.enabled $autoscaling.metrics}}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .name }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .name }}
  minReplicas: {{ $autoscaling.minReplicas | default 1 }}
  maxReplicas: {{ $autoscaling.maxReplicas | default 1 }}
  metrics:
  {{- if $autoscaling.metrics }}
    {{- toYaml $autoscaling.metrics | nindent 4 }}
  {{- end }}
  {{- if $autoscaling.behavior }}
  behavior:
    {{- toYaml $autoscaling.behavior | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mender.pdb" -}}
{{- $pdb := dict }}
{{- if .default.pdb }}
{{- $_ := (mergeOverwrite $pdb .default.pdb) }}
{{- end }}
{{- if .override.pdb }}
{{- $_ := (mergeOverwrite $pdb .override.pdb) }}
{{- end }}
{{- if $pdb.enabled }}
{{- if and $pdb.minAvailable $pdb.maxUnavailable }}
{{- fail "Only one of minAvailable or maxUnavailable can be set" }}
{{- end }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ .name }}
spec:
  {{- if $pdb.minAvailable }}
  minAvailable: {{ $pdb.minAvailable | default 1 }}
  {{- else if $pdb.maxUnavailable }}
  maxUnavailable: {{ $pdb.maxUnavailable | default 1 }}
  {{- end }}
  selector:
    matchLabels:
      run: {{ .name }}
{{- end }}
{{- end }}

{{- define "mender.servicename" -}}
{{- printf "%s-%s" ( include "mender.fullname" .dot ) .component }}
{{- end }}

{{- define "mender.resources" -}}
{{- $resources := dict }}
{{- range . }}{{- if . }}
{{- $resources := mergeOverwrite $resources (deepCopy .) }}
{{- end }}{{- end }}
{{- if $resources }}
{{- toYaml $resources }}
{{- end }}
{{- end }}

{{/*
Define Mender major and minor version
to be able to apply some conditional logic
*/}}
{{- define "menderVersionMajor" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- $mndr_version := split "." $dot.Chart.AppVersion }}
{{- with $dot.Values.global.image }}
  {{- if contains "mender-" .tag }}
    {{- $mndr_splitted := split "-" .tag -}}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." $mndr_splitted._1 }}
    {{- end }}
  {{- else }}
    {{- fail "Invalid global.image.tag specified: must start with mender- " }}
  {{- end }}
{{- end }}
{{- printf "%s" $mndr_version._0 }}
{{- end }}

{{- define "menderVersionMinor" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- $mndr_version := split "." $dot.Chart.AppVersion }}
{{- with $dot.Values.global.image }}
  {{- if contains "mender-" .tag }}
    {{- $mndr_splitted := split "-" .tag -}}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." $mndr_splitted._1 }}
    {{- end }}
  {{- else }}
    {{- fail "Invalid global.image.tag specified: must start with mender- " }}
  {{- end }}
{{- end }}
{{- printf "%s" $mndr_version._1 }}
{{- end }}

{{/*
Create the name of the service account
*/}}
{{- define "mender.serviceAccountName" -}}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- if $dot.Values.serviceAccount.create }}
{{- default (include "mender.fullname" $dot) $dot.Values.serviceAccount.name }}
{{- else }}
{{- default "default" $dot.Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Synopsis:
{{- include "mender.customEnvs" (merge (deepCopy .dot.Values.<service>) (deepCopy (default (dict) .dot.Values.default))) | nindent 4 }}
*/}}
{{- define "mender.customEnvs" -}}
{{- with .customEnvs }}
{{- toYaml . }}
{{- println "" }}
{{- end }}
{{- end -}}

{{/*
Define mender.storageProxyUrl
*/}}
{{- define "mender.storageProxyUrl" -}}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- with $dot.Values.api_gateway.storage_proxy }}
  {{- if .url }}
    {{- printf "%s" .url }}
  {{- else if eq $dot.Values.global.storage "aws" }}
    {{- printf "https://%s.s3.%s.amazonaws.com" $dot.Values.global.s3.AWS_BUCKET $dot.Values.global.s3.AWS_REGION}}
  {{- else }}
    {{- required "A valid storage proxy URL is required" $dot.Values.api_gateway.storage_proxy.url }}
  {{- end }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{/*
Storage Proxy Rule
*/}}
{{- define "mender.storageProxyRule" -}}
  {{- default "HostRegexp(`{domain:^artifacts.*$}`)" .Values.api_gateway.storage_proxy.customRule | quote }}
{{- end -}}

{{/*
Use custom probes overrides
*/}}
{{- define "mender.probesOverrides" -}}
{{- $_ := dict }}
{{- $_ := (mergeOverwrite $_ .default .override) }}
{{- if $_ }}
{{- toYaml $_ }}
{{- end }}
{{- end }}
