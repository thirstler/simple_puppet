class autohome(
        $nfs_server = 'localhost',
        $local_path = '/home',
        $remote_path = '/home',
        $nfs_ver = 3)
{
    selboolean { 'use_nfs_home_dirs': value => true }
    package { 'autofs': ensure => installed }
    service { 'autofs_service':
        name => 'autofs',
        ensure => true,
        enable => true,
        hasrestart => true
    }
    if ($nfs_server != $fqdn) {
        file { 'autofs_master_config':
            ensure => present,
            path => '/etc/auto.master',
            owner => 'root',
            group => 'root',
            mode => '0644',
            seltype => 'etc_t',
            content => template('autohome/auto.master.erb'),
            notify => Service["autofs_service"]
        }
        file { 'autofs_home_config':
            ensure => present,
            path => '/etc/auto.home',
            owner => 'root',
            group => 'root',
            mode => '0644',
            seltype => 'etc_t',
            content => template('autohome/auto.home.erb'),
            notify => Service["autofs_service"]
        }
    }
}

