# == Class: rsyslog
#
# Configures rsyslog on a system to send to a loghost - or if the system IS
# the loghost it will configure that system to receive logs. Works on both
# ends. Will also configure the audisp syslog plugin to log auditing to the
# central log host. This module does not do SSL and it should be noted that
# audit logging without SSL is a bit of a security hazard.
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class rsyslog (
    $syslog_host = "localhost",
    $syslog_proto = "udp",
    $is_loghost = false,
    $audit_to_syslog = false,
    $retention_weeks = 4,
    $compress_logs = false
) {
    package { 'rsyslog_rpm':
        name => 'rsyslog',
        ensure => present
    }
    service { 'rsyslog_service':
        name => 'rsyslog',
        ensure => true,
        enable => true,
        hasrestart => true
    }
    file { 'rsyslog_config':
        ensure => present,
        path => '/etc/rsyslog.conf',
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'syslog_conf_t',
        content => template('rsyslog/rsyslog.conf.erb'),
        notify => Service["rsyslog_service"]
    }    
    file { 'audit_syslog_plugin_config':
        ensure => present,
        path => '/etc/audisp/plugins.d/syslog.conf',
        owner => 'root',
        group => 'root',
        mode => '0640',
        seltype => 'etc_t',
        content => template('rsyslog/audisp_syslog.erb'),
        notify => Service["auditd_service"]
    }
    file { 'syslog_logrotate':
        ensure => present,
        path => '/etc/logrotate.d/syslog',
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'etc_t',
        content => template('rsyslog/syslog_rotate.erb')
    }
    if $is_loghost == true {
        file { 'loghost_logrotate':
            ensure => present,
            path => '/etc/logrotate.d/loghost_syslog',
            owner => 'root',
            group => 'root',
            mode => '0644',
            seltype => 'etc_t',
            content => template('rsyslog/loghost_rotate.erb')
        }
    }
}

