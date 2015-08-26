# == Class: ntp
#
# Simple NTP config. Can be used to configure a time source.
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class ntp (
    $time_source = false,
    $time_network = "127.0.0.1/8",
    $time_servers = ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"],
    $time_peers = []
) {
    if ($operatingsystemmajrelease >= 6) {
        package { 'ntpdate': ensure => present }
    }
    package { 'ntp': ensure => present }
    service { 'ntp_service':
        name => 'ntpd',
        ensure => true,
        enable => true,
        hasrestart => true,
        require => Package["ntp"]
    }
    file { 'ntpd_config':
        ensure => present,
        path => '/etc/ntp.conf',
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'net_conf_t',
        content => template('ntp/ntp.conf.erb'),
        notify => Service["ntp_service"]
    }
}

