require 'spec_helper'
describe 'sysctl_harden' do

  context 'with defaults for all parameters' do
    it { should contain_class('sysctl_harden') }
  end
end
