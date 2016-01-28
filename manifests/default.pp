class { '::buildbot::master':
    project     => 'Buildbot Master Web UI',
    project_url => 'http://localhost.com',
    slave_port  => '9989',
}

class { '::buildbot::slave':
    master      => 'localhost',
    master_port => '9989',
    slave_name  => 'example-slave1',
    password    => 'pass',
    admin       => 'Admin <admin@example.com>',
    description => 'Python build slave.',
    max_builds  => '4',
}
Class['::buildbot::master'] -> Class['::buildbot::slave']
