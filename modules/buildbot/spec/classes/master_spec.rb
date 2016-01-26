require 'spec_helper'

describe 'buildbot::master', :type => :class do
  let :facts do
    {
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :lsbdistcodename        => 'wheezy',
      :operatingsystemrelease => '7',
      :processorcount         => '2',
      :concat_basedir         => '/tmp',
      :fqdn                   => 'buildmaster.example.com',
      :hostname               => 'buildmaster',
      :ipaddress              => '192.168.254.254',
    }
  end

  context 'when setting up a master with the default slave port' do
    let :params do
      {
        :project     => 'Example Project',
        :project_url => 'http://www.example.com',
      }
    end

    it 'should build a sane master.cfg file' do
      should contain_concat('/home/buildbot/master/master.cfg').with(
        'owner' => 'buildbot',
        'group' => 'buildbot',
      )

      should contain_concat__fragment('buildbot-master-config-10').with(
        'order'   => '10',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => /# This file is managed by Puppet.*/,
      )

      should contain_concat__fragment('buildbot-master-config-20').with(
        'order'   => '20',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => /c\['protocols'\] = {'pb': {'port': 9989 }}/,
      )

      should contain_concat__fragment('buildbot-master-config-60').with(
        'order' => '60',
        'target' => '/home/buildbot/master/master.cfg',
        'content' => /c\['title'\] = "Example Project"\nc\['titleURL'\] = "http:\/\/www\.example\.com"\n/,
      )
    end

    it 'should collect exported resources from buildslaves' do
      should contain_buildbot__master__collect_exported('buildmaster.example.com')
      should contain_buildbot__master__collect_exported('buildmaster')
      should contain_buildbot__master__collect_exported('192.168.254.254')
    end

    it 'should manage the buildbot.tac file' do
      should contain_file('/home/buildbot/master/buildbot.tac').with(
        'content' => /basedir = '\/home\/buildbot\/master'/
      )
    end

    it 'should manage the buildbot user' do
      should contain_user('buildbot').with(
        'managehome' => 'true',
        'home'       => '/home/buildbot',
      )
    end
  end

  context 'when setting up a master with a non-default slave port' do
    let :params do
      {
        :project     => 'Example Project',
        :project_url => 'http://www.example.com',
        :slave_port  => '60000',
      }
    end

    it 'master.cfg should contain the custom port' do
      should contain_concat__fragment('buildbot-master-config-20').with(
        'order'   => '20',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => /c\['protocols'\] = {'pb': {'port': 60000 }}/,
      )
    end
  end
end
