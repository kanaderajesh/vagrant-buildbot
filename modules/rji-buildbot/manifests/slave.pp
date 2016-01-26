# Class: buildbot::slave
# Manages a Buildbot slave's service and configuration, and exports a resource
# to be collected on a Buildbot master.
#
class buildbot::slave(
  $master,
  $master_port = undef,
  $slave_name  = undef,
  $password    = undef,
  $admin       = undef,
  $description = undef,
  $max_builds  = undef,
) {
  include ::buildbot::params

  $master_port_real = $master_port ? {
    undef   => $::buildbot::params::slave_port,
    default => $master_port,
  }

  $slave_name_real = $slave_name ? {
    undef   => $::fqdn,
    default => $slave_name,
  }

  $password_real = $password ? {
    undef   => $::buildbot::params::slave_password,
    default => $password,
  }

  $admin_real = $admin ? {
    undef   => $::buildbot::params::slave_admin,
    default => $admin,
  }

  $description_real = $description ? {
    undef   => $::buildbot::params::slave_description,
    default => $description,
  }

  $max_builds_real = $max_builds ? {
    undef   => $::buildbot::params::slave_max_builds,
    default => $max_builds,
  }

  package { $::buildbot::params::prereq_pkgs:
    ensure => present,
  }

  package { 'buildbot-slave':
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
    comment    => 'Buildbot slave user',
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

  file { "${::buildbot::params::home}/slave":
    ensure  => directory,
    mode    => '0755',
    require => User[$::buildbot::params::user],
  }

  file { "${::buildbot::params::home}/slave/buildbot.tac":
    ensure  => file,
    mode    => '0600',
    content => template('buildbot/buildbot-slave.tac.erb'),
  }

  file { "${::buildbot::params::home}/slave/info":
    ensure => directory,
    mode   => '0755',
  }

  file { "${::buildbot::params::home}/slave/info/admin":
    ensure  => file,
    content => $admin_real,
  }

  file { "${::buildbot::params::home}/slave/info/host":
    ensure  => file,
    content => $description_real,
  }

  exec { 'buildbot-slave-start':
    command => 'buildslave start slave',
    unless  => 'kill -0 $(cat slave/twistd.pid)',
    require => [
      File["${::buildbot::params::home}/slave/buildbot.tac"],
      File["${::buildbot::params::home}/slave/info/admin"],
      File["${::buildbot::params::home}/slave/info/host"],
      Package['buildbot-slave'],
    ],
  }

  exec { 'buildbot-slave-restart':
    command     => 'buildslave restart slave',
    refreshonly => true,
    subscribe   => [
      File["${::buildbot::params::home}/slave/buildbot.tac"],
      File["${::buildbot::params::home}/slave/info/admin"],
      File["${::buildbot::params::home}/slave/info/host"],
    ],
  }

  # Export our BuildSlave instance to be collected on the master
  @@buildbot::slave::define { "buildbot_${master}_slave_${slave_name_real}":
    buildbot_master => $master,
    slave_name      => $slave_name_real,
    password        => $password_real,
    max_builds      => $max_builds_real,
  }
}
