# == Class: fstab
#
# Add/remoce nodev, nosuid and/or noexec as applicable to various mountpoints
# it only affects this subset of mount options and will leave the others alone.
# Data is entered as an array of the above options per mountpoint.
#
# If the first element of input for a mountpoint is '_NULL_' configuration of
# that mountpoint is skipped.
#
# Jason Russler <jason.russler@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jason Russler
#


class fstab::opts (
    $root = ['_NULL_'],
    $var = ['_NULL_'],
    $tmp = ['_NULL_'],
    $var_log = ['_NULL_'],
    $var_log_audit = ['_NULL_'],
    $dev_shm = ['_NULL_'],
    $usr = ['_NULL_'],
    $swap = ['_NULL_'],
    $home = ['_NULL_'],
    $boot = ['_NULL_']
) {
    
    # Add option to mountpoint. All data is in the title to give each call a
    # unique name.
    define setopt {
        $mntop = split($title, "-")
        augeas { "add-fstab-${mntop[0]}-${mntop[1]}":
            context => "/files/etc/fstab/*[file = '${mntop[0]}']/",
            changes => [
                   "ins opt after opt[last()]",
                   "set opt[last()] ${mntop[1]}"
            ],
            onlyif  => "match /files/etc/fstab/*[file = '${mntop[0]}'][count(opt[. = '${mntop[1]}']) = 0] size > 0",
        }
    }
    
    # Remove option frome a mountpoint. All data is in the title to give each
    # call a unique name.
    define rmopt {
        $mntop = split($title, "-")
        augeas { "rm-fstab-${mntop[0]}-${mntop[1]}":
            changes => ["rm /files/etc/fstab/*[file = '${mntop[0]}']/opt[. = '${mntop[1]}']"],
        }
    }
   
    # Call for each mount point to set the established set of options. If an
    # option not controlled by this module is present it is ignored. 
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
   
    # If first element is '_NULL_' we skip any alterations
    if $root[0] != '_NULL_' { setforfs { "/" : fs => $root } }
    if $var[0] != '_NULL_' { setforfs { "/var" : fs => $var } }
    if $tmp[0] != '_NULL_' { setforfs { "/tmp" : fs => $tmp } }
    if $var_log[0] != '_NULL_' { setforfs { "/var/log" : fs => $var_log } }
    if $var_log_audit[0] != '_NULL_' { setforfs { "/var/log/audit" : fs => $var_log_audit } }
    if $dev_shm[0] != '_NULL_' { setforfs { "/dev/shm" : fs => $dev_shm } }
    if $usr[0] != '_NULL_' { setforfs { "/usr" : fs => $usr } }
    if $swap[0] != '_NULL_' { setforfs { "swap" : fs => $swap } }
    if $home[0] != '_NULL_' { setforfs { "/home" : fs => $home } }
    if $boot[0] != '_NULL_' { setforfs { "/boot" : fs => $boot } }

}
