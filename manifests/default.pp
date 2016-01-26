exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

class { '::buildbot::master':
    project     => 'Buildbot Master Web UI',
    project_url => 'http://localhost.com',
    slave_port  => '9989',
}
Exec['apt-update'] -> Class['::buildbot::master']
