#
define buildbot::master::collect_exported {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Buildbot::Slave::Define <<| buildbot_master == $name |>>
}
