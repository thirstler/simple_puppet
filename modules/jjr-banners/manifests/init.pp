# == Class: banners
#
# Just sets up login banners
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class banners {
    if ! $::global_banner_text {
        $global_banner_text = false
    } else {
        $global_banner_text = $::global_banner_text
    }
    file { 'issue_config':
        ensure => present,
        path => '/etc/issue',
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'etc_runtime_t',
        content => template('banners/issue_net.erb')
    }
    file { 'issue_net_config':
        ensure => present,
        path => '/etc/issue.net',
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'etc_runtime_t',
        content => template('banners/issue_net.erb')
    }
}

