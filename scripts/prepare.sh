#!/usr/bin/env bash
set -euo pipefail

APP_URL="${APP_URL:-https://example.com}"
APP_NAME="${APP_NAME:-MyApp}"
PKG_NAME="${PKG_NAME:-com.rizx.webapp}"
ICON_URL="${ICON_URL:-}"

PKG_PATH=$(echo "$PKG_NAME" | tr '.' '/')
SAFE_NAME=$(echo "$APP_NAME" | sed 's/[^a-zA-Z0-9 _-]//g' | head -c 40)
# escape for sed
ESC_URL=$(printf '%s\n' "$APP_URL" | sed 's/[&/\]/\\&/g')

echo "URL=$APP_URL NAME=$SAFE_NAME PKG=$PKG_NAME"

rm -rf build_app
cp -r template build_app
cd build_app

find . -type f \( -name "*.xml" -o -name "*.gradle" -o -name "*.java" -o -name "*.properties" \) -print0 | \
  xargs -0 sed -i "s|__APP_NAME__|${SAFE_NAME}|g"
find . -type f \( -name "*.xml" -o -name "*.gradle" -o -name "*.java" -o -name "*.properties" \) -print0 | \
  xargs -0 sed -i "s|__PACKAGE_NAME__|${PKG_NAME}|g"
find . -type f \( -name "*.xml" -o -name "*.gradle" -o -name "*.java" -o -name "*.properties" \) -print0 | \
  xargs -0 sed -i "s|__APP_URL__|${ESC_URL}|g"

mkdir -p "app/src/main/java/${PKG_PATH}"
if [ -f app/src/main/java/com/webview/app/MainActivity.java ]; then
  sed -i "s|package __PACKAGE_NAME__;|package ${PKG_NAME};|g" app/src/main/java/com/webview/app/MainActivity.java || true
  mv app/src/main/java/com/webview/app/MainActivity.java "app/src/main/java/${PKG_PATH}/MainActivity.java"
  rm -rf app/src/main/java/com/webview
fi

# ensure package line correct after replace
JAVA_FILE="app/src/main/java/${PKG_PATH}/MainActivity.java"
if [ -f "$JAVA_FILE" ]; then
  sed -i "1s/^package .*/package ${PKG_NAME};/" "$JAVA_FILE"
fi

echo "Project prepared."
