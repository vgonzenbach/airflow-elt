PROJECT_ID=`gcloud config list --format 'value(core.project)'`
COMPOSER_ENV_NAME=`cd terraform && terraform output --json | jq '.composer_env_name.value'`
COMPOSER_ENV_REGION=`cd terraform && terraform output --json | jq '.composer_env_region.value'`

composer-dev create "$COMPOSER_ENV_NAME" \
    --from-source-environment "$COMPOSER_ENV_NAME" \
    --location "$COMPOSER_ENV_REGION" \
    --project "$PROJECT_ID" \
    --dags-path dags/ \
    --debug

# see https://github.com/GoogleCloudPlatform/composer-local-dev?tab=readme-ov-file#enable-the-container-user-to-access-mounted-files-and-directories-from-the-host
echo "COMPOSER_CONTAINER_RUN_AS_HOST_USER=True" > ./composer/"$COMPOSER_ENV_NAME"/variables.env 

composer-dev start "$COMPOSER_ENV_NAME"

