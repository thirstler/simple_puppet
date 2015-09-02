require 'spec_helper'
describe 'allthing' do

  context 'with defaults for all parameters' do
    it { should contain_class('allthing') }
  end
end
