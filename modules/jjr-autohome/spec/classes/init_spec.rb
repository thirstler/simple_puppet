require 'spec_helper'
describe 'autohome' do

  context 'with defaults for all parameters' do
    it { should contain_class('autohome') }
  end
end
