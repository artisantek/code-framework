{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
labels:
  service: {{ .Values.deployment.name | quote }}
  environment: {{ .Values.environment | quote }}
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/managed-by: "{{ .Release.Service }}"
  {{- if .Chart.AppVersion }}
  appVersion: {{ .Chart.AppVersion | quote }}
  {{- end }}
{{- end -}}
