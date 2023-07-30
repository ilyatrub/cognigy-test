# labels templates
{{- define "password-generator.default_labels" -}}
application: {{ .Release.Name }}
version: {{ .Chart.AppVersion }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "password-generator.full_labels" -}}
{{- include "password-generator.default_labels" $ -}}
{{- with $.Values.general.commonLabels -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}


{{- define "password-generator.service_labels" -}}
{{- include "password-generator.full_labels" $ -}}
{{- with $.Values.service.labels -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}

{{- define "password-generator.ingress_labels" -}}
{{- include "password-generator.full_labels" $ -}}
{{- with $.Values.ingress.labels -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}

# annotations templates
{{- define "password-generator.default_annotations" -}}
{{- end -}}

{{- define "password-generator.full_annotations" -}}
{{- include "password-generator.default_annotations" . -}}
{{- with $.Values.general.commonAnnotations -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}

{{- define "password-generator.service_annotations" -}}
{{- include "password-generator.full_annotations" . -}}
{{- with $.Values.service.annotations -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}

{{- define "password-generator.ingress_annotations" -}}
{{- include "password-generator.full_annotations" . -}}
{{- with $.Values.ingress.annotations -}}
{{- toYaml . -}}
{{- end -}}
{{- end -}}

# pod spec template
{{- define "password-generator.pod_spec" -}}
spec:
  {{- with .imagePullSecretName }}
  imagePullSecrets:
    - name: {{ . }}
  {{- end }}
  containers:
    - name: passgen
      image: {{ .image }}
      imagePullPolicy: {{ .imagePullPolicy }}
      ports:
        - containerPort: 3000
      {{- with .command -}}
      command: {{- toYaml . -}}
      {{- end -}}
      {{- with .args -}}
      args: {{- toYaml . -}}
      {{- end -}}
      {{- with .env -}}
      env: {{- toYaml . -}}
      {{- end -}}
{{- end -}}

# name template
{{- define "password-generator.name" -}}
{{ $.Release.Name | default $.Chart.Name }}
{{- end -}}

# namespace template
{{- define "password-generator.namespace" -}}
{{ $.Release.Namespace | default "default" }}
{{- end -}}