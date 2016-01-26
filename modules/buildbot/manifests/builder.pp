# Define: buildbot::builder
#
define buildbot::builder (
  $slave_names,
  $factory,
  $ensure = 'present',
){

  include ::buildbot::params

  validate_array($slave_names)
  $slave_names_literal = inline_template('<%= @slave_names.inspect %>')

  concat::fragment { "buildbot_builder_${name}":
    ensure  => $ensure,
    order   => 55,
    target  => "${::buildbot::params::home}/master/master.cfg",
    content => "c['builders'].append(BuilderConfig(name='${name}', slavenames=${slave_names_literal}, factory=${factory}))\n",
  }
}
