# == Class: sysctl
#
# Set some sysctl values pursuant to system hardening
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#
class sysctl_harden (
    $exec_shield = true,
    $nf_on_bridges = false
) {

    if $::operatingsystemrelease < 7 { $sysctl_cf_file = "/etc/sysctl.conf" }
    else { $sysctl_cf_file = "/usr/lib/sysctl.d/00-system.conf" }

    if $nf_on_bridges == true { $net_br_val = "1" }
    else { $net_br_val = "0" }

    if $exec_shield == true { $exec_sh_val = "1" }
    else { $exec_sh_val = "0" }

    exec {'load_sysctl_config':
        command => '/sbin/sysctl -p > /dev/null',
        refreshonly => true,
        subscribe => Augeas['sysctl_incbr_config']
    }

    $sysctl_changes = ["set etc/sysctl.conf/net.bridge.bridge-nf-call-ip6tables $net_br_val",
                       "set etc/sysctl.conf/net.bridge.bridge-nf-call-iptables $net_br_val",
                       "set etc/sysctl.conf/net.bridge.bridge-nf-call-arptables $net_br_val",
                       "set etc/sysctl.conf/kernel.exec-shield $exec_sh_val"]

    augeas {'sysctl_incbr_config':
        context   => "/files",
        incl => $sysctl_cf_file,
        lens => "Sysctl.lns",
        changes   => $sysctl_changes
    }
}

