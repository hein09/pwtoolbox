from test_preamble import *
from vipster.ioplugins import cube


def test_cube_parse_bohr():
    name = 'cube_angstrom'
    target = ["Comment 1\n",
              "Comment 2\n",
              "   8 0.0000 0.0000 0.0000\n",
              "   3 5.0000 0.0000 0.0000\n",
              "   3 0.0000 5.0000 0.0000\n",
              "   3 0.0000 0.0000 5.0000\n",
              "  11  1.0000 0.0000 0.0000 0.0000\n",
              "  17 -1.0000 4.7243 0.0000 0.0000\n",
              "  11  1.0000 4.7243 4.7243 0.0000\n",
              "  17 -1.0000 0.0000 4.7243 0.0000\n",
              "  17 -1.0000 0.0000 0.0000 4.7243\n",
              "  11  1.0000 4.7243 0.0000 4.7243\n",
              "  17 -1.0000 4.7243 4.7243 4.7243\n",
              "  11  1.0000 0.0000 4.7243 4.7243\n",
              "    0.000  1.000  2.000  3.000  4.000\n",
              "    5.000  6.000  7.000  8.000  9.000\n",
              "   10.000 11.000 12.000 13.000 14.000\n",
              "   15.000 16.000 17.000 18.000 19.000\n",
              "   20.000 21.000 22.000 23.000 24.000\n",
              "   25.000 26.000\n"]
    Mol, _ = cube.parser(name, target)
    assert Mol.name == name
    assert Mol.nat == 8
    assert Mol.ntyp == 2
    assert Mol.getTypes() == ['Na', 'Cl']
    assert Mol.getFmt() == 'bohr'
    assert vec_equal(Mol.getVec(), ((15, 0, 0), (0, 15, 0), (0, 0, 15)))
    assert list(map(len, Mol.getBonds(1.1))) == [12, 0, 0, 0, 0, 0, 0, 0]
    assert vec_equal(Mol.getVolOffset(), [0, 0, 0])
    assert vec_equal(Mol.getVol(),
                     (((0, 1, 2), (3, 4, 5), (6, 7, 8)),
                      ((9, 10, 11), (12, 13, 14), (15, 16, 17)),
                      ((18, 19, 20), (21, 22, 23), (24, 25, 26))))
    assert vec_equal(Mol.getVolGradient(),
                     ((((9, 9, 9), (9, 9, 9), (9, 9, 9)),
                       ((-18, -18, -18), (-18, -18, -18), (-18, -18, -18)),
                       ((9, 9, 9), (9, 9, 9), (9, 9, 9))),
                      (((3, 3, 3), (-6, -6, -6), (3, 3, 3)),
                       ((3, 3, 3), (-6, -6, -6), (3, 3, 3)),
                       ((3, 3, 3), (-6, -6, -6), (3, 3, 3))),
                      (((1, -2, 1), (1, -2, 1), (1, -2, 1)),
                       ((1, -2, 1), (1, -2, 1), (1, -2, 1)),
                       ((1, -2, 1), (1, -2, 1), (1, -2, 1)))))
    assert atom_equal(Mol.getAtom(0, charge=True), ['Na', (0, 0, 0), 1.0])


def test_cube_parse_angstrom():
    name = 'cube_angstrom'
    target = ["Comment 1\n",
              "Comment 2\n",
              "   8 0.5000 0.5000 0.5000\n",
              "  -5 1.0000 0.0000 0.0000\n",
              "  -5 0.0000 1.0000 0.0000\n",
              "  -5 0.0000 0.0000 1.0000\n",
              "  11 0.0000 0.0000 0.0000 0.0000\n",
              "  17 0.0000 4.7243 0.0000 0.0000\n",
              "  11 0.0000 4.7243 4.7243 0.0000\n",
              "  17 0.0000 0.0000 4.7243 0.0000\n",
              "  17 0.0000 0.0000 0.0000 4.7243\n",
              "  11 0.0000 4.7243 0.0000 4.7243\n",
              "  17 0.0000 4.7243 4.7243 4.7243\n",
              "  11 0.0000 0.0000 4.7243 4.7243\n",
              "    0.000  1.000  2.000  5.196  8.000\n",
              "    1.000  1.414  2.236  5.292  8.062\n",
              "    2.000  2.236  2.828  5.568  8.246\n",
              "    3.000  3.162  3.606  6.000  8.544\n",
              "    4.000  4.123  4.472  6.557  8.944\n",
              "\n",
              "    1.000  1.414  2.236  5.292  8.062\n",
              "    1.414  1.732  2.449  5.385  8.124\n",
              "    2.236  2.449  3.000  5.657  8.307\n",
              "    3.162  3.317  3.742  6.083  8.602\n",
              "    4.123  4.243  4.583  6.633  9.000\n",
              "\n",
              "    2.000  2.236  2.828  5.568  8.246\n",
              "    2.236  2.449  3.000  5.657  8.307\n",
              "    2.828  3.000  3.464  5.916  8.485\n",
              "    3.606  3.742  4.123  6.325  8.775\n",
              "    4.472  4.583  4.899  6.856  9.165\n",
              "\n",
              "    3.000  3.162  3.606  6.000  8.544\n",
              "    3.162  3.317  3.742  6.083  8.602\n",
              "    3.606  3.742  4.123  6.325  8.775\n",
              "    4.243  4.359  4.690  6.708  9.055\n",
              "    5.000  5.099  5.385  7.211  9.434\n",
              "\n",
              "    4.000  4.123  4.472  6.557  8.944\n",
              "    4.123  4.243  4.583  6.633  9.000\n",
              "    4.472  4.583  4.899  6.856  9.165\n",
              "    5.000  5.099  5.385  7.211  9.434\n",
              "    5.657  5.745  6.000  7.681  9.798\n"]
    Mol, _ = cube.parser(name, target)
    assert Mol.name == name
    assert Mol.nat == 8
    assert Mol.ntyp == 2
    assert Mol.getTypes() == ['Na', 'Cl']
    assert Mol.getFmt() == 'angstrom'
    assert vec_equal(Mol.getVec(), ((5, 0, 0), (0, 5, 0), (0, 0, 5)))
    assert list(map(len, Mol.getBonds(1.1))) == [12, 4, 4, 0, 4, 0, 0, 0]
    assert vec_equal(Mol.getVolOffset(), [0.5, 0.5, 0.5])
