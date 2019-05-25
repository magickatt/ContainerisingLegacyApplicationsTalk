<?php

# Database configuration
$config['database']['type'] = '{{ key "mybb/php/database/driver" }}';
$config['database']['database'] = '{{ key "mybb/mysql/schema" }}';
$config['database']['table_prefix'] = '{{ key "mybb/mysql/table_prefix" }}';
$config['database']['encoding'] = '{{ key "mybb/mysql/encoding" }}';

{{ range service "database" }}
$config['database']['hostname'] = '{{ .Address }}:{{ .Port }}';
{{ end }}
{{- with secret "database/creds/mybb" }}
$config['database']['username'] = '{{ .Data.username }}';
$config['database']['password'] = '{{ .Data.password }}';
{{- end }}

# Admin configuration
$config['admin_dir'] = 'admin';
$config['hide_admin_links'] = 0;
$config['super_admins'] = '1';
$config['secret_pin'] = '';

# Data-cache configuration
$config['cache_store'] = '{{ key "mybb/cache/store" }}';
$config['memcache']['host'] = '{{ key "mybb/cache/memcache/host" }}';
$config['memcache']['port'] = {{ key "mybb/cache/memcache/port" }};

# Log configuration
$config['log_pruning'] = array(
	'admin_logs' => 365, // Administrator logs
	'mod_logs' => 365, // Moderator logs
	'task_logs' => 30, // Scheduled task logs
	'mail_logs' => 180, // Mail error logs
	'user_mail_logs' => 180, // User mail logs
	'promotion_logs' => 180 // Promotion logs
);

# Access configuration
$config['disallowed_remote_hosts'] = array(
	'localhost',
);
$config['disallowed_remote_addresses'] = array(
	'127.0.0.1',
	'10.0.0.0/8',
	'172.16.0.0/12',
	'192.168.0.0/16',
);
