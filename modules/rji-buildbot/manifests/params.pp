# Class: buildbot::params
# Parameters used throughout the Buildbot module.
#
class buildbot::params {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $version = '0.8.9' # buildbot and buildbot-slave version

  $user  = 'buildbot'
  $group = 'buildbot'
  $home  = '/home/buildbot'
  $shell = '/bin/bash'

  case $::osfamily {
    'Debian': { $prereq_pkgs = [ 'python-dev', 'python-pip' ]   }
    'RedHat': { $prereq_pkgs = [ 'python-devel', 'python-pip' ] }
    default:  { fail("Unsupported OS family '${::osfamily}'")   }
  }

  # Build slave parameters
  $slave_port        = '9989'
  $slave_password    = 'Buildbot-slave-pw'
  $slave_admin       = 'Buildbot Admin <buildbot-admin@example.com>'
  $slave_description = 'Please put a description of the build host here.'
  $slave_max_builds  = $::processorcount * 2
}
