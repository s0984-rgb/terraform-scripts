{{ with pkiCert "pki_nomad/issue/nomad-dc1" "common_name=client.dc1.nomad" "ttl=24h" "ip_sans=127.0.0.1" }}
{{ .Data.Key }}
{{ .Data.Cert }}
{{ end }}
