{{ with secret "pki_nomad/cert/ca_chain" }}
{{ .Data.certificate }}
{{ end }}
