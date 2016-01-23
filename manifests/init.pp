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
  $number_of_processor_cores = $hhvm::params::number_of_processor_cores,
  $compile_from_source       = $hhvm::params::compile_from_source,
  $use_nightly               = $hhvm::params::use_nightly,
  $php_ini_cfg_append        = $hhvm::params::php_ini_cfg_append,
  $config_hdf_env_append     = $hhvm::params::hdf_env_append,
  $server_ini_cfg_append     = $hhvm::params::server_ini_cfg_append,
  $config_hdf_dyn_ext_append = $hhvm::params::hdf_dyn_ext_append,

  # service (port) specific
  $port                    = $hhvm::params::port,
  $source_root             = $hhvm::params::source_root,
  $admin_server_port       = $hhvm::params::admin_server_port,
  $debugger_port           = $hhvm::params::debugger_port,
  $service_ensure          = $hhvm::params::service_ensure,
  $jit_enabled             = $hhvm::params::jit_enabled,
  $jit_warmup_requests     = $hhvm::params::jit_warmup_requests,
  $date_timezone           = $hhvm::params::date_timezone,
  $enable_debugger         = $hhvm::params::enable_debugger,
  $admin_server_password   = $hhvm::params::admin_server_password,
  $enable_debugger_server  = $hhvm::params::enable_debugger_server,
  $disable_zend_ini_compat = $hhvm::params::disable_zend_ini_compat,
  $limit                   = $hhvm::params::limit,
) inherits hhvm::params {
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
  hhvm::service { "hhvm_${port}":
    service_ensure         => $service_ensure,
    port                   => $port,
    debugger_port          => $debugger_port,
    admin_server_port      => $admin_server_port,
    source_root            => $source_root,
    jit_enabled            => $jit_enabled,
    jit_warmup_requests    => $jit_warmup_requests,
    date_timezone          => $date_timezone,
    enable_debugger        => $enable_debugger,
    enable_debugger_server => $enable_debugger_server,
    admin_server_password  => $admin_server_password,
    limit                  => $limit
  }

  anchor { 'hhvm::begin': }
  anchor { 'hhvm::end': }

  Anchor['hhvm::begin'] ->
  Class['hhvm::config'] ->
  Class['hhvm::install::package'] ->
  Class['hhvm::install::build'] ->
  Anchor['hhvm::end']
}
