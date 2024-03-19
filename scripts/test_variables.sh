#!/bin/bash 

# Script to manage Terraform Cloud private registry module environment variable to allow testing.
# This script needs some information passed as environment variables:
# - TFC_ORGANIZATION
# - MODULE_PROVIDER
# - MODULE_NAME
# - TFC_API_TOKEN
# - VAR_KEY
# - VAR_VALUE

tfc_api_url="https://app.terraform.io/api/v2"
auth_header="Authorization: Bearer ${TFC_API_TOKEN}"
content_header="Content-Type: application/vnd.api+json"

{
	run=$(curl --request GET --url "${tfc_api_url}/organizations/${TFC_ORGANIZATION}/tests/registry-modules/private/${TFC_ORGANIZATION}/${MODULE_NAME}/${MODULE_PROVIDER}/vars" \
	--header "${auth_header}" --header "${content_header}")
	if ! [[ "${run}" =~ "{\"data\":" ]]; then
		echo "${run}"
		exit 1
	fi
} ||
{
  exit 1
}

id=$(echo "${run}" | jq -r --arg key "${VAR_KEY}" '.data[] | select(.attributes.key|test ($key)) | .id')

if [[ "${id}" ]]; then
  json_string='{"data":{"attributes":{"key":"'"${VAR_KEY}"'","value":"'"${VAR_VALUE}"'"},"type":"vars"}}'
  json_payload=$(echo "${json_string}" | jq)
  {
    run=$(curl --request PATCH --url "${tfc_api_url}/organizations/${TFC_ORGANIZATION}/tests/registry-modules/private/${TFC_ORGANIZATION}/${MODULE_NAME}/${MODULE_PROVIDER}/vars/${id}" \
    --header "${auth_header}" --header "${content_header}" --data "${json_payload}")
    if ! [[ "${run}" =~ "{\"data\":" ]]; then
      echo "${run}"
      exit 1
    fi
  } ||
  {
    exit 1
  }
else
  json_string='{"data": {"type":"vars","attributes":{"key":"'"${VAR_KEY}"'","value":"'"${VAR_VALUE}"'","category":"env","sensitive":true}}}'
  json_payload=$(echo "${json_string}" | jq)
  {
    run=$(curl --request POST --url "${tfc_api_url}/organizations/${TFC_ORGANIZATION}/tests/registry-modules/private/${TFC_ORGANIZATION}/${MODULE_NAME}/${MODULE_PROVIDER}/vars" \
    --header "${auth_header}" --header "${content_header}" --data "${json_payload}")
    if ! [[ "${run}" =~ "{\"data\":" ]]; then
      echo "${run}"
      exit 1
    fi
  } ||
  {
    exit 1
  }
fi