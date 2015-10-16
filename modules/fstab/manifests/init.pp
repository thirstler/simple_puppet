class fstab (
    $bindtmp = true
) {

    include ::fstab::opts
    
    if $bindtmp {
    	include ::fstab::bindtmp
    }
}
