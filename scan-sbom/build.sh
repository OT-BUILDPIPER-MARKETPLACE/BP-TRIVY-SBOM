#!/bin/bash
source /opt/buildpiper/shell-functions/functions.sh
source /opt/buildpiper/shell-functions/log-functions.sh

logInfoMessage "I'll generate report at [${WORKSPACE}/${CODEBASE_DIR}]"

cd ${WORKSPACE}/${CODEBASE_DIR}

if [ -d "report" ]; then
    true
else
    mkdir report 
fi

STATUS=0
if [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_TAG" ]
then
    logInfoMessage "Image name/tag is not provided in env variable $IMAGE_NAME checking it in BP data"
    logInfoMessage "Image Name -> ${IMAGE_NAME}"
    logInfoMessage "Image Tag -> ${IMAGE_TAG}"
    IMAGE_NAME=`getComponentName`
    IMAGE_TAG=`getRepositoryTag`
fi

if [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_TAG" ]
then
    logErrorMessage "Image name/tag is not available in BP data as well please check!!!!!!"
    logInfoMessage "Image Name -> ${IMAGE_NAME}"
    logInfoMessage "Image Tag -> ${IMAGE_TAG}"
    STATUS=1
else
    logInfoMessage "I'll scan the SBOM report/${SBOM_REPORT_NAME} for image ${IMAGE_NAME}:${IMAGE_TAG}"
    sleep  $SLEEP_DURATION
    logInfoMessage "Executing command"
    logInfoMessage "    trivy sbom -s ${SCAN_SEVERITY} -o report/${OUTPUT_ARG} -f ${FORMAT_ARG} --exit-code 1 report/${SBOM_REPORT_NAME}"
    # trivy sbom -s ${SCAN_SEVERITY} -o report/${OUTPUT_ARG} -f ${FORMAT_ARG} --exit-code 1 report/${SBOM_REPORT_NAME}
    trivy sbom -s ${SCAN_SEVERITY} -o report/${OUTPUT_ARG} -f ${FORMAT_ARG} --exit-code 1 report/${SBOM_REPORT_NAME}

    STATUS=`echo $?`
fi

if [ $STATUS -eq 0 ]
then
  logInfoMessage "Congratulations Trivy SBOM scan succeeded!!!"
  ls -al report/
  cat report/${OUTPUT_ARG}
  generateOutput ${ACTIVITY_SUB_TASK_CODE} true "Congratulations Trivy SBOM scan succeeded!!!"

elif [ $VALIDATION_FAILURE_ACTION == "FAILURE" ]
  then
    logErrorMessage "Please check Trivy SBOM scan failed!!!"
    generateOutput ${ACTIVITY_SUB_TASK_CODE} false "Please check Trivy SBOM scan failed!!!"
    exit 1
   else
    logWarningMessage "Please check Trivy SBOM scan failed!!!"
    generateOutput ${ACTIVITY_SUB_TASK_CODE} true "Please check Trivy SBOM scan failed!!!"
fi