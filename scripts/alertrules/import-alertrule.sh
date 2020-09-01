#!/bin/bash

CURRENT_DIR=$(dirname "$0")
source ${CURRENT_DIR}/vars.sh

cat ${CURRENT_DIR}/template/prefix.yaml > ${RULE_FILE_NAME}
yq p ${SUBSTRATE_RULES_FOLDER}/alerting-rules.yaml spec | sed 's/Less than one new block per minute on instance/test/gm' - | sed 's/{{ \$labels\.instance.*\n*\s*\t*}}/{{`{{ $labels.instance }}`}}/gm' - | sed 's/{{ $value.*\n*\s*\t*}}/{{`{{ $value }}`}}/gm' - | yq w - "spec.groups[*].rules[*].labels.origin" "{{ .Values.deploymentName }}" | sed "s/'{{ .Values.deploymentName }}'/{{ .Values.deploymentName }}/gm" - >> ${RULE_FILE_NAME}
cat ${CURRENT_DIR}/template/postfix.yaml >> ${RULE_FILE_NAME}
mv ${RULE_FILE_NAME} ${PROJECT_ROOT}/${CHART_FOLDER}

echo "imported new ${RULE_FILE_NAME}"
cat ${PROJECT_ROOT}/${CHART_FOLDER}/${RULE_FILE_NAME}