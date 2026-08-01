#!/usr/bin/env bash
set -euo pipefail

# 切换到脚本所在目录
cd "$(dirname "$0")"

FAILED=()
SUCCEEDED=()

for dir in */; do
  script="${dir}build.sh"
  [ -f "$script" ] || continue

  name="${dir%/}"
  echo "==> 开始构建: ${name}"
  if bash "$script"; then
    SUCCEEDED+=("$name")
    echo "==> 构建成功: ${name}"
  else
    FAILED+=("$name")
    echo "==> 构建失败: ${name}" >&2
  fi
  echo
done

echo "==> 构建结果汇总"
echo "成功 (${#SUCCEEDED[@]}): ${SUCCEEDED[*]:-无}"
echo "失败 (${#FAILED[@]}): ${FAILED[*]:-无}"

[ ${#FAILED[@]} -eq 0 ]
