require 'spec_helper'
describe 'fstab' do

  context 'with defaults for all parameters' do
    it { should contain_class('fstab') }
  end
end
