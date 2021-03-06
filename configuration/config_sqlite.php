<?php

# Database configuration
$config['database']['type'] = 'sqlite';
$config['database']['database'] = 'mybb.sdb';
$config['database']['table_prefix'] = 'mybb_';

$config['database']['hostname'] = 'database';
$config['database']['username'] = 'mybb';
$config['database']['password'] = 'mybb';

# Admin configuration
$config['admin_dir'] = 'admin';
$config['hide_admin_links'] = 0;
$config['super_admins'] = '1';
$config['secret_pin'] = '';

# Data-cache configuration
$config['cache_store'] = 'db';
$config['memcache']['host'] = 'localhost';
$config['memcache']['port'] = 11211;

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
