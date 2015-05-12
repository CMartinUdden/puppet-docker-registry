class docker-registry (
  $secret_key = '_env:SECRET_KEY',
  $boto_bucket = 'REPLACEME',
  $s3_access_key = 'REPLACEME',
  $s3_secret_key = 'REPLACEME',
  $s3_bucket = 'REPLACEME',
  $s3_encrypt = 'REPLACEME',
  $s3_secure = 'REPLACEME',
  $gs_access_key = 'REPLACEME',
  $gs_secret_key = 'REPLACEME',
  $gs_secure = 'REPLACEME',
  $oauth2 = 'REPLACEME',
  $search_backend = 'sqlalchemy',
  $sqlalchemy_index_database = 'sqlite:////var/lib/docker-registry/docker-registry.db',
  $loglevel = 'debug',
  $user = 'root',
  $registry_address = '0.0.0.0',
  $registry_port = '5000',
  $gunicorn_workers = '8',
  $dockerrgyversion = '0.6.8-8.el7',
  $settings_flavour = 'local',
  $local_storage = 'local',
  $local_storage_path = '/var/lib/docker-registry',
  $dev_storage = 'local',
  $dev_storage_path = '/tmp/registry',
  $prod_storage = 's3',
  $prod_storage_path = '_env:STORAGE_PATH:/prod',
  $prod_cache_host = 'redis',
  $prod_cache_port = '6379',
  $prod_cache_password = 'REPLACEME',
  $prod_cache_lru_host = 'redislru',
  $prod_cache_lru_port = '6380',
  $prod_cache_lru_password = 'REPLACEME',
  $smtp_host = 'REPLACEME',
  $smtp_port = '25',
  $smtp_login = 'REPLACEME',
  $smtp_password = 'REPLACEME',
  $smtp_secure = 'false',
  $from_addr = 'docker-registry@localdomain.local',
  $to_addr = 'noise+dockerregistry@localdomain.local',
  $test_storage = 'local',
  $test_storage_path = '/tmp/registry',
  $swift_storage_path = '/registry',
  $swift_authurl = '_env:OS_AUTH_URL',
  $swift_container = '_env:OS_CONTAINER',
  $swift_user = '_env:OS_USERNAME',
  $swift_password = '_env:OS_PASSWORD',
  $swift_tenant_name = '_env:OS_TENANT_NAME',
  $swift_region_name = '_env:OS_REGION_NAME',
  $storage_alternate = 'local',
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
}
