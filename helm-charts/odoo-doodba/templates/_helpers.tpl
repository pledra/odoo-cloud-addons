{{- define "odoo.name" -}}
{{- default "odoo" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "odoo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "odoo" .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "odoo.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{ include "odoo.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "odoo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odoo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "odoo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "odoo.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "odoo.image" -}}
{{- $repo := required "image.repository is required" .Values.image.repository -}}
{{- if .Values.image.digest -}}
{{- printf "%s@%s" $repo .Values.image.digest -}}
{{- else -}}
{{- printf "%s:%s" $repo (required "image.tag or image.digest is required" .Values.image.tag) -}}
{{- end -}}
{{- end -}}

{{- define "odoo.claimName" -}}
{{- default (include "odoo.fullname" .) .Values.persistence.existingClaim -}}
{{- end -}}

{{/* Database connection + Doodba settings, shared by the server and init containers. */}}
{{- define "odoo.env" -}}
{{- if .Values.cnpg.enabled }}
{{- $secret := printf "%s-app" .Values.cnpg.name }}
- name: PGHOST
  valueFrom: { secretKeyRef: { name: {{ $secret }}, key: host } }
- name: PGPORT
  valueFrom: { secretKeyRef: { name: {{ $secret }}, key: port } }
- name: PGUSER
  valueFrom: { secretKeyRef: { name: {{ $secret }}, key: username } }
- name: PGPASSWORD
  valueFrom: { secretKeyRef: { name: {{ $secret }}, key: password } }
{{- else }}
- name: PGHOST
  value: {{ required "externalDatabase.host is required when cnpg.enabled is false" .Values.externalDatabase.host | quote }}
- name: PGPORT
  value: {{ .Values.externalDatabase.port | quote }}
- name: PGUSER
  value: {{ .Values.externalDatabase.user | quote }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "externalDatabase.passwordSecret.name is required" .Values.externalDatabase.passwordSecret.name }}
      key: {{ .Values.externalDatabase.passwordSecret.key }}
{{- end }}
- name: PGDATABASE
  value: {{ .Values.odoo.database | quote }}
- name: DB_FILTER
  value: {{ printf "^%s$" .Values.odoo.database | quote }}
- name: LIST_DB
  value: {{ .Values.odoo.listDb | quote }}
- name: PROXY_MODE
  value: {{ .Values.odoo.proxyMode | quote }}
- name: WITHOUT_DEMO
  value: {{ .Values.odoo.withoutDemo | quote }}
- name: UNACCENT
  value: {{ .Values.odoo.unaccent | quote }}
- name: ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "odoo.adminPasswordSecret.name is required" .Values.odoo.adminPasswordSecret.name }}
      key: {{ .Values.odoo.adminPasswordSecret.key }}
{{- with .Values.odoo.extraEnv }}
{{ tpl (toYaml .) $ }}
{{- end }}
{{- end -}}

{{- define "odoo.volumeMounts" -}}
- name: config
  mountPath: /opt/odoo/custom/conf.d/90-helm.conf
  subPath: 90-helm.conf
  readOnly: true
{{- if .Values.persistence.enabled }}
- name: data
  mountPath: /var/lib/odoo
{{- end }}
{{- with .Values.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}
