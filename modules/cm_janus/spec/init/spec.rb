require 'spec_helper'

describe 'cm_janus' do

  describe file('/etc/cm-janus/config.yaml') do
    its(:content) { should match /^httpServer:.*/ }
    its(:content) { should match /port: 8801/ }
    its(:content) { should match /apiKey: 'foobar23'.*/ }
    its(:content) { should match /^cmApi:.*/ }
    its(:content) { should match /baseUrl: 'foo'/ }
  end

  describe file('/etc/monit/conf.d/cm-janus') do
    it { should be_file }
  end

  describe file('/var/log/cm-janus/cm-janus.log') do
    it { should be_file }
  end

  describe service('cm-janus') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8801) do
    it { should be_listening }
  end
end
