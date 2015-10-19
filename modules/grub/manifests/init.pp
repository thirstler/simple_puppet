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
   
    # Set elevator at boot time. Better to do this with tuned
    case $elevator {
        "deadline", "noop", "cfq": { 
            augeas {"set_grub_elevator":
                changes => ["setm /files/boot/grub/grub.conf/title/kernel elevator ${elevator}"],
                onlyif => "match /files/boot/grub/grub.conf/title/kernel/*[elevator = '${elevator}'] size == 0" 
            }
        }
        # Default to removing the elevator if gibberish
        default: {
            augeas {"rm_grub_elevator":
                changes => ["rm /files/boot/grub/grub.conf/title/kernel/elevator"]
            }
        }
    }
    
    if $auditb == true {
        augeas {"set_kernel_audit":
            changes => ["setm /files/boot/grub/grub.conf/title/kernel audit 1"]
        }
    } else {
        augeas {"rm_kernel_audit":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/audit"]
        }
    }
    
    if $rhgb == true {
        augeas {"set_kernel_rhgb":
            changes => ['setm /files/boot/grub/grub.conf/title/kernel rhgb 1']
        }
    } else {
        augeas {"rm_kernel_rhgb":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/rhgb"]
        }
    }
    
    if $quiet == true {
        augeas {"set_kernel_quiet":
            changes => ["setm /files/boot/grub/grub.conf/title/kernel quiet 1"],
        }
    } else {
        augeas {"rm_kernel_quiet":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/quiet"]
        }
    }
    
    if $pwhash == "" {
        augeas {"rm_grub_pw":
            changes => ["rm /files/boot/grub/grub.conf/password"]
        }
    } else {
        augeas {"set_grub_pw":
            context => "/files/boot/grub/grub.conf",
            changes => [
                "ins password after default",
                "clear password/encrypted",
                "set password '${pwhash}'"],
            onlyif => "match password size == 0"
        }
    }
}

