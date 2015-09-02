# == Class: oracle
#
# Configures system w/kernel parameter to be an Oracle host. Refer to the 
# Oracle and Red Hat documentation for information on what a lot of these
# parameters mean.
#
# === Parameters
#
# === Variables
#
# None
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class oracle(
    $sem = "250 32000 100 128",
    $shmall = 2097152,
    $shmmax = 4294967295,
    $shmmni = 4096,
    $file_max = 6815744,
    $ip_local_port_range = "9000 65500",
    $net_rmem_default = 262144,
    $net_rmem_max = 4194304,
    $net_wmem_default = 262144,
    $net_wmem_max = 1048576,
    $aio_max_nr = 1048576,
    $oracle_home = "/home/oracle",
    $oracle_uid = 32561,
    $oracle_gid = 32561,
    $vm_swappiness = 1,
) {
    
    user { 'oracle':
        ensure => present,
        comment => 'Oracle',
        gid => $oracle_gid,
        uid => $oracle_uid,
        home => $oracle_home,
        shell => '/bin/bash'
    }

    ##
    # These will usually be installed per a default installation, but whatever
    package {'binutils': ensure => present }
    package {'compat-libcap1': ensure => present }
    package {'compat-libstdc++-33': ensure => present }
    package {'gcc': ensure => present }
    package {'gcc-c++': ensure => present }
    package {'glibc': ensure => present }
    package {'glibc-devel': ensure => present }
    package {'libgcc': ensure => present }
    package {'libstdc++': ensure => present }
    package {'libstdc++-devel': ensure => present }
    package {'libaio': ensure => present }
    package {'libaio-devel': ensure => present }
    package {'make': ensure => present }
    package {'sysstat': ensure => present }
    package {'unixODBC': ensure => present }
    package {'unixODBC-devel': ensure => present }
    package {'xorg-x11-utils': ensure => present }
    package {'xorg-x11-xauth': ensure => present }

    augeas {'sysctl_oracle_config':        
        context   => "/files",
        incl => "/etc/sysctl.conf",
        lens => "Sysctl.lns",
        changes   => [
            "set etc/sysctl.conf/kernel.sem '$sem'",
            "set etc/sysctl.conf/kernel.shmall $shmall",
            "set etc/sysctl.conf/kernel.shmmax $shmmax",
            "set etc/sysctl.conf/kernel.shmmni $shmmni",
            "set etc/sysctl.conf/fs.file-max $file_max",
            "set etc/sysctl.conf/net.ipv4.ip_local_port_range '$ip_local_port_range'",
            "set etc/sysctl.conf/net.core.rmem_default $net_rmem_default",
            "set etc/sysctl.conf/net.core.rmem_max $net_rmem_max",
            "set etc/sysctl.conf/net.core.wmem_default $net_wmem_default",
            "set etc/sysctl.conf/net.core.wmem_max $net_wmem_max",
            "set etc/sysctl.conf/fs.aio-max-nr $aio_max_nr",
            "set etc/sysctl.conf/vm.swappiness $vm_swappiness",
            "set etc/sysctl.conf/vm.dirty_background_ratio 3",
            "set etc/sysctl.conf/vm.dirty_ratio 80",
            "set etc/sysctl.conf/vm.dirty_expire_centisecs 500",
            "set etc/sysctl.conf/vm.dirty_writeback_centisecs 100"
        ]
    }
}
