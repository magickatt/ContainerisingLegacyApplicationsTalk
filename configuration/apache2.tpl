# This is the main Apache server configuration file

#ServerRoot "/etc/apache2"
#Mutex file:${APACHE_LOCK_DIR} default
User ${APACHE_RUN_USER}
Group ${APACHE_RUN_GROUP}
DefaultRuntimeDir ${APACHE_RUN_DIR}
PidFile ${APACHE_PID_FILE}
AccessFileName .htaccess

# Networking
Timeout 300
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
HostnameLookups Off

# Logging
ErrorLog ${APACHE_LOG_DIR}/error.log
LogLevel warn
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %O" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent

# Includes
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf
IncludeOptional conf-enabled/*.conf
IncludeOptional sites-enabled/*.conf
Include ports.conf

# Sets the default security model of the Apache2 HTTPD server
<Directory />
	Options FollowSymLinks
	AllowOverride None
	Require all denied
</Directory>

<Directory /usr/share>
	AllowOverride None
	Require all granted
</Directory>

<Directory /var/www/>
	Options Indexes FollowSymLinks
	AllowOverride None
	Require all granted
</Directory>

<FilesMatch "^\.ht">
	Require all denied
</FilesMatch>
