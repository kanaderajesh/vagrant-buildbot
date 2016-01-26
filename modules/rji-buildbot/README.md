# rji-buildbot [![Build Status](https://travis-ci.org/rji/puppet-buildbot.svg?branch=master)](https://travis-ci.org/rji/puppet-buildbot)
A Puppet module to manage a [Buildbot][1] CI installation.

  * Project page: <https://github.com/rji/puppet-buildbot>
  * Puppet Forge: <https://forge.puppetlabs.com/rji/buildbot>

## Overview
This module is an experiment to manage buildmasters, buildslaves, and
configurations for a Buildbot CI system. Since Buildbot is a powerful and
complex framework, I'm not yet sure that it's worthwhile managing all aspects
of the configuration in a Puppet-like way. This module should at least get the
[PyFlakes sample config][5] up and running.

Currently, this module supports installing `buildbot` and `buildbot-slave` via
pip, manages/builds configuration files, and manages the service with
Buildbot's own methods (via the `buildbot` and `buildbot-slave` executables).

## Compatibility
This module was developed to work with Debian 7 "Wheezy" and RHEL/CentOS 6.
It may work (with a little tweaking) on other Debian and EL-based distros,
provided the system-wide Python is version 2.6 or 2.7.

If this module should prove useful, I intend to add support for pyenv and
virtualenv to make this a bit more portable.

## Known Issues
Authentication and authorization support isn't yet complete. In the meantime,
you can login to the web interface with the following credentials:
  * Username: `test`
  * Password: `test`

## Usage
### Prerequisites
In order to install `python-pip` on CentOS / EL-based distros, you'll need to
have the EPEL repos configured. I recommend the [stahnma/epel][2] module.

If you're not already managing your Apt configuration with Puppet, I recommend
using the [puppetlabs/apt][3] module to ensure `apt-get update` runs prior
to this module installing the `python-pip` package.

### Masters
#### Parameters
  * `project` (required): the name of the project this Buildbot install is
  supporting.
  * `project_url` (required): the project's URL.
  * `slave_port` (optional): the port on the master that slaves will connect
  to. Defaults to '9989'.

```puppet
    class { '::buildbot::master':
        project     => 'Example',
        project_url => 'http://www.example.com',
        slave_port  => '9989',
    }
```

### Slaves
Each slave will export a resource with its `name`, `password`, and `max_builds`.
Those resources will then be collected on the Buildbot master and be used to
populate the config file.

#### Parameters
  * `master` (required): the hostname or IP of the master this slave will
  connect to.
  * `master_port` (optional): the port on the master for the slave to connect
  to. Defaults to '9989'.
  * `slave_name` (optional): the name to use for this slave. Defaults to the
  FQDN returned by Facter.
  * `password` (optional): the password to connect the slave to the
  master. This will default to 'Buildbot-slave-pw'.
  * `admin` (optional): name and e-mail address of the sysadmin responsible
  for the build slave.
  * `description` (optional): a description of the build slave.
  * `max_builds` (optional): the maximum number of builds to execute on the
  given build slave. Defaults to `$::processorcount * 2`.

```puppet
    class { '::buildbot::slave':
        master      => 'buildbot.example.com',
        master_port => '9989',
        slave_name  => 'example-slave',
        password    => 'top-secret-pass',
        admin       => 'Admin <admin@example.com>',
        description => 'Python build slave.',
        max_builds  => '4',
    }
```

### Configuration (master.cfg)
If you're new to Buildbot, please [read the docs][4] first. Otherwise, the best
way to explain how to use this code is using the same PyFlakes example that
comes in `master.cfg.sample`.

```puppet
    buildbot::builder { 'runtests':
      ensure      => present,                 # optional
      slave_names => ['example-slave'],
      factory     => 'factory',
    }

    buildbot::changesource { 'PyFlakes Git repo':
      ensure        => present,               # optional
      branch        => 'master',              # optional, defaults to 'master'
      poll_interval => '300',                 # optional, defaults to '300'
      type          => 'GitPoller',           # optional, defaults to 'GitPoller'
      url           => 'git://github.com/buildbot/pyflakes.git',
      work_dir      => 'gitpoller-workdir',   # optional, defaults to 'gitpoller-workdir'
    }

    buildbot::factory { 'factory':
      ensure => present,                      # optional
    }

    buildbot::factory::add_step { 'factory-10':
      ensure  => present,                     # optional
      factory => 'factory',
      step    => "Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')",
    }

    buildbot::factory::add_step { 'factory-20':
      ensure  => present,                     # optional
      factory => 'factory',
      step    => 'ShellCommand(command=["trial", "pyflakes"])',
    }

    buildbot::scheduler { 'pyflakes-all':
      ensure            => present,           # optional
      type              => 'SingleBranchScheduler',
      change_filter     => "branch='master'",
      tree_stable_timer => 'None',            # optional
      builder_names     => [ 'runtests' ],
    }

    buildbot::scheduler { 'pyflakes-force':
      ensure        => present,               # optional
      type          => 'ForceScheduler',
      builder_names => [ 'runtests' ],
    }
```

<!-- reference links -->
[1]: http://buildbot.net
[2]: https://forge.puppetlabs.com/stahnma/epel
[3]: https://forge.puppetlabs.com/puppetlabs/apt
[4]: http://docs.buildbot.net/current/tutorial/
[5]: https://github.com/buildbot/buildbot/blob/buildbot-0.8.9/master/buildbot/scripts/sample.cfg
