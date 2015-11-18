#VIsual Periodic STructure EditoR

Visualization of various molecular structure files.

Depends on Python2.7/3, Numpy, PyQT4 and the Python OpenGL bindings.

##Supported file types:

- standard xyz
- Empire-xyz
- PWScf input/output
- Lammps data/custom-dump
- Gaussian cube
- AIMALL output

##Installation:

Install globally (requires root):
```
python setup.py install
```
Install only for yourself:
```
python setup.py install --user
```
Don't install, just prepare to work in directory:
```
python setup.py build_ext -i
```

##Usage:

Start without loading:
```
vipster
```
Supported cli-options:
```
vipster -h
```

The GUI should be pretty self-explanatory (or will be at some point...)

###Mouse:

**Camera mode** (R):
Left-click: Rotate rotate
Middle-click: Move camera
Right-click: Align camera to z-axis

**Select mode** (S):
Left-click: Add/Remove atom to selection
Right-click: Clear selection

**Modify mode** (M):
Left-click: Rotate atoms around center of selection/center of molecule/clicked atom
Middle-click: Shift atoms in xy-plane (camera)
Right-click: Shift atoms along z-axis (camera)

###Tools:

**Pick:**

Displays information for selected atoms


**Script:**

Interface for more complex actions:

- **def**ine (list) name: define a named group of atoms
- **rep**eat num: repeat the following operation num times
- **shi**ft (list) (vec): shift the given list of atoms along a given direction
- **rot**ate (list) angle (vec) (shift): rotates around vector vec with offset shift
- **mir**ror (list) (vec1) (vec2) (shift): mirrors at a plane given by the vectors 1 and 2, offset by shift
- **par**allelize (list1) (list2) (list3): list2 defines plane in list1, rotate list1 so that planes defined by l2 and l3 are parallel
- **psh**ift (list1) (vec) (list2) (list3): shift list1 according to vec over surface/plane list3

Arguments can be given as follows:

(list) of atoms can be either:
- 'all'
- 'sel': selected atoms
- defined name
- single index: idx/[idx]
- range: i1-i2/[i1-i2]
- explicit list: [i1,i2,i3,i4-i5]

mandatory vector (vec) or optional vector (shift) can be one of:
- position vector of atom: (-)idx
- path between atoms: i1-i2
- explicit vector in bohr: (x,y,z)
- explicit vector in other formats: (x,y,z,'format')
  with format being one of bohr,angstrom,crystal,alat


**Cell Mod.:**

- Wrap Atoms back to cell
- Crop Atoms outside of cell
- Permanently multiply unit cell
- Reshape the cell (BEWARE! Can mess up the structure! It's your responsibility to choose correct vectors!)
- Align cell vectors with coordinate axes

**Plane:**

Display either:

- Crystal Plane: Plane given by miller indices. Cell is (fixed) reference frame.
- Volume Slice: Heatmap visualization of volume data

**Volume:**

Display isosurface generated by chosen threshold.
