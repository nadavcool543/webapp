{{- define "validate.redis" -}}
{{- if .Values.redis.enabled }}
{{- if not .Values.redis.auth.enabled }}
{{- fail "Redis authentication must be enabled when Redis is enabled" }}
{{- end }}
{{- if not .Values.redis.auth.password }}
{{- fail "Redis password must be set when Redis is enabled" }}
{{- end }}
{{- if not .Values.config.redis.host }}
{{- fail "Redis host must be configured when Redis is enabled" }}
{{- end }}
{{- if not .Values.config.redis.port }}
{{- fail "Redis port must be configured when Redis is enabled" }}
{{- end }}
{{- end }}
{{- end }}


{{- define "validate.storage" -}}
{{- if .Values.persistence.enabled }}
{{- if not .Values.global.storageClass }}
{{- fail "StorageClass must be specified when persistence is enabled" }}
{{- end }}
{{- end }}
{{- end }}


{{- define "validate.service" -}}
{{- if not (has .Values.service.type (list "ClusterIP" "NodePort" "LoadBalancer")) }}
{{- fail "Service type must be one of: ClusterIP, NodePort, LoadBalancer" }}
{{- end }}
{{- end }}
