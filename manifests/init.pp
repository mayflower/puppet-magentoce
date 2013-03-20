# = Class: magece
# 
# This class installs all required packages and services in order to run Magento CE. 
# It'll do a checkout of the Magento CE repository as well. You only have to setup
# Apache and/or NGINX afterwards.
# 
# == Parameters: 
#
# $directory::         The mage repository will be checked out into this directory.
# $repository::        Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                      Valid values: 'svn' and 'git'. 
# $version::           The Magento CE version. Defaults to 'trunk'. 
#                      Valid values: For example 'tags/1.8.3' or 'branch/whatever'. 
# $db_user::           If defined, it creates a MySQL user with this username.
# $db_password::       The MySQL user's password.
# $db_root_password::  A password for the MySQL root user.
# $log_analytics::     Whether log analytics will be used. Defaults to true. 
#                      Valid values: true or false
# $svn_username::      Your svn username. Defaults to false.
# $svn_password::      Your svn password. Defaults to false.
# 
# == Requires: 
# 
# See README
# 
# == Sample Usage:
#
#  class {'magece': }
#
#  class {'magece':
#    db_root_password => '123456',
#    repository => 'git',
#  }
#
class magece(
  $directory   = $magece::params::apachedocroot,
  $repository  = $magece::params::repository,
  $version     = $magece::params::magece_version,
  $db_user     = $magece::params::db_user,
  $db_password = $magece::params::db_password,
  $db_root_password = $magece::params::db_password,
  $log_analytics    = true,
  $svn_username     = false,
  $svn_password     = false
) inherits magece::params {

  include magece::base

  Package {
    require => Exec['apt-get_update'],
  }

  # mysql / db
  class { 'magece::db':
    username      => $db_user,
    password      => $db_password,
    root_password => $db_root_password,
    require       => Class['magece::base'],
  }

  class { 'magece::php':
     require => Class['magece::db'],
  }

  class { 'magece::user': }

  # repo checkout
  magece::repo { 'magece_repo_setup':
    directory    => $directory,
    version      => $version,
    repository   => $repository,
    svn_username => $svn_username,
    svn_password => $svn_password,
    require      => Class['magece::base'],
  }

}

