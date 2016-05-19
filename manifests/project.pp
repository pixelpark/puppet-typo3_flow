# Define: typo3_flow::project
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#   TYPO3 Flow version for project.
#   Example: '3.2.2'
#
# [*site_path*]
#   Path to project root.
#   Example:  '/var/www/my-project'
#
# [*site_user*]
#   Project files owner.
#   Default: 'apache'
#
# [*site_group*]
#   Project files group.
#   Default: 'apache'
#
# [*site_mode*]
#   Project files mode.
#   Default: '0660'
#
# [*context*]
#   Set the initial context for the database.
#   Default: 'Production'
#
# [*db_pass*]
#   Set the password for the database.
#   Default: '' (empty)
#
# [*db_user*]
#   Set the user for the database.
#   Default: '' (empty)
#
# [*db_host*]
#   Set the the database host.
#   Default: '' (empty)
#
# [*db_name*]
#   Set the database name.
#   Default: '' (empty)
#
# [*extensions*]
#   Set some extensions and parameters for pre-install.
#   Default: (empty array)
#
#
# == Author
# Philipp Dallig
#
define typo3_flow::project (
  $version,
  $site_path,
  $site_user  = 'apache',
  $site_group = 'apache',
  $site_mode  = '0660',
  $db_pass    = '',
  $db_user    = '',
  $db_host    = '',
  $db_name    = '',
  $extensions = [],) {

  # place project directory because docroot is in Subfolder
  file { $site_path:
    ensure => directory,
    owner  => $site_user,
    group  => $site_group,
    mode   => $site_mode
  }

  # used variables:
  # - $version
  # - $extensions
  file { "${site_path}/composer.json":
    ensure  => file,
    owner   => $site_user,
    group   => $site_group,
    mode    => $site_mode,
    content => template('typo3_flow/composer.json.erb'),
    notify  => Exec["${title}_composer_update"],
  }

  $settings = "${site_path}/Configuration/Settings.yaml"
  exec { "${title}_composer_update":
    command     => 'composer update',
    user        => $site_user,
    cwd         => $site_path,
    path        => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
    environment => "COMPOSER_HOME=${site_path}",
    refreshonly => true,
    before      => File[$settings],
  }

  # used variables:
  # - $db_pass
  # - $db_user
  # - $db_host
  # - $db_name
  file { $settings:
    ensure  => file,
    owner   => $site_user,
    group   => $site_group,
    mode    => $site_mode,
    content => template('typo3_flow/settings.yaml.erb'),
  }

  # TODO: Maybe ./flow doctrine:migrate
  # TODO: Maybe ./flow flow:core:setfilepermissions
}
