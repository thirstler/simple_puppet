# == Class: fstab
#
# Add/remoce nodev, nosuid and/or noexec as applicable to various mountpoints
# it only affects this subset of mount options and will leave the others alone.
# Data is entered via this data structure:
#
# {"mountpoint" => ["option1","option2"]}:
#
# eg: {"/home" => ["nosuid","nodev], "/tmp" => ["nosuid","nodev","noexec"]}
#
# Any of these three options NOT in the list are explicitly removed if already
# present.
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#


class fstab_opts (
    $root = ["defaults"],
    $var = ["defaults"],
    $tmp = ["defaults"],
    $var_log = ["defaults"],
    $var_log_audit = ["defaults"],
    $dev_shm = ["defaults"],
    $usr = ["defaults"],
    $swap = ["defaults"],
    $home = ["defaults"]
) {

    define setopt {
        $mntop = split($title, "-")
        notify {"entering add-fstab-${mntop[0]}-${mntop[1]}": }
        augeas { "add-fstab-${mntop[0]}-${mntop[1]}":
            context => "/files/etc/fstab/*[file = '${mntop[0]}']/",
            changes => [
                   "ins opt after opt[last()]",
                   "set opt[last()] ${mntop[1]}"
            ],
            onlyif  => "match /files/etc/fstab/*[file = '${mntop[0]}'][count(opt[. = '${mntop[1]}']) = 0] size > 0",
        }
    }
    
    define rmopt {
        $mntop = split($title, "-")
        augeas { "rm-fstab-${mntop[0]}-${mntop[1]}":
            changes => ["rm /files/etc/fstab/*[file = '${mntop[0]}']/opt[. = '${mntop[1]}']"],
        }
    }
    
    define setforfs ($fs) {
    
        if member($fs, "noexec") { setopt { "${title}-noexec" : } }
        else { rmopt { "${title}-noexec" : } }

        if member($fs, "nodev") { setopt { "${title}-nodev" : } }
        else { rmopt { "${title}-nodev" : } }

        if member($fs, "nosuid") { setopt { "${title}-nosuid" : } }
        else { rmopt { "${title}-nosuid" : } }

        if member($fs, "defaults") { setopt { "${title}-defaults" : } }
        else { rmopt { "${title}-defaults" : } }
    }
   
 
    setforfs { "/" : fs => $root }
    setforfs { "/var" : fs => $var }
    setforfs { "/tmp" : fs => $tmp }
    setforfs { "/var/log" : fs => $var_log }
    setforfs { "/var/log/audit" : fs => $var_log_audit }
    setforfs { "/dev/shm" : fs => $dev_shm }
    setforfs { "/usr" : fs => $usr }
    setforfs { "swap" : fs => $swap }
    setforfs { "/home" : fs => $home }

}
