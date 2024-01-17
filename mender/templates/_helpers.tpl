{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mender.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mender.fullname" -}}
{{- if contains .Chart.Name .Release.Name }}
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
helm.sh/chart: {{ include "mender.chart" $dot }}
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
    {{- else if not (eq .Values.global.architecture "replicaset") }}
      {{- if and .Values.mongodb.auth.enabled .Values.mongodb.auth.rootPassword  }}
        {{- printf "mongodb://root:%s@%s" .Values.mongodb.auth.rootPassword ( include "mongodb.service.nameOverride" .Subcharts.mongodb ) | b64enc | quote -}}
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
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ .name }}
spec:
  minAvailable: {{ $pdb.minAvailable | default 1 }}
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
  {{- if contains "-" .tag }}
    {{- $mndr_splitted := split "-" .tag -}}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." $mndr_splitted._1 }}
    {{- end }}
  {{- else }}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." .tag }}
    {{- end }}
  {{- end }}
{{- end }}
{{- printf "%s" $mndr_version._0 }}
{{- end }}

{{- define "menderVersionMinor" }}
{{- $dot := (ternary . .dot (empty .dot)) -}}
{{- $mndr_version := split "." $dot.Chart.AppVersion }}
{{- with $dot.Values.global.image }}
  {{- if contains "-" .tag }}
    {{- $mndr_splitted := split "-" .tag -}}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." $mndr_splitted._1 }}
    {{- end }}
  {{- else }}
    {{- if (regexMatch "^[0-9]+\\.[0-9]+" $mndr_splitted._1) }}
      {{- $mndr_version = split "." .tag }}
    {{- end }}
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
