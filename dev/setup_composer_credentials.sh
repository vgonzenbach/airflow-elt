#!/bin/bash

# This script set up credentials for the local composer environment
# Due to an an issue (https://github.com/GoogleCloudPlatform/composer-local-dev/issues/3) with composer-local-dev
# the credential file cannot be access unless permissions are changed. This is potentially insecure depending on your machine so use at your own risk.
COMPOSER_ENV_SA=`cd terraform && terraform output --json | jq '.composer_service_account.value'`

gcloud auth application-default login --impersonate-service-account="$COMPOSER_ENV_SA"