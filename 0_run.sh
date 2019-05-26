VERSION=1.8.20
VERSION_STRIPPED="${VERSION//./}"

echo "Downloading and extracting MyBB ${VERSION}"
rm -Rf application/*
curl --output mybb.zip --progress-bar "https://resources.mybb.com/downloads/mybb_${VERSION_STRIPPED}.zip"
unzip mybb.zip 'Upload/*' -d "/tmp/mybb${VERSION_STRIPPED}" -qq -o
cp -R "/tmp/mybb${VERSION_STRIPPED}/Upload/" application && rm -Rf "/tmp/mybb${VERSION_STRIPPED}"
rm mybb.zip

echo "Copying pre-build config.php and settings.php into application directory"
# cp configuration/config_sqlite.php application/inc/config.php
# cp configuration/settings.php application/inc/settings.php
# echo 1 > application/install/lock

cp database/mybb.sdb application

# https://www.php.net/manual/en/features.commandline.webserver.php
echo "Starting PHP development web server"
php -S localhost:9000 -t application

echo "Use 'mybb.sdb' as the path to the SQLite database."
