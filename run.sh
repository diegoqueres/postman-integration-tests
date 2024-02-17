#!/bin/bash
echo "***** Postman Integration Tests *****"

config_file="$HOME/.postman/integration-tests/config.json"
config_data=$(cat "$config_file")
apis=$(jq -c '.' "$config_file")

api_names=()
api_prefixes=()
while IFS= read -r api; do
  api_name=$(jq -r '.apiName' <<< "$api")
  api_prefix=$(jq -r '.apiEnvPrefix' <<< "$api")
  api_names+=("$api_name")
  api_prefixes+=("$api_prefix")
done <<< "$(jq -c '.[] | select(.apiName != null and .apiEnvPrefix != null)' "$config_file")"

echo ""
PS3="Select one API for testing: "
select api_option in "${api_names[@]}" "Sair"; do
    case $api_option in
        "Sair")
            echo "Exiting."
            exit 0
            ;;
        *)
            api_index=$((REPLY - 1))
            selected_api_name="${api_names[$api_index]}"
            selected_api_prefix="${api_prefixes[$api_index]}"
            break
            ;;
    esac
done

postman_apikey_var="${selected_api_prefix}_POSTMAN_APIKEY"
env_dev_uuid_var="${selected_api_prefix}_ENV_DEV_UUID"
env_qa_uuid_var="${selected_api_prefix}_ENV_QA_UUID"

postman_apikey=${!postman_apikey_var}

env_dev_uuid=${!env_dev_uuid_var}
env_qa_uuid=${!env_qa_uuid_var}

echo -e "\nYou choose: '$selected_api_name'."
echo -e "Start testing '$selected_api_name' Api..."

echo ""
read -p "In which environment do you want to run tests? (dev/qa): " env
case $env in
  "dev")
    env_uuid=$env_dev_uuid
    ;;
  "qa")
    env_uuid=$env_qa_uuid
    ;;
  *)
    echo "Invalid option. Exiting."
    exit 1
    ;;
esac

api_config=$(jq -c ".[$api_index]" <<< "$apis")
collections=$(jq -c '.collections[]' <<< "$api_config")
while read -r collection; do
    collection_uuid=$(jq -r '.collectionUuid' <<< "$collection")
    collection_name=$(jq -r '.collectionName' <<< "$collection")
    auth_endpoint_uuid=$(jq -r '.authEndpointUuid' <<< "$collection")

    echo -e "\nRunning test cases for the collection: $collection_name"

    jq -c '.testCases[]' <<< "$collection" | while read -r test_case; do
        target=$(echo "$test_case" | jq -r '.target')
        description=$(echo "$test_case" | jq -r '.description')
        endpoints=$(echo "$test_case" | jq -r '.endpoints | map(.uuid) | join(" ")')

        echo -e "\n*** Testing '$target: $description'... ***"
        postman login --with-api-key "$postman_apikey"
        postman collection run "$collection_uuid" -e "$env_uuid" -i "$auth_endpoint_uuid" $(echo "$endpoints" | tr ' ' '\n' | awk '{print "-i",$1}' ORS=' ')
    done
done <<< "$collections"

echo -e "\n***** Script completed! *****"
