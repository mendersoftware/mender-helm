{{- define "mongodb_uri" }}

  {{- if and ( not .Values.mongodb.enabled ) ( .Values.global.mongodb.URL ) }}
    {{- printf .Values.global.mongodb.URL | b64enc }}

  {{- else if and ( .Values.mongodb.enabled ) ( not .Values.mongodb.auth.enabled ) }}
    {{- printf "mongodb://%s-%s" .Release.Name "mongodb" | b64enc }}

  {{- else }}
    {{- fail "Internal mongodb is not enabled and global.mongodb.URL is not set" }}

  {{- end }}
{{- end }}
