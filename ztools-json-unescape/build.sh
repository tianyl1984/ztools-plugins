#!/usr/bin/env bash
set -euo pipefail

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 1. 删除 dist 目录
echo "==> 删除 dist 目录..."
rm -rf dist

# 2. 执行构建
echo "==> 执行 npm run build..."
npm run build

# 3. 打包 dist 目录下所有文件
ZIP_NAME="ztools-json-unescape.zip"
echo "==> 打包 dist 目录到 ${ZIP_NAME}..."
rm -f "${ZIP_NAME}"
( cd dist && zip -r "../${ZIP_NAME}" . )

echo "==> 打包完成: ${ZIP_NAME}"
