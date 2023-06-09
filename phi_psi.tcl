proc save_phi_psi {mul} {
    # Select the backbone atoms of the protein
    set sel [atomselect $mul "backbone and name CA"]

    # Get the (phi, psi) angles for each residue in the protein
    set angles [$sel get {phi psi}]

    # Write the angles to the output file
    set outfile [open "phi_psi.txt" w]
    foreach angle $angles {
        puts $outfile [join $angle " "]
    }
    close $outfile
}