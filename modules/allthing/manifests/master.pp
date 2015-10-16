class allthing::master (
    $master_state = stopped,
    $db_port = 5432,
    $db_hostname = "localhost.localdomain",
    $db_username = "allthing",
    $db_password = "allthing",
    $db_database = "allthing",
    $db_commit_rate = 300 )
{

    case $master_state {
        /^(running|stopped)$/: {
            # you're alright, do nothing
        }
        default: {
            fail("${title}: master_state value '${master_state}' is not recognized")
        }
    }
    
    package { 'all-thing-master': ensure => installed }
    
    service { 'at_master': ensure => $master_state, require => Package['all-thing-master'] }    
    
    file { '/etc/allthing/master.conf':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0600',
        seltype => 'etc_t',
        content => template('allthing/master.conf.erb'),
        notify => Service["at_master"]    
    }
}

