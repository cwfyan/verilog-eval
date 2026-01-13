#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TOOL_DIR="${ROOT_DIR}/tools/logisim-export"
THIRD_PARTY_DIR="${ROOT_DIR}/third_party/logisim-evolution"
BUILD_DIR="${TOOL_DIR}/build"
JAR_OUTPUT="${ROOT_DIR}/logisim-export.jar"

if [[ ! -d "${THIRD_PARTY_DIR}" ]]; then
  mkdir -p "${ROOT_DIR}/third_party"
  git clone --depth 1 --branch v4.0.0 https://github.com/logisim-evolution/logisim-evolution.git "${THIRD_PARTY_DIR}"
fi

pushd "${THIRD_PARTY_DIR}" > /dev/null
./gradlew --no-daemon shadowJar
LOGISIM_JAR=$(ls -1 "${THIRD_PARTY_DIR}"/build/libs/*-all.jar | head -n 1)
popd > /dev/null

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/classes" "${BUILD_DIR}/shadow"

javac \
  -cp "${LOGISIM_JAR}" \
  -d "${BUILD_DIR}/classes" \
  "${TOOL_DIR}/src/main/java/org/verilog_eval/logisim/LogisimExport.java"

pushd "${BUILD_DIR}/shadow" > /dev/null
jar xf "${LOGISIM_JAR}"
popd > /dev/null

cp -R "${BUILD_DIR}/classes/"* "${BUILD_DIR}/shadow/"

echo "Main-Class: org.verilog_eval.logisim.LogisimExport" > "${BUILD_DIR}/MANIFEST.MF"
jar --create --file "${JAR_OUTPUT}" --manifest "${BUILD_DIR}/MANIFEST.MF" -C "${BUILD_DIR}/shadow" .

echo "Built ${JAR_OUTPUT}"
