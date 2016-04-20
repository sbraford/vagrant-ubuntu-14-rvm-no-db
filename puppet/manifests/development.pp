# development.pp

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }

  package {
    ["libgmp3-dev", "git-all"]: 
      ensure => installed, require => Exec['apt-update']
  }
}

include requirements

class { '::rvm': }

rvm::system_user { vagrant: ; }

# ensure rvm doesn't timeout finding binary rubies
# the umask line is the default content when installing rvm if file does not exist
file { '/home/vagrant/rvmrc':
  content => 'umask u=rwx,g=rwx,o=rx
              export rvm_max_time_flag=60',
  mode    => '0664',
  before  => Class['rvm'],
}

rvm_system_ruby {
  'ruby-2.2.2':
    ensure      => 'present',
    default_use => true,
    build_opts  => ['--binary'];
}