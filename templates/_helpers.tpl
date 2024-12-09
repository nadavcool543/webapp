{{- define "appDef" -}}
app: {{ tpl .Values.app . | quote }}
{{- end }}

{{- define "redisConfig" -}}
{{- if .Values.redis.enabled }}
env:
  - name: REDIS_HOST
    value: {{ .Values.config.redis.host | quote }}
  - name: REDIS_PORT
    value: {{ .Values.config.redis.port | quote }}
  - name: REDIS_PASSWORD
    value: {{ .Values.redis.auth.password | quote }}
{{- end }}
{{- end }}

{{- define "configMapEnv" -}}
envFrom:
  - configMapRef:
      name: {{ .Values.global.configMapName }}
{{- end }}

{{- define "listToEnv" -}}
{{- range . }}
- name: {{ . | upper }}
  value: "true"
{{- end }}
{{- end }}

#############

{{- define "getSecret" -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace "mysecret" }}
{{- if $secret }}
hasSecret: true
{{- end }}
{{- end }}

# Check if secret exists
{{ include "getSecret" . }}



{{- define "withLabel" -}}
{{- $label := .label | default "app" -}}
{{ $label }}: {{ .name }}
{{- end }}

# Add a label
{{ include "withLabel" (dict "name" "myapp") }}



{{- define "isNewVersion" -}}
{{- if semverCompare ">=1.0.0" .Chart.Version -}}
true
{{- else -}}
false
{{- end -}}
{{- end }}


# Check version
{{ include "isNewVersion" . }}

{{/*
Expand the name of the chart.
*/}}
{{- define "webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "webapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}
helm.sh/chart: {{ include "webapp.chart" . }}
{{ include "webapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}