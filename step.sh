#!/bin/bash
set -e

if [[ "${is_debug}" == "yes" ]] ; then
	set -x
fi

echo "This is 'onegini_artifactory_username': ${onegini_artifactory_username}"
echo "This is 'onegini_artifactory_password': ${onegini_artifactory_password}"
echo "This is 'calculator_version': ${calculator_version}"
echo "This is 'application_path': ${application_path}"

calculator_url="https://repo.onegini.com/artifactory/onegini-sdk/com/onegini/mobile/sdk/ios/ios-app-signature-calculator/${calculator_version}/ios-app-signature-calculator-${calculator_version}.jar"
calculator_download_path="${temporary_path}/ios-app-signature-calculator-${calculator_version}.jar"

curl -u ${onegini_artifactory_username}:${onegini_artifactory_password} ${calculator_url}  -o ${calculator_download_path}
unzip -o ${application_path} -d ${temporary_path}
unzipped_app_path=$(find ${temporary_path} -name *.app) 
application_thumbprint=$(java -jar ${calculator_download_path} ${unzipped_app_path} -q)
envman add --key ONEGINI_APP_THUMBPRINT --value "${application_thumbprint}"
