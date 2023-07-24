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
helm.sh/chart: {{ include "mender.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: mender
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Redis address
*/}}
{{- define "redis_address" }}
  {{- if and .Values.redis.enabled ( not .Values.global.redis.URL ) }}
    {{- printf "%s-headless:6379" ( include "common.names.fullname" .Subcharts.redis ) -}}
  {{- else }}
    {{- printf .Values.global.redis.URL | quote }}
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
  {{- if and .Values.nats.enabled ( not .Values.global.nats.URL ) }}
    {{- printf "nats://%s" ( include "nats.fullname" .Subcharts.nats ) -}}
  {{- else }}
    {{- printf .Values.global.nats.URL | quote }}
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
