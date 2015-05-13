class docker-registry (
  $rgyloglevel = '_env:LOGLEVEL:info',
  $rgydebug = '_env:DEBUG:false',
  $standalone = '_env:STANDALONE:true',
  $index_endpoint = '_env:INDEX_ENDPOINT:https://index.docker.io',
  $storage_redirect = '_env:STORAGE_REDIRECT',
  $disable_token_auth = '_env:DISABLE_TOKEN_AUTH',
  $privileged_key = '_env:PRIVILEGED_KEY',
  $search_backend = 'sqlalchemy',
  $sqlalchemy_index_database = '_env:SQLALCHEMY_INDEX_DATABASE:sqlite:////tmp/docker-registry.db',
  $mirror_source = '_env:MIRROR_SOURCE',
  $mirror_source_index = '_env:MIRROR_SOURCE_INDEX',
  $mirror_tags_cache_ttl = '_env:MIRROR_TAGS_CACHE_TTL:172800',
  $cache_redis_host = '_env:CACHE_REDIS_HOST',
  $cache_redis_port = '_env:CACHE_REDIS_PORT',
  $cache_redis_db = '_env:CACHE_REDIS_DB:0',
  $cache_redis_password = '_env:CACHE_REDIS_PASSWORD',
  $cache_lru_redis_host = '_env:CACHE_LRU_REDIS_HOST',
  $cache_lru_redis_port = '_env:CACHE_LRU_REDIS_PORT',
  $cache_lru_redis_db = '_env:CACHE_LRU_REDIS_DB:0',
  $cache_lru_redis_password = '_env:CACHE_LRU_REDIS_PASSWORD',
  $smtp_host = '_env:SMTP_HOST',
  $smtp_port = '_env:SMTP_PORT:25',
  $smtp_login = '_env:SMTP_LOGIN',
  $smtp_password = '_env:SMTP_PASSWORD',
  $smtp_secure = '_env:SMTP_SECURE:false',
  $smtp_from_addr = '_env:SMTP_FROM_ADDR:docker-registry@localdomain.local',
  $smtp_to_addr = '_env:SMTP_TO_ADDR:noise+dockerregistry@localdomain.local',
  $cors_origins= '_env:CORS_ORIGINS',
  $cors_methods= '_env:CORS_METHODS',
  $cors_headers= '_env:CORS_HEADERS:[Content-Type]',
  $cors_expose_headers= '_env:CORS_EXPOSE_HEADERS',
  $cors_supports_credentials= '_env:CORS_SUPPORTS_CREDENTIALS',
  $cors_max_age= '_env:CORS_MAX_AGE',
  $cors_send_wildcard= '_env:CORS_SEND_WILDCARD',
  $cors_always_send= '_env:CORS_ALWAYS_SEND',
  $cors_automatic_options= '_env:CORS_AUTOMATIC_OPTIONS',
  $cors_vary_header= '_env:CORS_VARY_HEADER',
  $cors_resources= '_env:CORS_RESOURCES',
  $aws_bucket = '_env:AWS_BUCKET',
  $aws_host= '_env:AWS_HOST',
  $aws_port= '_env:AWS_PORT',
  $aws_calling_format= '_env:AWS_CALLING_FORMAT',
  $aws_region = '_env:AWS_REGION',
  $aws_key = '_env:AWS_KEY',
  $aws_secret = '_env:AWS_SECRET',
  $aws_bucket = '_env:AWS_BUCKET',
  $aws_encrypt = '_env:AWS_ENCRYPT:true',
  $aws_secure = '_env:AWS_SECURE:true',
  $aws_use_sigv4 = '_env:AWS_USE_SIGV4',
  $aws_debug = '_env:AWS_DEBUG:0',
  $cf_base_url = '_env:CF_BASE_URL',
  $cf_keyid = '_env:CF_KEYID',
  $cf_keysecret = '_env:CF_KEYSECRET',
  $azure_storage_account_name = '_env:AZURE_STORAGE_ACCOUNT_NAME',
  $azure_storage_account_key = '_env:AZURE_STORAGE_ACCOUNT_KEY',
  $azure_storage_container = '_env:AZURE_STORAGE_CONTAINER:registry',
  $azure_use_https = '_env:AZURE_USE_HTTPS:true',
  $gcs_bucket = '_env:GCS_BUCKET',
  $gcs_key = '_env:GCS_KEY',
  $gcs_secret = '_env:GCS_SECRET',
  $gcs_secure = '_env:GCS_SECURE:true',
  $gcs_oauth2 = '_env:GCS_OAUTH2:false',
  $os_auth_url = '_env:OS_AUTH_URL',
  $os_container = '_env:OS_CONTAINER',
  $os_username = '_env:OS_USERNAME',
  $os_password = '_env:OS_PASSWORD',
  $os_tenant_name = '_env:OS_TENANT_NAME',
  $os_region_name = '_env:OS_REGION_NAME',
  $glance_storage_alternate = '_env:GLANCE_STORAGE_ALTERNATE:file',
  $elliptics_nodes = '_env:ELLIPTICS_NODES',
  $elliptics_wait_timeout = '_env:ELLIPTICS_WAIT_TIMEOUT:60',
  $elliptics_check_timeout = '_env:ELLIPTICS_CHECK_TIMEOUT:60',
  $elliptics_io_thread_num = '_env:ELLIPTICS_IO_THREAD_NUM:2',
  $elliptics_net_thread_num = '_env:ELLIPTICS_NET_THREAD_NUM:2',
  $elliptics_nonblocking_io_thread_num = '_env:ELLIPTICS_NONBLOCKING_IO_THREAD_NUM:2',
  $elliptics_groups = '_env:ELLIPTICS_GROUPS',
  $elliptics_verbosity = '_env:ELLIPTICS_VERBOSITY:4',
  $elliptics_logfile = '_env:ELLIPTICS_LOGFILE:/dev/stderr',
  $elliptics_addr_family = '_env:ELLIPTICS_ADDR_FAMILY:2 ',
  $oss_host = '_env:OSS_HOST',
  $oss_bucket = '_env:OSS_BUCKET',
  $oss_key = '_env:OSS_KEY',
  $oss_secret = '_env:OSS_SECRET',
  $storage_path = '_env:STORAGE_PATH:/var/lib/docker-registry',
  $user = 'root',
  $registry_address = '0.0.0.0',
  $registry_port = '5000',
  $gunicorn_workers = '8',
  $dockerrgyversion = '0.9.1-4.el7',
  $settings_flavour = 'local',
) {
 
  package { 
    'python-redis': ensure => present;
    'python-sqlalchemy': ensure => present;
    'docker-registry': ensure => $dockerrgyversion;
  }

  service {
    'docker-registry': 
      ensure => running,
      enable => true,
      require => [
        File['/etc/docker-registry.yml'], 
        File['/etc/sysconfig/docker-registry'], 
        File['/etc/systemd/system/docker-registry.service'],
        Package['python-redis'],
        Package['python-sqlalchemy'],
      ]
  }

  file { '/etc/docker-registry.yml':
    ensure  => present,
    mode    => '0400',
    owner   => $user,
    content => template('docker-registry/docker-registry.yml.erb')
  }

  file { '/etc/sysconfig/docker-registry':
    ensure  => present,
    mode    => '0444',
    content => template('docker-registry/docker-registry.erb')
  }

  file { '/etc/systemd/system/docker-registry.service':
    ensure  => present,
    mode    => '0440',
    content => template('docker-registry/docker-registry.service.erb')
  }

  file { '/usr/lib/python2.7/site-packages/docker-registry/docker_registry/toolkit.py':
    ensure  => present,
    mode    => '0444',
    source  => 'puppet:///files/hotel/docker/registry/toolkit.py',
    require => Package[docker-registry]
  }
}
