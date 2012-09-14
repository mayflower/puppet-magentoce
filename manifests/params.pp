# = Class: magece::params
# 
# This class manages Magento CE parameters
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
# This class file is not called directly
#
class magece::params {
  $user    = 'www-data'
  $group   = 'www-data'
  $docroot = '/var/www/magece'
  $apachedocroot = '/var/www/magece'

  $repository     = 'svn'
  $svn_repository = 'http://svn.magentocommerce.com/source/branches/'
  $mage_version  = '1.7'

  $db_user     = 'magece'
  $db_password = 'magece'
}
