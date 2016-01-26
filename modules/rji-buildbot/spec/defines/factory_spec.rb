require 'spec_helper'

describe 'buildbot::factory', :type => :define do

  let :facts do
    {
      :osfamily       => 'Debian',
      :processorcount => '2',
      :concat_basedir => '/tmp',
    }
  end

  let :title do
    'foo_factory'
  end

  it 'should create a factory' do
    should contain_concat__fragment('buildbot_factory_foo_factory').with(
      'order'   => '41',
      'target'  => '/home/buildbot/master/master.cfg',
      'content' => "foo_factory = BuildFactory()\n",
    )
  end
end
