# a proc to calculate omega dihedral angle for a given residue using the CA, C, N, CA atoms
proc omega_dihedral {mul resid} {
    set CA [[atomselect $mul "resid $resid and name CA"] get {index}]
    set C [[atomselect $mul "resid $resid and name C"] get {index}]
    set N_next [[atomselect $mul "resid [expr $resid + 1] and name N"] get {index}]
    set CA_next [[atomselect $mul "resid [expr $resid + 1] and name CA"] get {index}]

    set indices [list $CA $C $N_next $CA_next]
    set omega [measure dihed $indices]

    return $omega
}

proc get_hbonds {mol} {
    # select all atoms
    set sel [atomselect $mol all]
    # measure hydrogen bonds
    set hbonds [measure hbonds 20 3.4 $sel]
    # get the location of the hydrogen bonds
    set hbonds_location [lindex $hbonds 2] 
    puts $hbonds_location

    # select the residues involved in the hydrogen bonds
    set residues [atomselect $mol "index $hbonds_location"] 
    
    set result [$residues get {resid resname structure phi psi}]

    set new_result {}
    # loop over the residues to calculate omega dihedral angle and radius of gyration and write to file
    set fid [open "hbonds.csv" "w"]
    puts $fid "index,resid,resname,structure,phi,psi,omega,rgyr"

    for {set i 0} {$i < [llength $result]} {incr i} {
        set resid [lindex $result $i 0]

        set row [lindex $result $i]
        set row [linsert $row 0 $i]

        # calculate omega dihedral angle using the proc defined above
        set omega [omega_dihedral $mol $resid]
        # calculate radius of gyration
        set rgyr [measure rgyr [atomselect $mol "resid $resid"]]

        lappend row $omega
        lappend row $rgyr

        lappend new_result $row
        puts $fid [join $row ","]
    }
    close $fid

    return $new_result
}
