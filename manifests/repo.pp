# = Definition: magece::repo
#
# This definition clones a specific version from a Magento
# repository into the specified directory.
#
# == Parameters: 
#
# $directory::     The magento ce repository will be checked out/cloned into this 
#                  directory.
# $version::       The magento ce version. Defaults to 'trunk'. 
#                  Valid values: For example 'HEAD', 'tags/1.8.3' or 'branch/whatever'.
# $repository::    Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                  Valid values: 'svn' and 'git'.  
# $svn_username::  Your svn username. Defaults to false.
# $svn_password::  Your svn password. Defaults to false.
#
# == Actions:
#
# == Requires: 
#
# == Sample Usage:
#
#  magece::repo { 'magece_repo_simple': }
#
#  magece::repo { 'magece_repo_full':
#    directory    => '/var/www/',
#    version      => 'trunk',
#    repository   => 'svn',
#    svn_username => 'svn username',
#    svn_password => 'svn password'
#  }
#
define magece::repo(
  $directory    = $magece::params::docroot,
  $version      = $magece::params::magece_version,
  $repository   = $magece::params::repository,
  $svn_username = false,
  $svn_password = false
) {

  if ! defined(File[$directory]) {
    file { "${directory}": }
  }

  if $repository == 'svn' {
    vcsrepo { "${directory}":
      ensure   => present,
      provider => svn,
      source   => "${magece::params::svn_repository}/${version}",
      owner    => $magece::params::user,
      group    => $magece::params::group,
      require  => [ User["${magece::params::user}"], Package['subversion'] ],
      basic_auth_username => $svn_username,
      basic_auth_password => $svn_password,
    }
  }

# git currently not supported by Magento
#
#  if $repository == 'git' {
#    vcsrepo { "${directory}":
#      ensure   => present,
#      provider => git,
#      source   => $magece::params::git_repository,
#      revision => $version,
#      owner    => $magece::params::user,
#      group    => $magece::params::group,
#      require  => [ User["${magece::params::user}"], Class['git'] ],
#    }
#  }

  file { "${directory}/config":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

  file { "${directory}/tmp":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

}
