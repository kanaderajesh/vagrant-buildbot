require 'spec_helper'

describe 'buildbot::changesource', :type => :define do

  let :facts do
    {
      :osfamily       => 'Debian',
      :processorcount => '2',
      :concat_basedir => '/tmp',
    }
  end

  let :title do
    'git://git.example.com/testprojectgitrepo.git'
  end

  it 'should create a changesource with default params' do
    should contain_concat__fragment('buildbot_changesource_git://git.example.com/testprojectgitrepo.git').with(
      'order'   => '25',
      'target'  => '/home/buildbot/master/master.cfg',
      'content' => "c['change_source'].append(GitPoller('git://git.example.com/testprojectgitrepo.git', workdir='gitpoller-workdir', branch='master', pollinterval=300))\n",
    )
  end
end
