class mount::common {

  file { '/usr/sbin/mount-check.sh':
    ensure  => file,
    content => template("${module_name}/mount-check.sh"),
    owner   => '0',
    group   => '0',
    mode    => '0750',
  }
}
