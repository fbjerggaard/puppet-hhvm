# == Class: hhvm::service
#
# This class mangaes the hhvm service on multiple ports
define hhvm::service (
  $ensure                 = $hhvm::params::service_ensure,
  $debugger_port          = $hhvm::params::debugger_port,
  $admin_server_port      = $hhvm::params::admin_server_port,
  $source_root            = $hhvm::params::source_root,
  $jit_enabled            = $hhvm::params::jit_enabled,
  $jit_warmup_requests    = $hhvm::params::jit_warmup_requests,
  $date_timezone          = $hhvm::params::date_timezone,
  $enable_debugger        = $hhvm::params::enable_debugger,
  $enable_debugger_server = $hhvm::params::enable_debugger_server,
  $admin_server_password  = $hhvm::params::admin_server_password,
  $limit                  = $hhvm::params::limit
) {
  include ::hhvm

  $port = $title

  # maintain compatibility with existing nginx setups
  $socket = regsubst("/var/run/hhvm/hhvm_${port}.sock",
            "(_${hhvm::params::port})",'','G')
  $service =  regsubst("hhvm_${port}",
              "(_${hhvm::params::port})",'','G')
  $default =  regsubst("/etc/default/hhvm_${port}",
              "(_${hhvm::params::port})",'','G')
  $init_d = regsubst("/etc/init.d/hhvm_${port}",
            "(_${hhvm::params::port})",'','G')
  $init = regsubst("/etc/init/hhvm_${port}.conf",
          "(_${hhvm::params::port})",'','G')
  $server_ini = regsubst("/etc/hhvm/server_${port}.ini",
                "(_${hhvm::params::port})",'','G')
  $php_ini =  regsubst("/etc/hhvm/php_${port}.ini",
              "(_${hhvm::params::port})",'','G')
  $config_hdf = regsubst("/etc/hhvm/config_${port}.hdf",
                "(_${hhvm::params::port})",'','G')
  $jit_repo = regsubst("/tmp/.hhvm_${port}.hhbc",
              "(_${hhvm::params::port})",'','G')
  $error_log =  regsubst("/var/log/hhvm/error_${port}.log",
                "(_${hhvm::params::port})",'','G')
  $pid =  regsubst("/var/run/hhvm/hhvm_${port}.pid",
          "(_${hhvm::params::port})",'','G')
  $admin_server_log = regsubst("/var/log/hhvm/admin_${port}.log",
                      "(_${hhvm::params::port})",'','G')

  file { $default:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/default/hhvm.erb"),
  }

  file { $init_d:
    ensure  => 'file',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/init.d/hhvm.erb"),
  }

  file { $init:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/init/hhvm.conf.erb")
  }

  file { $server_ini:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/hhvm/server.ini.erb"),
  }

  file { $php_ini:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/hhvm/php.ini.erb"),
  }

  file { $config_hdf:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/hhvm/config.hdf.erb"),
  }

  if ($hhvm::compile_from_source) {
    service { $service:
        ensure    => $::service_ensure,
        hasstatus => true,
        enable    => true,
        require   => Exec['Use build-hhvm.sh']
    }
  } else {
    service { $service:
        ensure    => $::service_ensure,
        hasstatus => true,
        enable    => true,
        require   => Package[$hhvm::install::package::hhvm_package_name]
    }
  }
}
