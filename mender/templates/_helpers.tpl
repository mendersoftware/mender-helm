{{/*
Define Mender Major and minor version
to be able to apply some conditional logic
*/}}
{{- define "menderVersionMinor" }}
{{- with .Values.global.image }}
{{- if contains "-" .tag }}
  {{- $mndr_splitted := split "-" .tag -}}
  {{- $mndr_version := split "." $mndr_splitted._1 }}
  {{- printf "%s" $mndr_version._1 }}
{{- else }}
  {{- $mndr_version := split "." .tag }}
  {{- printf "%s" $mndr_version._1 }}
{{- end }}
{{- end }} 
{{- end }}

{{- define "menderVersionMajor" }}
{{- with .Values.global.image }}
{{- if contains "-" .tag }}
  {{- $mndr_splitted := split "-" .tag -}}
  {{- $mndr_version := split "." $mndr_splitted._1 }}
  {{- printf "%s" $mndr_version._0 }}
{{- else }}
  {{- $mndr_version := split "." .tag }}
  {{- printf "%s" $mndr_version._0 }}
{{- end }}
{{- end }}
{{- end }}
