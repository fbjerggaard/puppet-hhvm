# == Class: hhvm::service
#
# This class mangaes the hhvm service on multiple ports
define hhvm::service (
  $ensure                 = $hhvm::service_ensure,
  $port                   = $hhvm::port,
  $debugger_port          = $hhvm::debugger_port,
  $admin_server_port      = $hhvm::admin_server_port,
  $source_root            = $hhvm::source_root,
  $jit_enabled            = $hhvm::jit_enabled,
  $jit_warmup_requests    = $hhvm::jit_warmup_requests,
  $date_timezone          = $hhvm::date_timezone,
  $enable_debugger        = $hhvm::enable_debugger,
  $enable_debugger_server = $hhvm::enable_debugger_server,
  $admin_server_password  = $hhvm::admin_server_password,
  $limit                  = $hhvm::limit
) {
  include ::hhvm

  # maintain compatibility with existing nginx setups
  $socket = regsubst("/var/run/hhvm/hhvm_${port}.sock",
            "(_${hhvm::port})",'','G')
  $service =  regsubst("hhvm_${port}",
              "(_${hhvm::port})",'','G')
  $default =  regsubst("/etc/default/hhvm_${port}",
              "(_${hhvm::port})",'','G')
  $init_d = regsubst("/etc/init.d/hhvm_${port}",
            "(_${hhvm::port})",'','G')
  $init = regsubst("/etc/init/hhvm_${port}.conf",
          "(_${hhvm::port})",'','G')
  $server_ini = regsubst("/etc/hhvm/server_${port}.ini",
                "(_${hhvm::port})",'','G')
  $php_ini =  regsubst("/etc/hhvm/php_${port}.ini",
              "(_${hhvm::port})",'','G')
  $config_hdf = regsubst("/etc/hhvm/config_${port}.hdf",
                "(_${hhvm::port})",'','G')
  $jit_repo = regsubst("/tmp/.hhvm_${port}.hhbc",
              "(_${hhvm::port})",'','G')
  $error_log =  regsubst("/var/log/hhvm/error_${port}.log",
                "(_${hhvm::port})",'','G')
  $pid =  regsubst("/var/run/hhvm/hhvm_${port}.pid",
          "(_${hhvm::port})",'','G')
  $admin_server_log = regsubst("/var/log/hhvm/admin_${port}.log",
                      "(_${hhvm::port})",'','G')

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
        ensure    => $service_ensure,
        hasstatus => true,
        enable    => true,
        require   => Exec['Use build-hhvm.sh']
    }
  } else {
    service { $service:
        ensure    => $service_ensure,
        hasstatus => true,
        enable    => true,
        require   => Package[$hhvm::install::package::hhvm_package_name]
    }
  }
}
