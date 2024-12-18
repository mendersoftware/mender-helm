{{- if semverCompare "<3.10.0" .Capabilities.HelmVersion.Version }}
{{- fail "Chart requires helm >= 3.10.0" }}
{{- end }}
