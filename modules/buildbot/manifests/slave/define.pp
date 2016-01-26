# Define: buildbot::slave::define
#
define buildbot::slave::define(
  $buildbot_master,
  $slave_name,
  $password,
  $max_builds,
){
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  concat::fragment { "buildbot_${buildbot_master}_slave_${slave_name}":
    ensure  => present,
    order   => 15,
    target  => "${::buildbot::params::home}/master/master.cfg",
    content => "c['slaves'].append(BuildSlave('${slave_name}', '${password}', max_builds=${max_builds}))\n",
  }
}
