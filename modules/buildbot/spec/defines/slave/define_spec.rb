require 'spec_helper'

describe 'buildbot::slave::define', :type => :define do

  let :facts do
    {
      :caller_module_name => 'buildbot',
      :concat_basedir     => '/tmp',
    }
  end

  let :title do
    'buildbot_buildmaster.example.com_slave_buildslave1.example.com'
  end

  let :params do
    {
      'buildbot_master' => 'buildmaster.example.com',
      'slave_name'      => 'buildslave1.example.com',
      'password'        => 'Buildbot-slave-pw',
      'max_builds'      => '4',
    }
  end

  it 'should contain an exported BuildSlave instance' do
    should contain_concat__fragment('buildbot_buildmaster.example.com_slave_buildslave1.example.com')
  end
end
