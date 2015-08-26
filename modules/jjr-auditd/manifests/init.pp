class auditd (
    $warn_action = "email",
    $emerg_action = "single",
    $audit_successful_unlink = false,
    $syslog_facility = "LOG_LOCAL6",
    $syslog_level = "LOG_INFO"
) {
    package { 'audit': ensure => installed }
    service { 'auditd_service':
        name => 'auditd',
        ensure => true,
        enable => true,
        hasrestart => true
    }
    file { 'auditd_config':
        ensure => present,
        path => '/etc/audit/auditd.conf',
        owner => 'root',
        group => 'root',
        mode => '0640',
        seltype => 'auditd_etc_t',
        content => template('auditd/auditd.conf.erb'),
        notify => Service["auditd_service"]
    }
    file { 'audit_rules':
        ensure => present,
        path => '/etc/audit/audit.rules',
        owner => 'root',
        group => 'root',
        mode => '0640',
        seltype => 'auditd_etc_t',
        content => template('auditd/audit.rules.erb'),
        notify => Service["auditd_service"]
    }
}
