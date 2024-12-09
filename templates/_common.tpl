{{- define "common.metadata" -}}
metadata:
  name: {{ .Release.Name }}-{{ .name | default "resource" }}
  labels:
    {{- include "appDef" . | nindent 4 }}
    helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

###########
 {{- include "common.metadata" (dict "name" "webapp" "Release" .Release "Chart" .Chart) | nindent 0 }}
###########

{{- define "common.securityContext" -}}
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 2000
{{- end }}

{{- define "common.probes" -}}
livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 30
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /ready
    port: http
  initialDelaySeconds: 5
  periodSeconds: 5
{{- end }}

{{- define "common.ingressAnnotations" -}}
annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /
  kubernetes.io/ingress.class: nginx
{{- end }}

{{- define "common.servicePorts" -}}
ports:
  - name: http
    port: {{ .Values.service.port }}
    targetPort: http
    protocol: TCP
{{- end }}


{{- define "common.bool2str" -}}
{{- if . }}true{{ else }}false{{ end }}
{{- end }}
