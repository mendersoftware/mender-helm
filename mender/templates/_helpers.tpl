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
{{- define "mender.redis.serviceName" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
  {{- if and $dot.Values.redis.enabled ( not $dot.Values.global.redis.URL ) }}
    {{- printf "%s-redis" ( include "mender.fullname" $dot ) -}}
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
  {{- if and $dot.Values.redis.enabled $dot.Values.redis.auth.enabled ( not $dot.Values.global.redis.URL ) }}
    {{- printf "redis://:%s@%s:6379" $dot.Values.redis.auth.password ( include "mender.redis.serviceName" $dot ) -}}
  {{- else if and $dot.Values.redis.enabled ( not $dot.Values.redis.auth.enabled ) ( not $dot.Values.global.redis.URL ) }}
    {{- printf "redis://%s:6379" ( include "mender.redis.serviceName" $dot ) -}}
  {{- else }}
    {{- printf $dot.Values.global.redis.URL | quote }}
  {{- end }}
{{- end }}

{{/*
MongoDB Service Name
*/}}
{{- define "mender.mongodb.serviceName" -}}
  {{- printf "%s-mongodb" (include "mender.fullname" .) -}}
{{- end }}

{{/*
MongoDB URI
*/}}
{{- define "mongodb_uri" }}
  {{- if .Values.mongodb.enabled }}
    {{- printf "mongodb://%s:%s@%s:27017" .Values.mongodb.auth.rootUsername .Values.mongodb.auth.rootPassword ( include "mender.mongodb.serviceName" . ) | b64enc | quote -}}
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
    {{- printf "HeaderRegexp(`X-Amz-Date`, `.+`) || PathPrefix(`/%s`)" .Values.global.s3.AWS_BUCKET | quote }}
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
      app.kubernetes.io/name: {{ .name }}
{{- end }}
{{- end }}

{{- define "mender.servicename" -}}
{{- printf "%s-%s" ( include "mender.fullname" .dot ) .component }}
{{- end }}

{{/* Helper for "mender.image" */}}
{{- define "mender.image.registry" }}
{{- if and .override.image .override.image.registry }}
{{- print .override.image.registry -}}
{{- else if and .dot.Values.global
                .dot.Values.global.image
                .dot.Values.global.image.registry}}
{{- print .dot.Values.global.image.registry -}}
{{- else if and .dot.Values.default.image .dot.Values.default.image.registry}}
{{- print .dot.Values.default.image.registry -}}
{{- else if .dot.Values.global.enterprise }}
{{- print "registry.mender.io" -}}
{{- else }}
{{- print "docker.io" -}}
{{- end }}
{{- end }}

{{/* Helper for "mender.image" */}}
{{- define "mender.image.repository" }}
{{- if and .override.image .override.image.repository }}
{{- print .override.image.repository -}}
{{- else if and .dot.Values.global
                .dot.Values.global.image
                .dot.Values.global.image.repository }}
{{- print .dot.Values.global.image.repository }}
{{- else if and .dot.Values.default.image .dot.Values.default.image.repository}}
{{- print .dot.Values.default.image.repository -}}
{{- else if .dot.Values.global.enterprise }}
{{- print "mender-server-enterprise" -}}
{{- else }}
{{- print "mendersoftware" -}}
{{- end }}
{{- end }}

{{/* Helper for "mender.image" */}}
{{- define "mender.image.tag" }}
{{- if and .override.image .override.image.tag }}
{{- print .override.image.tag -}}
{{- else if and .dot.Values.global
                .dot.Values.global.image
                .dot.Values.global.image.tag }}
{{- print .dot.Values.global.image.tag -}}
{{- else if and .dot.Values.default.image .dot.Values.default.image.tag}}
{{- print .dot.Values.default.image.tag -}}
{{- else }}
{{- print .dot.Chart.AppVersion -}}
{{- end }}
{{- end }}

{{/*
Synopsis:
image: {{ include "mender.image" (dict
  "dot" .
  "component" "<service>"
  "override" .Values.<service> }}
*/}}
{{- define "mender.image" }}
{{- printf "%s/%s/%s:%s"
  (include "mender.image.registry" .)
  (include "mender.image.repository" .)
  (default .component .imageComponent)
  (include "mender.image.tag" .) }}
{{- end }}

{{/*
Synopsis:
imagePullPolicy: {{ include "mender.imagePullPolicy" (dict
  "dot" .
  "component" "<service>"
  "override" .Values.<service> }}
*/}}
{{- define "mender.imagePullPolicy" }}
{{- if and .override.image .override.image.pullPolicy }}
{{ .override.image.pullPolicy }}
{{- else if and .dot.Values.default.image .dot.Values.default.image.pullPolicy }}
{{- .dot.Values.default.image.pullPolicy }}
{{- else }}
{{- "IfNotPresent" }}
{{- end }}
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
  {{- default "HostRegexp(`^artifacts.*$`)" .Values.api_gateway.storage_proxy.customRule | quote }}
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
