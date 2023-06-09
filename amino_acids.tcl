proc get_amino_acids {mul} {
    set sel [atomselect $mul "protein and name CA"]

    set amino_acids [$sel get resname]

    set amino_counts [dict create]
    foreach res [$sel get resname] {
        if {[dict exists $amino_counts $res]} {
            dict incr amino_counts $res
        } else {
            dict set amino_counts $res 1
        }
    }

    puts "Amino acids sequence:\n$amino_acids\n"

    puts "Amino acid counts:"
    foreach {res} [dict keys $amino_counts] {
        set count [dict get $amino_counts $res]
        puts "\t$res: $count"
    }
}