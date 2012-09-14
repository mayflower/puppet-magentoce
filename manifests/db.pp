# = Class: magece::db
# 
# This class installs several database packages which are required by Magento CE.
# It installs a MySQL server, starts the MySQL service and installs some 
# useful tools like Percona Toolkit and MySQLTuner.
# 
# == Parameters: 
# 
# $root_password::  A password for the MySQL root user
# $username::       If defined, a MySQL user with this name will be created 
# $password::       The MySQL user's password
# 
# == Requires: 
# 
# == Sample Usage:
#
#  include magece::db
#
#  class {'magece::db':
#    root_password => '123456',
#    username => 'magece',
#    password => 'magece',
#  }
#
class magece::db(
  $username      = $magece::params::db_user,
  $password      = $magece::params::db_password,
  $root_password = $magece::params::db_password
) {

  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => $root_password }
  }

  database { 'magento':
    ensure   => present,
    charset  => 'utf-8',
    provider => 'mysql',
    require  => Class['mysql::server'],
  }

  database_user { $username:
    ensure        => present,
    password_hash => mysql_password($password),
    provider      => 'mysql',
    require       => Class['mysql::server'],
  }

  database_grant { $username:
    privileges => ['all'],
    provider   => 'mysql',
    require    => Database_user[$username],
  }

  include mysql::server::mysqltuner

  package { "percona-toolkit": ensure => installed }

}
