require 'spec_helper'
describe 'resolv' do

  context 'with defaults for all parameters' do
    it { should contain_class('resolv') }
  end
end
