require 'spec_helper'

describe 'buildbot::slave', :type => :class do
  let :facts do
    {
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :lsbdistcodename        => 'wheezy',
      :operatingsystemrelease => '7',
      :processorcount         => '2',
      :concat_basedir         => '/tmp',
      :fqdn                   => 'buildslave1.example.com',
      :hostname               => 'buildslave1',
      :ipaddress              => '172.16.30.30',
    }
  end

  context 'when setting up a slave with only the required params' do
    let :params do
      {
        'master' => 'buildmaster.example.com',
      }
    end

    it 'should build a sane buildbot.tac file' do
      should contain_file('/home/buildbot/slave/buildbot.tac').with(
        'owner'   => 'buildbot',
        'group'   => 'buildbot',
      )
      should contain_file('/home/buildbot/slave/buildbot.tac').with(
        'content' => /basedir\s+?=\s+?'\/home\/buildbot\/slave'/
      )
      should contain_file('/home/buildbot/slave/buildbot.tac').with(
        'content' => /buildmaster_host\s+?=\s+?'buildmaster\.example\.com'/
      )
    end

    it 'should manage the slave admin contact file' do
      should contain_file('/home/buildbot/slave/info/admin').with(
        'content' => /Buildbot Admin/,
      )
    end

    it 'should manage the slave host file' do
      should contain_file('/home/buildbot/slave/info/host').with(
        'content' => /Please put a description of the build host here/
      )
    end

    it 'should manage the buildbot user' do
      should contain_user('buildbot').with(
        'managehome' => 'true',
        'home'       => '/home/buildbot',
      )
    end
  end
end
