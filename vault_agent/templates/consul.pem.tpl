{{ with pkiCert "pki_consul/issue/consul-dc1" "common_name=client.dc1.consul" "ttl=24h" "alt_names=localhost" "ip_sans=127.0.0.1" }}
{{ .Data.Key }}
{{ .Data.Cert }}
{{ end }}
