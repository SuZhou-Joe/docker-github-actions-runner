curl  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb -f
echo "CHROME_BIN=/usr/bin/google-chrome"

# Parse Google Chrome version
FULL_CHROME_VERSION=$(google-chrome --product-version)
CHROME_VERSION=${FULL_CHROME_VERSION%.*}
echo "Chrome version is $FULL_CHROME_VERSION"

CHROME_PLATFORM="linux64"
CHROME_VERSIONS_URL="https://googlechromelabs.github.io/chrome-for-testing/latest-patch-versions-per-build-with-downloads.json"
CHROME_VERSIONS_JSON=$(curl -fsSL "${CHROME_VERSIONS_URL}")
CHROMEDRIVER_VERSION=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].version')
CHROMEDRIVER_URL=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].downloads.chromedriver[] | select(.platform=="'"${CHROME_PLATFORM}"'").url')
CHROMEDRIVER_ARCHIVE="chromedriver_linux64.zip"
CHROMEDRIVER_DIR="/usr/local/share/chromedriver-linux64"
CHROMEDRIVER_BIN="$CHROMEDRIVER_DIR/chromedriver"
curl $CHROMEDRIVER_URL -o $CHROMEDRIVER_ARCHIVE
unzip -qq $CHROMEDRIVER_ARCHIVE -d /usr/local/share
chmod +x $CHROMEDRIVER_BIN
ln -s "$CHROMEDRIVER_BIN" /usr/bin/
echo "CHROMEWEBDRIVER=$CHROMEDRIVER_DIR" | tee -a /etc/environment
CHROME_REVISION=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].revision')
CHROMIUM_REVISION=$(GetChromiumRevision $CHROME_REVISION)
CHROMIUM_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${CHROMIUM_REVISION}%2Fchrome-linux.zip?alt=media"
CHROMIUM_ARCHIVE="${CHROMIUM_REVISION}-chromium-linux.zip"
CHROMIUM_DIR="/usr/local/share/chromium"
CHROMIUM_BIN="${CHROMIUM_DIR}/chrome-linux/chrome"

echo "Installing chromium revision $CHROMIUM_REVISION"
curl $CHROMIUM_URL -o $CHROMIUM_ARCHIVE
mkdir $CHROMIUM_DIR
unzip -qq "./${CHROMIUM_ARCHIVE}" -d $CHROMIUM_DIR

ln -s $CHROMIUM_BIN /usr/bin/chromium
ln -s $CHROMIUM_BIN /usr/bin/chromium-browser