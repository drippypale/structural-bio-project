proc secondary_structure_info {file} {
    set mol [mol load pdb $file]
    set nframes [molinfo $mol get numframes]

    set fid [open "secondary_structure.txt" "w"]

    for {set i 0} {$i < $nframes} {incr i} {
        puts $fid "frame $i"
        set sel [atomselect $mol all frame $i]
        set row [$sel get structure]

        puts $fid [join $row " "]

        set counts [dict create]
        foreach s [$sel get structure] {
            if {[dict exists $counts $s]} {
                dict incr counts $s
            } else {
                dict set counts $s 1
            }
        }
        set sortedDict [lsort -dictionary [array names counts]]

        # percentage of each secondary structure
        set total [llength [$sel get structure]]
        puts $fid "\npercentage of each secondary structure:"
        foreach {s} [dict keys $counts] {
            set percentage [expr [expr {double([dict get $counts $s]) / $total}] * 100]
            puts $fid "\t$s: $percentage"
        }
        puts $fid "------------------------------------------------"
    }
    close $fid
}