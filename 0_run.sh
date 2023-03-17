VERSION=1.8.33
VERSION_STRIPPED="${VERSION//./}"

echo "Downloading and extracting MyBB ${VERSION}\n" && sleep 1

# Tidy up
rm -Rf application/*

# Download MyBB (it not already downloaded)
FILE="$TMPDIR/mybb.zip"
if [ ! -f "$FILE" ]; then
  curl --output "$TMPDIR/mybb.zip" --progress-bar "https://resources.mybb.com/downloads/mybb_${VERSION_STRIPPED}.zip"
fi

# Extract MyBB
cp $FILE .
unzip $FILE 'Upload/*' -d "/tmp/mybb${VERSION_STRIPPED}" -qq -o
echo "(moving MyBB from /tmp to application)" && sleep 1
cp -R "/tmp/mybb${VERSION_STRIPPED}/Upload/" application && rm -Rf "/tmp/mybb${VERSION_STRIPPED}"
# rm $FILE

# https://www.php.net/manual/en/features.commandline.webserver.php
echo "\nStarting PHP development web server" && sleep 1
php -S localhost:9000 -t application

