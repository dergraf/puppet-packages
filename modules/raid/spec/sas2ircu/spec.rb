require 'spec_helper'

describe 'raid::sas2ircu' do

  describe package('sas2ircu-status') do
    it { should be_installed }
  end

  describe command('monit summary') do
    its(:stdout) { should match /Process 'sas2ircu-statusd'/ }
  end

  describe file('/etc/default/sas2ircu-statusd') do
    it { should be_file }
  end
end
