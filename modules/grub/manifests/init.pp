# == Class: grub
#
# Full description of class grub here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'grub':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#

class grub (
    $elevator = "",
    $audit = false,
    $rhgb = false,
    $quiet = false,
    $pwhash = ""
) {

    case $elevator {
        "deadline", "noop", "cfq" { 
            augeas {"set_grub_elevator":
                changes => ["setm /files/boot/grub/grub.conf/title/kernel elevator ${elevator}"],
                onlyif => "match /files/boot/grub/grub.conf/title/kernel/[elevator = '${elevator}'] size == 0" 
            }
        }
        # Default to removing the elevator if gibberish
        default: {
            augeas {"rm_grub_elevator":
                changes = ["rm /files/boot/grub/grub.conf/title/kernel/elevator"]
            }
        }
    }
    
    if $audit == true {
        augeas {"set_kernel_audit":
            changes = ["setm /files/boot/grub/grub.conf/title/kernel audit 1"]
        }
    } else {
        augeas {"rm_kernel_audit":
            changes = ["rm /files/boot/grub/grub.conf/title/kernel/audit"]
        }
    }
    
    if $rhgb == true {
        augeas {"set_kernel_rhgb":
            changes = ["setm /files/boot/grub/grub.conf/title/kernel rhgb"]
        }
    } else {
        augeas {"rm_kernel_rhgb":
            changes = ["rm /files/boot/grub/grub.conf/title/kernel/rhgb"]
        }
    }
    
    if $quiet == true {
        augeas {"set_kernel_quiet":
            changes = ["setm /files/boot/grub/grub.conf/title/kernel quiet"]
        }
    } else {
        augeas {"rm_kernel_quiet":
            changes = ["rm /files/boot/grub/grub.conf/title/kernel/quiet"]
        }
    }
    
    if $pwhash == "" {
        augeas {"rm_grub_pw":
            changes = ["rm /files/boot/grub/grub.conf/password"]
        }
    } else {
        augeas {"set_grub_pw":
            changes = [
                "set /files/boot/grub/grub.conf/password '${pwhash}'",
                "set /files/boot/grub/grub.conf/password/encrypted"]
        }
    }
    
    
}
