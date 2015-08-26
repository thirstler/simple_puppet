require 'spec_helper'
describe 'banners' do

  context 'with defaults for all parameters' do
    it { should contain_class('banners') }
  end
end
