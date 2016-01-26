require 'spec_helper'

describe 'buildbot::builder', :type => :define do

  let :facts do
    {
      :osfamily       => 'Debian',
      :processorcount => '2',
      :concat_basedir => '/tmp',
    }
  end

  let :title do
    'runtests'
  end

  let :params do
    {
      'factory'     => 'testfactory',
      'slave_names' => [ 'buildslave1', 'buildslave2' ],
    }
  end

  it 'should create a builder' do
    should contain_concat__fragment('buildbot_builder_runtests').with(
      'order'   => '55',
      'target'  => '/home/buildbot/master/master.cfg',
      'content' => "c['builders'].append(BuilderConfig(name='runtests', slavenames=[\"buildslave1\", \"buildslave2\"], factory=testfactory))\n",
    )
  end
end
