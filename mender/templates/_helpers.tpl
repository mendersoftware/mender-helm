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
{{ include "mender.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: "mender"
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mender.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mender.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mender.uname" -}}
{{- if empty .Values.fullnameOverride -}}
{{- if empty .Values.nameOverride -}}
{{ .Values.clusterName }}-{{ .Values.nodeGroup }}
{{- else -}}
{{ .Values.nameOverride }}-{{ .Values.nodeGroup }}
{{- end -}}
{{- else -}}
{{ .Values.fullnameOverride }}
{{- end -}}
{{- end -}}


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


{{- define "mongodb_uri" }}

  {{- if and ( not .Values.mongodb.enabled ) ( .Values.global.mongodb.URL ) }}
    {{- printf .Values.global.mongodb.URL | b64enc }}

  {{- else if and ( .Values.mongodb.enabled ) ( not .Values.mongodb.auth.enabled ) }}
    {{- printf "mongodb://%s-%s" .Release.Name "mongodb" | b64enc }}

  {{- else }}
    {{- fail "Internal mongodb is not enabled and global.mongodb.URL is not set" }}

  {{- end }}
{{- end }}
