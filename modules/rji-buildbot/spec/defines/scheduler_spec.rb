require 'spec_helper'

describe 'buildbot::scheduler', :type => :define do

  let :facts do
    {
      :osfamily       => 'Debian',
      :processorcount => '2',
      :concat_basedir => '/tmp',
    }
  end

  context 'for a SingleBranchScheduler' do
    let :title do
      'project-all'
    end

    let :params do
      {
        'type'              => 'SingleBranchScheduler',
        'change_filter'     => "branch='master'",
        'tree_stable_timer' => 'None',
        'builder_names'     => [ 'builder1', 'builder2' ],
      }
    end

    it 'should create a SingleBranchScheduler' do
      should contain_concat__fragment('buildbot_SingleBranchScheduler_project-all').with(
        'order'   => '35',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => "c['schedulers'].append(SingleBranchScheduler(name='project-all', change_filter=filter.ChangeFilter(branch='master'), treeStableTimer=None, builderNames=[\"builder1\", \"builder2\"]))\n",
      )
    end
  end

  context 'for a ForceScheduler' do
    let :title do
      'project-force'
    end

    let :params do
      {
        'type'          => 'ForceScheduler',
        'builder_names' => [ 'builder1', 'builder2' ],
      }
    end

    it 'should create a ForceScheduler' do
      should contain_concat__fragment('buildbot_ForceScheduler_project-force').with(
        'order'   => '35',
        'target'  => '/home/buildbot/master/master.cfg',
        'content' => "c['schedulers'].append(ForceScheduler(name='project-force', builderNames=[\"builder1\", \"builder2\"]))\n",
      )
    end
  end

  context 'with an unknown scheduler type' do
    let :title do
      'project-fake'
    end

    let :params do
      {
        'type' => 'FooBarBazSchedulerFake',
      }

      it 'should fail with compilation error' do
        it do
          expect {
            should contain_concat__fragment('buildbot_FooBarBazSchedulerFake_project-fake')
          }.to raise_error(Puppet::Error, /Unsupported/)
        end
      end
    end
  end
end
