VERSION=1.8.20
VERSION_STRIPPED="${VERSION//./}"

echo "Downloading and extracting MyBB ${VERSION}\n"
sleep 1
rm -Rf application/*
# Live demo, better skip the internet
#curl --output mybb.zip --progress-bar "https://resources.mybb.com/downloads/mybb_${VERSION_STRIPPED}.zip"
cp ~/mybb.zip .
unzip mybb.zip 'Upload/*' -d "/tmp/mybb${VERSION_STRIPPED}" -qq -o
echo "(moving MyBB from /tmp to application)"
cp -R "/tmp/mybb${VERSION_STRIPPED}/Upload/" application && rm -Rf "/tmp/mybb${VERSION_STRIPPED}"
rm mybb.zip

echo "\nUse 'mybb.sdb' as the path to the SQLite database."
cp database/mybb.sdb application

# https://www.php.net/manual/en/features.commandline.webserver.php
echo "\nStarting PHP development web server"
php -S localhost:9000 -t application
