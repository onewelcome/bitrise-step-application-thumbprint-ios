#!/bin/bash
set -ex

echo "This is 'onegini_artifactory_username': ${onegini_artifactory_username}"
echo "This is 'onegini_artifactory_password': ${onegini_artifactory_password}"
echo "This is 'calculator_version': ${calculator_version}"
echo "This is 'application_path': ${application_path}"

result="Signature not calculated"

curl -u ${onegini_artifactory_username}:${onegini_artifactory_password} "https://repo.onegini.com/artifactory/onegini-sdk/com/onegini/mobile/sdk/ios/ios-app-signature-calculator/${calculator_version}/ios-app-signature-calculator-${calculator_version}.jar" -o "${temporary_path}/ios-app-signature-calculator-${calculator_version}.jar"
unzip -o ${application_path} -d ${temporary_path}
envman add --key ONEGINI_APP_THUMBPRINT --value "$(java -jar ${temporary_path}/ios-app-signature-calculator-${calculator_version}.jar $(find ${temporary_path} -name *.app))"

# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
