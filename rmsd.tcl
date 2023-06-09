proc rmsd_frames {file} {
    # compute rmsd between every pair of frames in a trajectory
    # and return the rmsd matrix
    set mol [mol load pdb $file]
    set nframes [molinfo $mol get numframes]

    # define rmsd_matrix which is a $nframes x $nframes matrix
    set rmsd_matrix {}
    for {set i 0} {$i < $nframes} {incr i} {
        lappend rmsd_matrix [list [string repeat "0.0 " $nframes]]
    }

    # compute rmsd between every pair of frames
    for {set i 0} {$i < $nframes} {incr i} {
        for {set j 0} {$j < $nframes} {incr j} {
            set rmsd [measure rmsd [atomselect $mol all frame $i] [atomselect $mol all frame $j]]
            lset rmsd_matrix $i $j $rmsd
        }
    }

    # save rmsd matrix to rmsd.csv file
    set fid [open "rmsd.csv" "w"]

    # write header
    set csv_index {"frame"}
    for {set i 0} {$i < $nframes} {incr i} {
        lappend csv_index $i
    }
    set csv_index_string [join $csv_index ","]
    puts $fid $csv_index_string

    # write data
    set frame 0
    foreach row $rmsd_matrix {
        set row [linsert $row 0 $frame]
        set row_string [join $row ","]
        puts $fid $row_string
        incr frame
    }

    close $fid
    return $rmsd_matrix
}