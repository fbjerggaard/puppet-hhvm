puppet-hhvm
===========

This module installs HHVM (the Facebook HipHop Virtual Machine) on your web server.

The default settings are to listen on a socket at: /var/run/hhvm/hhvm.sock. You can use this via FastCGI in nginx or Apache to connect to it.

Usage:
======

The module by default will install HipHop VM from a package and start the service on port 9000 as well as create a socket.

class { "hhvm": }

To launch multiple hhvm instances on seperate ports and sockets:

hhvm::service { "9001": }

hhvm::service { "9002": }

To use a nightly instead:

class { "hhvm":
	use_nightly => true
}

To compile from source instead:

class { "hhvm":
	compile_from_source => true,
}

Puppet will most likely time out but the compilation will continue in the background.

Additional options are supported, take a look at init.pp:

class { "hhvm":
	number_of_processor_cores => 2, # Use how many cores for compilation, default is all
	date_timezone => "Europe/London", # Change your timezone (see PHP setting)
	jit_warmup_requests => 5 # Reduce the number of jit warm up requests
}

Connecting to HHVM:
===================

In your nginx configuration, set:

fastcgi_pass   unix:/var/run/hhvm/hhvm.sock;

Or if you are running multiple HHVM:

fastcgi_pass   unix:/var/run/hhvm/hhvm_9001.sock;

fastcgi_pass   unix:/var/run/hhvm/hhvm_9002.sock;

etc.

Restarting HHVM
===============

sudo service hhvm restart or sudo /etc/init.d/hhvm restart

Supported Operating Systems:
============================

Ubuntu 14.04

Additional puppet modules
=========================

vcsrepo if building from source
https://github.com/puppetlabs/puppetlabs-vcsrepo

puppet-apt if using package
https://github.com/puppetlabs/puppetlabs-apt

Forge URL
=========

https://forge.puppetlabs.com/luckyknight/hhvm

Contributing
============

Feel free to submit a PR for further options or more operating system support!
