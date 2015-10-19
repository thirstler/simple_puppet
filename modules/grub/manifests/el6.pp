class grub::el6 {

   
    # Set elevator at boot time. Better to do this with tuned
    case $grub::elevator {
        "deadline", "noop", "cfq": { 
            augeas {"set_grub_elevator":
                changes => ["setm /files/boot/grub/grub.conf/title/kernel elevator ${grub::elevator}"],
                onlyif => "match /files/boot/grub/grub.conf/title/kernel/*[elevator = '${grub::elevator}'] size == 0" 
            }
        }
        # Default to removing the elevator if gibberish
        default: {
            augeas {"rm_grub_elevator":
                changes => ["rm /files/boot/grub/grub.conf/title/kernel/elevator"]
            }
        }
    }
    
    if $grub::auditb == true {
        augeas {"set_kernel_audit":
            changes => ["setm /files/boot/grub/grub.conf/title/kernel audit 1"]
        }
    } else {
        augeas {"rm_kernel_audit":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/audit"]
        }
    }
    
    if $grub::rhgb == true {
        augeas {"set_kernel_rhgb":
            changes => ['setm /files/boot/grub/grub.conf/title/kernel rhgb 1']
        }
    } else {
        augeas {"rm_kernel_rhgb":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/rhgb"]
        }
    }
    
    if $grub::quiet == true {
        augeas {"set_kernel_quiet":
            changes => ["setm /files/boot/grub/grub.conf/title/kernel quiet 1"],
        }
    } else {
        augeas {"rm_kernel_quiet":
            changes => ["rm /files/boot/grub/grub.conf/title/kernel/quiet"]
        }
    }
    
    if $grub::pwhash == "" {
        augeas {"rm_grub_pw":
            changes => ["rm /files/boot/grub/grub.conf/password"]
        }
    } else {
    
        augeas { "grub-create-password":
            context => "/files/boot/grub/grub.conf",
            changes => [
                "ins password after default",
                "set password/encrypted ''",
                "set password ${grub::pwhash}",
            ],
            onlyif => "match password size == 0",
        }

        augeas { "grub-set-password":
            context => "/files/boot/grub/grub.conf",
            changes => "set password ${grub::pwhash}",
            require => Augeas["grub-create-password"],
        }
        
    }
}
