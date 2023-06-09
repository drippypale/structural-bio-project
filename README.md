
# Structural Bioinformatics `VMD-tcl` project

This project consists of multiple `tcl` modules, which perform following tasks on a given protein `pdb` file (`NMR` structure):

1. Find the **amino acid sequence** of the protein along with the **number of amino acids**.
2. Write a procedure to find the **secondary structure sequence** of the protein in each frame of the trajectory along with the **percentage of each secondary structure** type.
3. Compute the **$\phi$** and **$\psi$** angles for the protein and plot the **Ramachandran** plot using whatever plotting package you like.
4. Write a procedure to calculate the **RMSD** matrix for the trajectory (**RMSD** between every 2 frames).
5. Write a procedure to output following information for each atom in the **hbonds**:
	- Amino acid id
	- Amino acid name
	- Secondary structure type
	- $\omega$ angle
	- $\phi$ angle
	- $\psi$ angle
	- Radius of gyration

## Modules
In this section, we'll introduce each module in the order of its corresponding task:
### 1. `amino_acids.tcl`
It provides the `get_amino_acids {mul}` `proc` which gets a `mul` ID as the input, and prints out **amino acids sequence** and their **counts** in the provided protein.

Example usage:
```tcl
set mul [mol load pdb 2pph.pdb]
source amino_acids.tcl
get_amino_acids $mul
```

### 2. `secondary_structure.tcl`
It provides the `secondary_structure_info {file}` `proc` which gets a `pdb` `file` name as the input, iterates through every frame of the protein, and writes out the protein **secondary structure sequence** along with the **percentage** of each secondary structure type in a **secondary_structure.txt** file.

Example usage:
```tcl
source secondary_structure.tcl
secondary_structure_info 2pph.pdb
```

### 3. `phi_psi.tcl`
It provides the `save_phi_psi {mul}` `proc` which gets a `mul` ID as input and saves the $\phi$, $\psi$ angles of each residue in the **phi_psi.txt** file.

Example usage:
```tcl
set mul [mol load pdb 2pph.pdb]
source phi_psi.tcl
save_phi_psi $mul
```
There is also a `ramachandran.ipynb` jupyter notebook which you can run in order to plot the *Ramachandran* plot from the **phi_psi.txt**.

### 4. `rmsd.tcl`
It provides the `rmsd_frames {file}` `proc` which gets a `pdb` `file` name as the input, and fills up a `rmsd_matrix` which is a $\text{nframes} \times \text{nframes}$ matrix with their corresponding *rmsd* distance (using `measure rmsd`).
The resulting `rmsd_matrix` will be saved as a `csv` file, named **rmsd.csv**.
The procedure also returns the `rmsd_matrix`.

Example usage:
```tcl
source rmsd.tcl
rmsd 2pph.pdb
```

### 5. `hbonds.tcl`
It provides the `proc get_hbonds {mol}` `proc` which gets a `mul` ID as input, then using the `measure hbonds`, finds the index of the atoms contributing in the *hbonds* and provides the following attributes for each selected atom: {*resid*, *resname*, *structure*, $\phi$, $\psi$, $\omega$, *rgyr*}.
Note that unlike $\phi$ and $\psi$, $\omega$ is not calculated by the *VMD*, so we provided another procedure called `omega_dihedral {mul  resid}`  which selects the $C_\alpha$, $C$ atoms of the given residue, and $N$,  $C_\alpha$ of the next residue in the chain, and returns the $\omega$ angle as: $$\omega = \texttt{measure dihed } \{ C_\alpha, C, N^{+1}, C^{+1}_\alpha \}$$
<sub>$+1$ superpos indicates the next residue atoms.</sub>

Finally the `proc get_hbonds {mol}` procedure, writes out the results as a `csv` file, named **hbonds.csv** and also returns the result list.

Example usage:
```tcl
set mul [mol load pdb 2pph.pdb]
source hbonds.tcl
get_hbonds $mul
```
