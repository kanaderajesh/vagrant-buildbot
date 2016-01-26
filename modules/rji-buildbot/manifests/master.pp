# Class: buildbot::master
# Manages the service and configuration on a Buildbot master.
#
class buildbot::master(
  $project,
  $project_url,
  $slave_port = undef,
){
  include ::buildbot::params
  include ::concat::setup

  $slave_port_real = $slave_port ? {
    undef   => $::buildbot::params::slave_port,
    default => $slave_port,
  }

  package { $::buildbot::params::prereq_pkgs:
    ensure => present,
  }

  package { 'buildbot':
    ensure   => $::buildbot::params::version,
    provider => 'pip',
    require  => Package[$::buildbot::params::prereq_pkgs],
  }

  user { $::buildbot::params::user:
    ensure     => present,
    home       => $::buildbot::params::home,
    gid        => $::buildbot::params::group,
    managehome => true,
    membership => 'minimum',
    shell      => $::buildbot::params::shell,
    system     => true,
    comment    => 'Buildbot user',
  }

  group { $::buildbot::params::group:
    ensure => present,
  }

  # File and exec resource defaults for this class
  File {
    owner => $::buildbot::params::user,
    group => $::buildbot::params::group,
  }

  Exec {
    user => $::buildbot::params::user,
    cwd  => $::buildbot::params::home,
    path => '/usr/local/bin:/usr/bin:/bin',
  }

  exec { 'buildbot-create-master':
    command => 'buildbot create-master master',
    creates => "${::buildbot::params::home}/master",
    require => [ Package['buildbot'], User[$::buildbot::params::user] ],
  }

  file { "${::buildbot::params::home}/master/buildbot.tac":
    ensure  => file,
    mode    => '0644',
    content => template('buildbot/buildbot-master.tac.erb'),
  }

  $master_config = "${::buildbot::params::home}/master/master.cfg"

  concat { $master_config:
    owner   => $::buildbot::params::user,
    group   => $::buildbot::params::group,
    mode    => '0644',
    notify  => Exec['buildbot-master-reload'],
    require => Exec['buildbot-create-master'],
  }

  concat::fragment { 'buildbot-master-config-10':
    target  => $master_config,
    content => template('buildbot/master-10.cfg.erb'),
    order   => 10,
  }

  # Collect resources based on the master's FQDN, hostname, and IP address
  buildbot::master::collect_exported { $::fqdn: }
  buildbot::master::collect_exported { $::hostname: }
  buildbot::master::collect_exported { $::ipaddress: }

  concat::fragment { 'buildbot-master-config-20':
    target  => $master_config,
    content => template('buildbot/master-20.cfg.erb'),
    order   => 20,
  }

  concat::fragment { 'buildbot-master-config-30':
    target  => $master_config,
    content => template('buildbot/master-30.cfg.erb'),
    order   => 30,
  }

  concat::fragment { 'buildbot-master-config-40':
    target  => $master_config,
    content => template('buildbot/master-40.cfg.erb'),
    order   => 40,
  }

  concat::fragment { 'buildbot-master-config-50':
    target  => $master_config,
    content => template('buildbot/master-50.cfg.erb'),
    order   => 50,
  }

  concat::fragment { 'buildbot-master-config-60':
    target  => $master_config,
    content => template('buildbot/master-60.cfg.erb'),
    order   => 60,
  }

  exec { 'buildbot-master-start':
    command => 'buildbot start master',
    unless  => 'kill -0 $(cat master/twistd.pid)',
    require => [
      Concat[$master_config],
      File["${::buildbot::params::home}/master/buildbot.tac"],
    ]
  }

  exec { 'buildbot-master-reload':
    command     => 'buildbot reconfig master',
    refreshonly => true,
    subscribe   => [
      Concat[$master_config],
      File["${::buildbot::params::home}/master/buildbot.tac"],
    ],
  }
}
