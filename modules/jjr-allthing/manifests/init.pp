# == Class: allthing
#
# Manages allthing configuration on master and agent hosts
#
# === Parameters
#
# Document parameters here.
#
# [*master_target*]
#   Host running at_master service
# [*master_recvprt*]
#   UDP port that is listening for agent reports
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class allthing (
    $master_host = "localhost.localdomain",
    $master_port = 3456,
    $agent_state = stopped,
    $agent_poll_rate = 5000000,
    $agent_msg_size = 1024,
    $agent_location = "default",
    $agent_group = "default",
    $agent_contact = "root@localhost.localdomain",
    $is_master = false,
    $master_state = stopped,
    $db_hostname = "localhost.localdomain",
    $db_port = 5432,
    $db_username = "allthing",
    $db_password = "allthing",
    $db_database = "allthing",
    $db_commit_rate = 300
) {
    
    case $is_master {
        /^true$/: {
            class { "allthing::master":
                master_state => $master_state,
                db_hostname => $db_hostname,
                db_username => $db_username,
                db_password => $db_password,
                db_database => $db_database,
                db_commit_rate => $db_commit_rate
            }
        }
        /^false$/: {
            # righty-ho! do nothing
        }
        default: {
            fail("${title}: is_master value '${is_master}' is not recognized")
        }
    }
    
    case $agent_state {
        /^(running|stopped)$/: {
            # you're alright, do nothing
        }
        default: {
            fail("${title}: agnet_state value '${agent_state}' is not recognized")
        }
    }
    
    package { 'all-thing-agent': ensure => installed }
    
    service { 'at_agent': ensure => $agent_state, require => Package['all-thing-agent'] }
    
    file { '/etc/allthing':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '700',
        seltype => 'etc_t'
    } 
    file { '/etc/allthing/allthing.conf':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0600',
        seltype => 'etc_t',
        content => template('allthing/allthing.conf.erb'),
        require => [Package['all-thing-agent'], File['/etc/allthing']]
    }
    

    file { '/etc/allthing/agent.conf':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0600',
        seltype => 'etc_t',
        content => template('allthing/agent.conf.erb'),
        notify => Service["at_agent"]    
    }
}

