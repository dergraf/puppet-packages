require 'spec_helper'

describe 'daemon' do

  # With *sysvinit* we don't KILL the program if it doesn't respond to TERM
  check_initv = [
    'pgrep -f "^/bin/bash /tmp/my-program$"',
    'pgrep -f "^/bin/bash /tmp/my-program-child$"',
    '/etc/init.d/my-program status',
    'grep "stop failed" /tmp/spec-log',
  ].join(' && ')

  # With *systemd* we KILL the whole process cgroup if the process doesn't respond to TERM
  check_systemd = [
    '! pgrep -f "^/bin/bash /tmp/my-program$"',
    '! pgrep -f "^/bin/bash /tmp/my-program-child$"',
    'systemctl status my-program | grep -q "Active: failed (Result: signal)"',
  ].join(' && ')

  describe command("if (test -e /bin/systemctl); then #{check_systemd}; else #{check_initv}; fi") do
    its(:exit_status) { should eq 0 }
  end

end
