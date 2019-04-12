#!/bin/bash

consul-template \
-template "/var/config/mybb/config.tpl:/var/www/mybb/inc/config.php" \
-template "/var/config/mybb/settings.tpl:/var/www/mybb/inc/settings.php" \
-exec apache2-foreground $@
