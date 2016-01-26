require 'spec_helper'

describe 'buildbot::factory::add_step', :type => :define do

  let :facts do
    {
      :osfamily       => 'Debian',
      :processorcount => '2',
      :concat_basedir => '/tmp',
    }
  end

  context 'add a git clone step' do
    let :title do
      'factory-10'
    end

    let :params do
      {
        'factory' => 'factory',
        'step'    => "Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')",
      }
    end

    it 'should contain step "factory-10" with Git repo' do
      should contain_concat__fragment('buildbot_factory_factory_step_factory-10').with(
        'order'   => '45',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => "factory.addStep(Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental'))\n",
      )
    end
  end

  context 'add a shell command step' do
    let :title do
      'factory-20'
    end

    let :params do
      {
        'factory' => 'factory',
        'step'    => 'ShellCommand(command=["echo", "Hello, world!"])',
      }
    end

    it 'should contain step "factory-20" with shell command' do
      should contain_concat__fragment('buildbot_factory_factory_step_factory-20').with(
        'order'   => '45',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => "factory.addStep(ShellCommand(command=[\"echo\", \"Hello, world!\"]))\n",
      )
    end
  end
end
