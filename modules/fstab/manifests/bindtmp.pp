# If included this will either add or remove the /var/tmp -> /tmp bind mount

class fstab::bindtmp ($bind = false) {
    
    if $bind == true {

        # Create a bind mount for /var/tmp -> /tmp if none exists
        augeas { "bind_vartmp_tmp":
            context => "/files/etc/fstab/",
            changes => [
                "set 01/spec /tmp",
                "set 01/file /var/tmp",
                "set 01/vfstype none",
                "set 01/opt[1] rw",
                "set 01/opt[2] bind",
                "set 01/dump 0",
                "set 01/passno 0"
            ],
            onlyif => "match /files/etc/fstab/*[file = '/var/tmp'][spec = '/tmp'] size == 0"
        }

    } else {

        # Remove bind mount
        augeas { "no_bind_vartmp_tmp":
            context => "/files/etc/fstab/",
            changes => ["rm *[file = '/var/tmp'][spec = '/tmp'][count(opt[. = 'bind']) = 1]"]
        }
    }

}
