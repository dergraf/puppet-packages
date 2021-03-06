class mms::agent::backup (
  $version = '3.9.0.336',
  $api_key,
  $mms_server = 'api-backup.mongodb.com'
){

# Docu: https://docs.mms.mongodb.com/tutorial/install-backup-agent-with-deb-package/

  require 'mms'

  $agent_name = 'mms-backup'
  $daemon_args = '-c /etc/mongodb-mms/backup-agent.config'

  helper::script { 'install-mms-backup':
    content => template("${module_name}/install.sh"),
    unless  => "(test -x /usr/bin/mongodb-${agent_name}-agent) && (/usr/bin/mongodb-${agent_name}-agent -version | grep -q ${version})",
  }

  file { '/etc/mongodb-mms/backup-agent.config':
    ensure  => file,
    content => template("${module_name}/conf-backup"),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    require => Helper::Script['install-mms-backup'],
    notify  => Service[$agent_name];
  }
  ->

  sysvinit::script { $agent_name:
    content           => template("${module_name}/init"),
    require           => Helper::Script['install-mms-backup'],
  }
  ->

  service { $agent_name:
    hasrestart => true,
    enable     => true,
  }

  @monit::entry { 'mms-backup':
    content => template("${module_name}/monit"),
    require => Service[$agent_name],
  }
}
