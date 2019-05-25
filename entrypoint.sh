#!/bin/bash

# https://httpd.apache.org/docs/2.4/stopping.html#graceful
# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
consul-template \
-template "/var/config/mybb/config.tpl:/var/www/mybb/inc/config.php" \
-reload-signal=SIGUSR1 \
-kill-signal=SIGWINCH \
-exec apache2-foreground $@

#-template "/var/config/mybb/apache2.tpl:/etc/apache2/apache2.conf" \
