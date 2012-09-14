# = Class: magece::user
# 
# Makes sure the user exists which is used by Apache and NGINX.
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
#  include magece::user
#
class magece::user {
    
  # user for apache / nginx
  user { "${magece::params::user}":
    ensure  => present,
    comment => $magece::params::user,
    shell   => '/bin/false',
  }

}
