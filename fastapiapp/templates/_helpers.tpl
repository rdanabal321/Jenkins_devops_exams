{{/*
Expand the name of the chart.
*/}}
{{- define "fastapiapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "fastapiapp.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- if gt (len $fullname) 63 -}}
{{- $hash := sha1sum $fullname -}}
{{- printf "%s-%s" (trunc 63 $fullname) $hash | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $fullname -}}
{{- end -}}
{{- end -}}

{{/*
Create chart labels.
*/}}
{{- define "fastapiapp.labels" -}}
helm.sh/chart: {{ include "fastapiapp.chart" . }}
{{ include "fastapiapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create selector labels.
*/}}
{{- define "fastapiapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fastapiapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Expand the chart name.
*/}}
{{- define "fastapiapp.chart" -}}
{{- if .Chart.Name -}}
{{- .Chart.Name | printf "%s-%s" .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}