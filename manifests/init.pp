#
# This module manages hhvm.
#
# Sample Usage:
#
# node default {
#   include hhvm
# }
#
class hhvm(
  $number_of_processor_cores = $::physicalprocessorcount,
  $compile_from_source = false,
  $use_nightly = false,

  $php_ini_cfg_append             = {},
  $server_ini_cfg_append          = {},

  $config_hdf_env_append          = {},
  $config_hdf_dyn_ext_append      = {},

  # service (port) specific
  $port = undef,
  $source_root = undef,
  $admin_server_port = undef,
  $debugger_port = undef,
  $ensure = 'running',

  $jit_enabled = undef,
  $jit_warmup_requests = undef,

  $date_timezone = undef,

  $enable_debugger = undef,
  $enable_debugger_server = undef,
  $admin_server_password = undef,

  $disable_zend_ini_compat = $hhvm::params::disable_zend_ini_compat,
  $limit = undef
) inherits hhvm::params {

  $port_final = $port ? {
    undef => $hhvm::params::port,
    default => $port
  }

  $source_root_final = $source_root ? {
    undef => $hhvm::params::source_root,
    default => $source_root
  }

  $admin_server_port_final = $admin_server_port ? {
    undef => $hhvm::params::admin_server_port,
    default => $admin_server_port
  }

  $debugger_port_final = $debugger_port ? {
    undef => $hhvm::params::debugger_port,
    default => $debugger_port
  }

  $jit_enabled_final = $jit_enabled ? {
    undef => $hhvm::params::jit_enabled,
    default => $jit_enabled
  }

  $jit_warmup_requests_final = $jit_warmup_requests ? {
    undef => $hhvm::params::jit_warmup_requests,
    default => $jit_warmup_requests
  }

  $date_timezone_final = $date_timezone ? {
    undef => $hhvm::params::date_timezone,
    default => $date_timezone
  }

  $enable_debugger_final = $enable_debugger ? {
    undef => $hhvm::params::enable_debugger,
    default => $enable_debugger
  }

  $enable_debugger_server_final = $enable_debugger_server ? {
    undef => $hhvm::params::enable_debugger_server,
    default => $enable_debugger_server
  }

  $admin_server_password_final = $admin_server_password ? {
    undef => $hhvm::params::admin_server_password,
    default => $admin_server_password
  }

  $limit_final = $limit ? {
    undef => $hhvm::params::limit,
    default => $limit
  }

  if($compile_from_source) {
    $path_to_hhvm = '/usr/local/bin/hhvm'
  } else {
    $path_to_hhvm = '/usr/bin/hhvm'
  }

  #if ($php_ini_cfg_append != undef) {
  #  validate_hash($php_ini_cfg_append)
  #}

  #if ($config_hdf_env_append != undef) {
  #  validate_hash($config_hdf_env_append)
  #}

  #if ($config_hdf_dyn_ext_append != undef) {
  #  validate_hash($config_hdf_dyn_ext_append)
  #}

  class { 'hhvm::config': }
  class { 'hhvm::install::package': }
  class { 'hhvm::install::build': }

  # create default server, port 9000
  hhvm::service { "${port_final}":
    ensure                 => $ensure,
    debugger_port          => $debugger_port_final,
    admin_server_port      => $admin_server_port_final,
    source_root            => $source_root_final,
    jit_enabled            => $jit_enabled_final,
    jit_warmup_requests    => $jit_warmup_requests_final,
    date_timezone          => $date_timezone_final,
    enable_debugger        => $enable_debugger_final,
    enable_debugger_server => $enable_debugger_server_final,
    admin_server_password  => $admin_server_password_final,
    limit                  => $limit_final
  }

  anchor { 'hhvm::begin': }
  anchor { 'hhvm::end': }

  Anchor['hhvm::begin'] ->
  Class['hhvm::config'] ->
  Class['hhvm::install::package'] ->
  Class['hhvm::install::build'] ->
  Anchor['hhvm::end']
}
