{{/*
    Create a default fully qualified app name.
    We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
    */}}
    {{- define "palworld.fullname" -}}
    {{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
    {{- $name := default .Chart.Name .Values.nameOverride -}}
    {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
    {{- end -}}
    {{- end -}}

{{/*
Generate basic labels
*/}}
{{- define "palworld.labels" -}}
helm.sh/chart: {{ include "palworld.chart" . }}
{{ include "palworld.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "palworld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "palworld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "palworld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the chart name and version.
*/}}
{{- define "palworld.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
calculate hash value based on palWorldSettings in values.yaml
*/}}
{{- define "palworld.settingsHash" -}}
{{- include "palWorldSettings" . | sha256sum -}}
{{- end -}}
    
{{/*
serialise palWorldSettings for hash calculation
*/}}
{{- define "palWorldSettings" -}}
{{- toYaml .Values.palWorldSettings | trim -}}
{{- end -}}

{{- define "palworld.secretsHash" -}}
{{- include "secrets" . | sha256sum -}}
{{- end -}}

{{- define "secrets" -}}
{{- toYaml .Values.secrets | trim -}}
{{- end -}}