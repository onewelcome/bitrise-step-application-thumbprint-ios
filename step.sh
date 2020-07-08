#!/bin/bash
set -e

if [[ "${is_debug}" == "yes" ]] ; then
	set -x
fi

curlQuietParam="-sS"
unzipQuietParam="-q"
if [[ "${is_debug}" == "yes" ]] ; then
	curlQuietParam=""
    unzipQuietParam=""
fi

echo "Calculator version: ${calculator_version}"
echo "Application path: ${application_path}"
echo "Temporary path: ${temporary_path}"

calculator_url="https://repo.onegini.com/artifactory/onegini-sdk/com/onegini/mobile/sdk/ios/ios-app-signature-calculator/${calculator_version}/ios-app-signature-calculator-${calculator_version}.jar"
calculator_download_path="${temporary_path}/ios-app-signature-calculator-${calculator_version}.jar"

curl ${curlQuietParam} -u ${onegini_artifactory_username}:${onegini_artifactory_password} ${calculator_url}  -o ${calculator_download_path}
unzip ${unzipQuietParam} -o ${application_path} -d ${temporary_path}
unzipped_app_path=$(find ${temporary_path} -name *.app) 
application_thumbprint=$(java -jar ${calculator_download_path} ${unzipped_app_path} -q)
envman add --key ONEGINI_APP_THUMBPRINT --value "${application_thumbprint}"
