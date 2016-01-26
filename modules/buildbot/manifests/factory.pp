# Define: buildbot::factory
#
define buildbot::factory (
  $ensure = 'present',
){

  include ::buildbot::params

  concat::fragment { "buildbot_factory_${name}":
    ensure  => $ensure,
    order   => 41,
    target  => "${::buildbot::params::home}/master/master.cfg",
    content => "${name} = BuildFactory()\n",
  }
}
