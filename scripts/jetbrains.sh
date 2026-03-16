#!/usr/bin/env bash

set -euo pipefail

TMP_DIR="/tmp"
INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"
SYMLINK_DIR="$HOME/.local/bin"

BLUE="\e[94m"
GREEN="\e[32m"
END="\e[39m"

echo -e "===== Installing JetBrains Toolbox =====\n"
echo -e "${BLUE}Fetching the URL of the latest version...${END}"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "${BLUE}Downloading $ARCHIVE_FILENAME...${END}"
rm "$TMP_DIR/$ARCHIVE_FILENAME" 2>/dev/null || true
wget -q --show-progress -cO "$TMP_DIR/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

echo -e "${BLUE}Extracting to ${INSTALL_DIR}...${END}"
mkdir -p "${INSTALL_DIR}"
rm "${INSTALL_DIR}/jetbrains-toolbox" 2>/dev/null || true
tar -xzf "$TMP_DIR/$ARCHIVE_FILENAME" -C "${INSTALL_DIR}" --strip-components=1
rm "$TMP_DIR/$ARCHIVE_FILENAME"
chmod +x "${INSTALL_DIR}/bin/jetbrains-toolbox"

echo -e "${BLUE}Symlinking to ${SYMLINK_DIR}/jetbrains-toolbox...${END}"
mkdir -p "${SYMLINK_DIR}"
rm "${SYMLINK_DIR}/jetbrains-toolbox" 2>/dev/null || true
ln -s "${INSTALL_DIR}/bin/jetbrains-toolbox" "${SYMLINK_DIR}/jetbrains-toolbox"

echo -e "${GREEN}Done! JetBrains Toolbox should now be available in your application list!${END}"
echo -e "You can run it in terminal as jetbrains-toolbox (ensure that ${SYMLINK_DIR} is on PATH)${END}\n"

echo -e "===== JetBrains Toolbox installation complete =====\n"
