


{{/*
Expand the name of the chart.
*/}}
{{- define "aventus-exercise.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We ensure the `fullnameOverride` is handled correctly to prevent rendering issues.
*/}}
{{- define "aventus-exercise.fullname" -}}
{{- $fullnameOverride := .Values.fullnameOverride | default "" }}
{{- if ne $fullnameOverride "" }}
  {{- $fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
  {{- $name := default .Chart.Name .Values.nameOverride }}
  {{- if contains $name .Release.Name }}
    {{- .Release.Name | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aventus-exercise.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aventus-exercise.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aventus-exercise.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate PostgreSQL full name.
*/}}
{{- define "aventus-exercise.postgres-fullname" -}}
{{- printf "%s-%s" (include "aventus-exercise.fullname" .) "postgres" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate PostgreSQL name.
*/}}
{{- define "aventus-exercise.postgres-name" -}}
{{- printf "%s-%s" (include "aventus-exercise.fullname" .) "postgres" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aventus-exercise.labels" -}}
helm.sh/chart: {{ include "aventus-exercise.chart" . }}
app.kubernetes.io/name: {{ include "aventus-exercise.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "aventus-exercise.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
  {{- default (include "aventus-exercise.fullname" .) .Values.serviceAccount.name }}
{{- else }}
  {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
