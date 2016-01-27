exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

class { '::buildbot::master':
    project     => 'Buildbot Master Web UI',
    project_url => 'http://localhost.com',
    slave_port  => '9989',
}

class { '::buildbot::slave':
    master      => '127.0.0.1',
    master_port => '9989',
    slave_name  => 'example-slave1',
    password    => 'pass',
    admin       => 'Admin <admin@example.com>',
    description => 'Python build slave.',
    max_builds  => '4',
}
Exec['apt-update'] -> Class['::buildbot::master'] -> Class['::buildbot::slave']
