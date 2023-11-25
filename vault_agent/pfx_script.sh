#!/bin/bash
app=${1}
cert_dir=${2}

app_certificate="${cert_dir}/${app}.pem"
app_ca="${cert_dir}/${app}-ca.pem"
app_pfx="${cert_dir}/${app}.pfx"

tmp_key_file="${cert_dir}/tmp_${app}.key"
tmp_cert_file="${cert_dir}/tmp_${app}.pem"
tmp_bundle_file="${cert_dir}/tmp_${app}-bundle.crt"

if [ -f ${app_certificate} ] && [ -f ${app_ca} ]; then
    # Extract certificate from file
    awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/' ${app_certificate} > ${tmp_cert_file}
    # Extract private key from file
    awk '/-----BEGIN RSA PRIVATE KEY-----/,/-----END RSA PRIVATE KEY-----/' ${app_certificate} > ${tmp_key_file}
    # Create temporary bundle of cert and CA
    cat ${tmp_cert_file} ${app_ca} > ${tmp_bundle_file}
    openssl pkcs12 -export -out ${app_pfx} \
        -inkey ${tmp_key_file} \
        -in ${tmp_bundle_file} \
        -passout pass:
    rm -rf ${tmp_key_file} ${tmp_cert_file} ${tmp_bundle_file}
else
    exit 0
fi
