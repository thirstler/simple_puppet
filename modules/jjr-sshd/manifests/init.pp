# == Class: sshd
#
# Simple sshd configurator
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class sshd (
    $sshd_enabled = true,
    $permit_root_login = true,
    $permit_root_wkey = false,
    $password_auth = true,
    $gssapi_auth = true,
    $forward_x = true,
    $banner_file = "/etc/issue.net",
    $sshd_client_keep_alive_interval = 31536000
) {
    service { 'sshd_service':
        name => 'sshd',
        ensure => $sshd_enabled,
        enable => $sshd_enabled,
        hasrestart => true
    }
    file { 'sshd_config':
        ensure => present,
        path => '/etc/ssh/sshd_config',
        owner => 'root',
        group => 'root',
        mode => '0600',
        seltype => 'etc_t',
        content => template('sshd/sshd_config.erb'),
        notify => Service["sshd_service"]
    }
}

