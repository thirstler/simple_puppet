require 'spec_helper'
describe 'oracle' do

  context 'with defaults for all parameters' do
    it { should contain_class('oracle') }
  end
end
