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
  {{- printf "%s-%s" $.Release.Name "redis-master:6379" | default "mender-redis:6379" | quote }}
{{- end }}

{{/*
MongoDB URI
*/}}
{{- define "mongodb_uri" }}
  {{- if and ( not .Values.mongodb.enabled ) ( .Values.global.mongodb.URL ) }}
    {{- printf .Values.global.mongodb.URL | b64enc }}
  {{- else if and ( .Values.mongodb.enabled ) ( not .Values.mongodb.auth.enabled ) }}
    {{- if eq .Values.mongodb.architecture "replicaset" }}
    {{- printf "mongodb://%s-%s" .Release.Name "mongodb-headless" | b64enc }}
    {{- else }}
      {{- printf "mongodb://%s-%s" .Release.Name "mongodb" | b64enc }}
    {{- end }}
  {{- else }}
    {{- fail "Internal mongodb is not enabled and global.mongodb.URL is not set" }}
  {{- end }}
{{- end }}

{{/*
nats_uri
*/}}
{{- define "nats_uri" }}
  {{- if and ( not .Values.nats.enabled ) ( .Values.global.nats.URL ) }}
    {{- printf .Values.global.nats.URL | quote }}
  {{- else if and ( .Values.nats.enabled ) ( not .Values.nats.auth.enabled ) }}
      {{- printf "nats://%s-%s" .Release.Name "nats" | quote }}
  {{- else }}
    {{- fail "nats sub-chart is not enabled and global.nats.URL is not set" }}
  {{- end }}
{{- end }}
