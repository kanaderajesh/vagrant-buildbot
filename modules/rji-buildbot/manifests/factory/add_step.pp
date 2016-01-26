# Define: buildbot::factory::add_step
#
define buildbot::factory::add_step (
  $factory,
  $step,
  $ensure = 'present',
){

  include ::buildbot::params

  concat::fragment { "buildbot_factory_${factory}_step_${name}":
    ensure  => $ensure,
    order   => 45,
    target  => "${::buildbot::params::home}/master/master.cfg",
    content => "${factory}.addStep(${step})\n",
  }
}
