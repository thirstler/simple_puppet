# == Class: grub
#
# Configure several GRUB paramaters. Will usually affect all kernel entries.
#
# === Authors
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#

class grub (
    $elevator = "",
    $auditb = false,
    $rhgb = false,
    $quiet = false,
    $pwhash = ""
) {
   
    case $::operatingsystem {
        'RedHat', 'CentOS': {
            case $::operatingsystemmajrelease {
                '6': {
                    include ::grub::el6
                }
                '7': {
                    include ::grub::el7
                }
            }
        }
    }
}

