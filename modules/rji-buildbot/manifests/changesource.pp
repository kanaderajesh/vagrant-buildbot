# Define: buildbot::changesource
#
define buildbot::changesource (
  $branch        = 'master',
  $ensure        = 'present',
  $poll_interval = '300',
  $type          = 'GitPoller',
  $url           = $name,
  $work_dir      = 'gitpoller-workdir',
){

  include ::buildbot::params

  concat::fragment { "buildbot_changesource_${name}":
    ensure  => $ensure,
    order   => 25,
    target  => "${::buildbot::params::home}/master/master.cfg",
    content => "c['change_source'].append(${type}('${url}', workdir='${work_dir}', branch='${branch}', pollinterval=${poll_interval}))\n",
  }
}
