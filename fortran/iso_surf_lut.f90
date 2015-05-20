MODULE iso_surf_lut
IMPLICIT NONE
REAL,DIMENSION(3,0:11)::edge_off=reshape((/&
    0.0, 0.0, 0.5,&
    0.5, 0.0, 1.0,&
    1.0, 0.0, 0.5,&
    0.5, 0.0, 0.0,&
    0.0, 0.5, 1.0,&
    1.0, 0.5, 1.0,&
    1.0, 0.5, 0.0,&
    0.0, 0.5, 0.0,&
    0.0, 1.0, 0.5,&
    0.5, 1.0, 1.0,&
    1.0, 1.0, 0.5,&
    0.5, 1.0, 0.0/),(/3,12/))
INTEGER,DIMENSION(0:255)::nv_lut=(/0, 1, 1, 2, 1, 2, 2, 3,&
1, 2, 2, 3, 2, 3, 3, 2,&
1, 2, 2, 3, 2, 3, 3, 4,&
2, 3, 3, 4, 3, 4, 4, 3,&
1, 2, 2, 3, 2, 3, 3, 4,&
2, 3, 3, 4, 3, 4, 4, 3,&
2, 3, 3, 2, 3, 4, 4, 3,&
3, 4, 4, 3, 4, 3, 3, 2,&
1, 2, 2, 3, 2, 3, 3, 4,&
2, 3, 3, 4, 3, 4, 4, 3,&
2, 3, 3, 4, 3, 2, 4, 3,&
3, 4, 4, 3, 4, 3, 3, 2,&
2, 3, 3, 4, 3, 4, 4, 3,&
3, 4, 4, 3, 4, 3, 3, 2,&
3, 4, 4, 3, 4, 3, 3, 2,&
4, 3, 3, 2, 3, 2, 2, 1,&
1, 2, 2, 3, 2, 3, 3, 4,&
2, 3, 3, 4, 3, 4, 4, 3,&
2, 3, 3, 4, 3, 4, 4, 3,&
3, 4, 4, 3, 4, 3, 3, 2,&
2, 3, 3, 4, 3, 4, 4, 3,&
3, 4, 2, 3, 4, 3, 3, 2,&
3, 4, 4, 3, 4, 3, 3, 2,&
4, 3, 3, 2, 3, 2, 2, 1,&
2, 3, 3, 4, 3, 4, 4, 3,&
3, 4, 4, 3, 2, 3, 3, 2,&
3, 4, 4, 3, 4, 3, 3, 2,&
4, 3, 3, 2, 3, 2, 2, 1,&
3, 4, 4, 3, 4, 3, 3, 2,&
4, 3, 3, 2, 3, 2, 2, 1,&
2, 3, 3, 2, 3, 2, 2, 1,&
3, 2, 2, 1, 2, 1, 1, 0/)

INTEGER,DIMENSION(3,4,0:255)::edge_lut=reshape((/ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  3, 7, 4, 3, 4, 1, 0, 0, 0, 0, 0, 0,&
  7,11, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3,11, 0,11, 8, 0, 0, 0, 0, 0, 0,&
  7,11, 8, 0, 1, 4, 0, 0, 0, 0, 0, 0,&
  4, 8, 1, 8,11, 1, 1,11, 3, 0, 0, 0,&
  4, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  4, 8, 9, 0, 3, 7, 0, 0, 0, 0, 0, 0,&
  0, 1, 8, 1, 8, 9, 0, 0, 0, 0, 0, 0,&
  1, 3, 9, 3, 9, 8, 3, 7, 8, 0, 0, 0,&
  4, 7,11, 4, 9,11, 0, 0, 0, 0, 0, 0,&
  9, 3,11, 0, 3, 9, 0, 9, 4, 0, 0, 0,&
  1, 9,11, 1, 0,11, 0, 7,11, 0, 0, 0,&
  1, 9,11, 1, 3,11, 0, 0, 0, 0, 0, 0,&
  2, 3, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 2, 7, 6, 2, 7, 0, 0, 0, 0, 0, 0,&
  2, 3, 6, 0, 1, 4, 0, 0, 0, 0, 0, 0,&
  4, 7, 6, 4, 6, 1, 1, 6, 2, 0, 0, 0,&
  2, 3, 6, 7, 8,11, 0, 0, 0, 0, 0, 0,&
  0, 2, 8, 2, 8, 6, 8, 6,11, 0, 0, 0,&
  2, 3, 6, 7,11, 8, 0, 1, 4, 0, 0, 0,&
  1, 2, 4, 2, 4, 6, 4, 6, 8, 6, 8,11,&
  2, 3, 6, 4, 8, 9, 0, 0, 0, 0, 0, 0,&
  0, 2, 7, 6, 2, 7, 4, 8, 9, 0, 0, 0,&
  0, 1, 8, 1, 8, 9, 2, 3, 6, 0, 0, 0,&
  2, 6, 7, 2, 7, 9, 1, 2, 9, 7, 8, 9,&
  2, 3, 6, 4, 7,11, 4, 9,11, 0, 0, 0,&
  2, 6, 0, 0, 6, 9, 0, 9, 4, 6, 9,11,&
  1, 9,11, 1, 0,11, 0, 7,11, 2, 3, 6,&
  1, 9,11, 1, 2,11, 2, 6,11, 0, 0, 0,&
  1, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 1, 2, 5, 0, 0, 0, 0, 0, 0,&
  0, 2, 5, 0, 4, 5, 0, 0, 0, 0, 0, 0,&
  4, 5, 7, 5, 7, 2, 2, 7, 3, 0, 0, 0,&
  1, 2, 5, 7,11, 8, 0, 0, 0, 0, 0, 0,&
  0, 3,11, 0,11, 8, 1, 2, 5, 0, 0, 0,&
  0, 2, 5, 0, 4, 5, 7,11, 8, 0, 0, 0,&
  2, 3,11, 2,11, 4, 2, 4, 5, 4, 8,11,&
  1, 2, 5, 4, 8, 9, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 1, 2, 5, 4, 8, 9, 0, 0, 0,&
  0, 2, 8, 2, 8, 5, 5, 8, 9, 0, 0, 0,&
  3, 7, 2, 2, 7, 5, 5, 7, 8, 5, 8, 9,&
  4, 7,11, 4, 9,11, 1, 2, 5, 0, 0, 0,&
  1, 2, 5, 3, 9,11, 3, 9, 4, 3, 4, 0,&
  0, 2, 5, 0, 5,11, 5,11, 9, 0, 7,11,&
  3, 9,11, 3, 9, 5, 3, 5, 2, 0, 0, 0,&
  1, 3, 6, 1, 5, 6, 0, 0, 0, 0, 0, 0,&
  5, 6, 7, 5, 7, 0, 5, 0, 1, 0, 0, 0,&
  4, 5, 6, 4, 6, 3, 4, 3, 0, 0, 0, 0,&
  4, 5, 6, 4, 6, 7, 0, 0, 0, 0, 0, 0,&
  7, 8,11, 1, 3, 5, 3, 5, 6, 0, 0, 0,&
  1, 5, 6, 1, 6, 8, 1, 8, 0, 6, 8,11,&
  4, 5, 6, 4, 6, 3, 4, 3, 0, 7, 8,11,&
  4, 5, 6, 4, 6,11, 4, 8,11, 0, 0, 0,&
  4, 8, 9, 1, 3, 6, 1, 5, 6, 0, 0, 0,&
  5, 6, 7, 5, 7, 0, 5, 0, 1, 4, 8, 9,&
  0, 8, 9, 0, 6, 9, 9, 5, 6, 0, 6, 3,&
  5, 6, 7, 5, 7, 8, 5, 8, 9, 0, 0, 0,&
  1, 3, 5, 3, 5, 6, 4, 7, 9, 7, 9,11,&
  0, 1, 4, 5, 6, 9, 6, 9,11, 0, 0, 0,&
  0, 3, 7, 5, 6, 9, 6, 9,11, 0, 0, 0,&
  5, 6, 9, 6, 9,11, 0, 0, 0, 0, 0, 0,&
  6,10,11, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 6,10,11, 0, 0, 0, 0, 0, 0,&
  0, 1, 4, 6,10,11, 0, 0, 0, 0, 0, 0,&
  1, 3, 4, 3, 4, 7, 6,10,11, 0, 0, 0,&
  6, 7, 8, 6, 8,10, 0, 0, 0, 0, 0, 0,&
  0, 8,10, 0,10, 6, 0, 6, 3, 0, 0, 0,&
  6, 7, 8, 6, 8,10, 0, 1, 4, 0, 0, 0,&
  1, 3, 4, 3, 4,10, 3,10, 6, 4, 8,10,&
  4, 8, 9, 6,10,11, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 4, 8, 9, 6,10,11, 0, 0, 0,&
  0, 1, 8, 1, 8, 9, 6,10,11, 0, 0, 0,&
  1, 3, 9, 3, 9, 8, 3, 8, 7, 6,10,11,&
  4, 6, 7, 4, 6,10, 4,10, 9, 0, 0, 0,&
  0, 3, 4, 3, 4, 9, 3, 9, 6, 6, 9,10,&
  0, 1, 9, 0, 9, 6, 0, 6, 7, 6, 9,10,&
  1, 3, 9, 3, 9, 6, 6, 9,10, 0, 0, 0,&
  2, 3,10, 3,10,11, 0, 0, 0, 0, 0, 0,&
  0, 2,10, 0,10, 7, 7,10,11, 0, 0, 0,&
  2, 3,10, 3,10,11, 0, 1, 4, 0, 0, 0,&
  1, 4, 7, 1, 7,10, 7,10,11, 1,10, 2,&
  2, 8,10, 2, 8, 7, 2, 7, 3, 0, 0, 0,&
  0, 2, 8, 2, 8,10, 0, 0, 0, 0, 0, 0,&
  2, 8,10, 2, 8, 7, 2, 7, 3, 0, 1, 4,&
  2, 8,10, 2, 8, 4, 2, 4, 1, 0, 0, 0,&
  2, 3,10, 3,10,11, 4, 8, 9, 0, 0, 0,&
  0, 2,10, 0,10,11, 0,11, 7, 4, 8, 9,&
  2, 3,10, 3,10,11, 0, 1, 8, 1, 8, 9,&
  1, 2, 9, 2, 9,10, 7, 8,11, 0, 0, 0,&
  4, 9, 7, 7, 9, 2, 2, 9,10, 2, 3, 7,&
  0, 2,10, 0,10, 9, 0, 9, 4, 0, 0, 0,&
  0, 3, 7, 1, 2, 9, 2, 9,10, 0, 0, 0,&
  1, 2, 9, 2, 9,10, 0, 0, 0, 0, 0, 0,&
  1, 2, 5, 6,10,11, 0, 0, 0, 0, 0, 0,&
  1, 2, 5, 6,10,11, 0, 3, 7, 0, 0, 0,&
  0, 4, 5, 0, 5, 2, 6,10,11, 0, 0, 0,&
  4, 5, 7, 5, 7, 3, 5, 3, 2, 6,10,11,&
  1, 2, 5, 6, 7, 8, 6, 8,10, 0, 0, 0,&
  1, 2, 5, 0, 8,10, 0,10, 3, 3,10, 6,&
  0, 4, 5, 0, 5, 2, 6, 7, 8, 6, 8,10,&
  2, 3, 6, 4, 5, 8, 5, 8,10, 0, 0, 0,&
  1, 2, 5, 4, 8, 9, 6,10,11, 0, 0, 0,&
  0, 3, 7, 1, 2, 5, 4, 8, 9, 6,10,11,&
  0, 2, 8, 2, 8, 5, 5, 8, 9, 6,10,11,&
  2, 3, 6, 7, 8,11, 5, 9,10, 0, 0, 0,&
  4, 6, 7, 4, 6, 9, 6, 9,10, 1, 2, 5,&
  0, 1, 4, 5, 9,10, 2, 3, 6, 0, 0, 0,&
  0, 2, 7, 2, 7, 6, 5, 9,10, 0, 0, 0,&
  2, 3, 6, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  1, 3,11, 1,11,10, 1,10, 5, 0, 0, 0,&
  0, 1, 7, 1, 7, 5, 7, 5,11, 5,10,11,&
  0, 4, 5, 0, 5,11, 0, 3,11, 5,11,10,&
  4, 5, 7, 5, 7,10, 7,10,11, 0, 0, 0,&
  1, 5, 3, 3, 5, 8, 3, 8, 7, 5, 8,10,&
  0, 8,10, 0,10, 5, 0, 5, 1, 0, 0, 0,&
  0, 3, 7, 4, 5, 8, 5, 8,10, 0, 0, 0,&
  4, 5, 8, 5, 8,10, 0, 0, 0, 0, 0, 0,&
  4, 8, 9, 1, 3,11, 1,11,10, 1,10, 5,&
  0, 1, 4, 7, 8,11, 5, 9,10, 0, 0, 0,&
  0, 3, 8, 3, 8,11, 5, 9,10, 0, 0, 0,&
  7, 8,11, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  1, 3, 4, 3, 4, 7, 5, 9,10, 0, 0, 0,&
  0, 1, 4, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  5, 9,10, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  5, 9,10, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  0, 1, 4, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  1, 3, 4, 3, 4, 7, 5, 9,10, 0, 0, 0,&
  7, 8,11, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  0, 3, 8, 3, 8,11, 5, 9,10, 0, 0, 0,&
  0, 1, 4, 7, 8,11, 5, 9,10, 0, 0, 0,&
  4, 8, 9, 1, 3,11, 1,11,10, 1,10, 5,&
  4, 5, 8, 5, 8,10, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 4, 5, 8, 5, 8,10, 0, 0, 0,&
  0, 8,10, 0,10, 5, 0, 5, 1, 0, 0, 0,&
  1, 5, 3, 3, 5, 8, 3, 8, 7, 5, 8,10,&
  4, 5, 7, 5, 7,10, 7,10,11, 0, 0, 0,&
  0, 4, 5, 0, 5,11, 0, 3,11, 5,11,10,&
  0, 1, 7, 1, 7, 5, 7, 5,11, 5,10,11,&
  1, 3,11, 1,11,10, 1,10, 5, 0, 0, 0,&
  2, 3, 6, 5, 9,10, 0, 0, 0, 0, 0, 0,&
  0, 2, 7, 2, 7, 6, 5, 9,10, 0, 0, 0,&
  0, 1, 4, 5, 9,10, 2, 3, 6, 0, 0, 0,&
  4, 6, 7, 4, 6, 9, 6, 9,10, 1, 2, 5,&
  2, 3, 6, 7, 8,11, 5, 9,10, 0, 0, 0,&
  0, 2, 8, 2, 8, 5, 5, 8, 9, 6,10,11,&
  0, 3, 7, 1, 2, 5, 4, 8, 9, 6,10,11,&
  1, 2, 5, 4, 8, 9, 6,10,11, 0, 0, 0,&
  2, 3, 6, 4, 5, 8, 5, 8,10, 0, 0, 0,&
  0, 4, 5, 0, 5, 2, 6, 7, 8, 6, 8,10,&
  1, 2, 5, 0, 8,10, 0,10, 3, 3,10, 6,&
  1, 2, 5, 6, 7, 8, 6, 8,10, 0, 0, 0,&
  4, 5, 7, 5, 7, 3, 5, 3, 2, 6,10,11,&
  0, 4, 5, 0, 5, 2, 6,10,11, 0, 0, 0,&
  1, 2, 5, 6,10,11, 0, 3, 7, 0, 0, 0,&
  1, 2, 5, 6,10,11, 0, 0, 0, 0, 0, 0,&
  1, 2, 9, 2, 9,10, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 1, 2, 9, 2, 9,10, 0, 0, 0,&
  0, 2,10, 0,10, 9, 0, 9, 4, 0, 0, 0,&
  4, 9, 7, 7, 9, 2, 2, 9,10, 2, 3, 7,&
  1, 2, 9, 2, 9,10, 7, 8,11, 0, 0, 0,&
  2, 3,10, 3,10,11, 0, 1, 8, 1, 8, 9,&
  0, 2,10, 0,10,11, 0,11, 7, 4, 8, 9,&
  2, 3,10, 3,10,11, 4, 8, 9, 0, 0, 0,&
  2, 8,10, 2, 8, 4, 2, 4, 1, 0, 0, 0,&
  2, 8,10, 2, 8, 7, 2, 7, 3, 0, 1, 4,&
  0, 2, 8, 2, 8,10, 0, 0, 0, 0, 0, 0,&
  2, 8,10, 2, 8, 7, 2, 7, 3, 0, 0, 0,&
  1, 4, 7, 1, 7,10, 7,10,11, 1,10, 2,&
  2, 3,10, 3,10,11, 0, 1, 4, 0, 0, 0,&
  0, 2,10, 0,10, 7, 7,10,11, 0, 0, 0,&
  2, 3,10, 3,10,11, 0, 0, 0, 0, 0, 0,&
  1, 3, 9, 3, 9, 6, 6, 9,10, 0, 0, 0,&
  0, 1, 9, 0, 9, 6, 0, 6, 7, 6, 9,10,&
  0, 3, 4, 3, 4, 9, 3, 9, 6, 6, 9,10,&
  4, 6, 7, 4, 6,10, 4,10, 9, 0, 0, 0,&
  1, 3, 9, 3, 9, 8, 3, 8, 7, 6,10,11,&
  0, 1, 8, 1, 8, 9, 6,10,11, 0, 0, 0,&
  0, 3, 7, 4, 8, 9, 6,10,11, 0, 0, 0,&
  4, 8, 9, 6,10,11, 0, 0, 0, 0, 0, 0,&
  1, 3, 4, 3, 4,10, 3,10, 6, 4, 9,10,&
  6, 7, 8, 6, 8,10, 0, 1, 4, 0, 0, 0,&
  0, 8,10, 0,10, 6, 0, 6, 3, 0, 0, 0,&
  6, 7, 8, 6, 8,10, 0, 0, 0, 0, 0, 0,&
  1, 3, 4, 3, 4, 7, 6,10,11, 0, 0, 0,&
  0, 1, 4, 6,10,11, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 6,10,11, 0, 0, 0, 0, 0, 0,&
  6,10,11, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  5, 6, 9, 6, 9,11, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 5, 6, 9, 6, 9,11, 0, 0, 0,&
  0, 1, 4, 5, 6, 9, 6, 9,11, 0, 0, 0,&
  1, 3, 5, 3, 5, 6, 4, 7, 9, 7, 9,11,&
  5, 6, 7, 5, 7, 8, 5, 8, 9, 0, 0, 0,&
  0, 8, 9, 0, 6, 9, 9, 5, 6, 0, 6, 3,&
  5, 6, 7, 5, 7, 0, 5, 0, 1, 4, 8, 9,&
  4, 8, 9, 1, 3, 6, 1, 5, 6, 0, 0, 0,&
  4, 5, 6, 4, 6,11, 4, 8,11, 0, 0, 0,&
  4, 5, 6, 4, 6, 3, 4, 3, 0, 7, 8,11,&
  1, 5, 6, 1, 6, 8, 1, 8, 0, 6, 8,11,&
  7, 8,11, 1, 3, 5, 3, 5, 6, 0, 0, 0,&
  4, 5, 6, 4, 6, 7, 0, 0, 0, 0, 0, 0,&
  4, 5, 6, 4, 6, 3, 4, 3, 0, 0, 0, 0,&
  5, 6, 7, 5, 7, 0, 5, 0, 1, 0, 0, 0,&
  1, 3, 6, 1, 5, 6, 0, 0, 0, 0, 0, 0,&
  3, 9,11, 3, 9, 5, 3, 5, 2, 0, 0, 0,&
  0, 2, 5, 0, 5,11, 5,11, 9, 0, 7,11,&
  1, 2, 5, 3, 9,11, 3, 9, 4, 3, 4, 0,&
  4, 7,11, 4, 9,11, 1, 2, 5, 0, 0, 0,&
  3, 7, 2, 2, 7, 5, 5, 7, 8, 5, 8, 9,&
  0, 2, 8, 2, 8, 5, 5, 8, 9, 0, 0, 0,&
  0, 3, 7, 1, 2, 5, 4, 8, 9, 0, 0, 0,&
  1, 2, 5, 4, 8, 9, 0, 0, 0, 0, 0, 0,&
  2, 3,11, 2,11, 4, 2, 4, 5, 4, 8,11,&
  0, 2, 5, 0, 4, 5, 7,11, 8, 0, 0, 0,&
  0, 3,11, 0,11, 8, 1, 2, 5, 0, 0, 0,&
  1, 2, 5, 7,11, 8, 0, 0, 0, 0, 0, 0,&
  4, 5, 7, 5, 7, 2, 2, 7, 3, 0, 0, 0,&
  0, 2, 5, 0, 4, 5, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 1, 2, 5, 0, 0, 0, 0, 0, 0,&
  1, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  1, 9,11, 1, 2,11, 2, 6,11, 0, 0, 0,&
  1, 9,11, 1, 0,11, 0, 7,11, 2, 3, 6,&
  2, 6, 0, 0, 6, 9, 0, 9, 4, 6, 9,11,&
  2, 3, 6, 4, 7,11, 4, 9,11, 0, 0, 0,&
  2, 6, 7, 2, 7, 9, 1, 2, 9, 7, 8, 9,&
  0, 1, 8, 1, 8, 9, 2, 3, 6, 0, 0, 0,&
  0, 2, 7, 6, 2, 7, 4, 8, 9, 0, 0, 0,&
  2, 3, 6, 4, 8, 9, 0, 0, 0, 0, 0, 0,&
  1, 2, 4, 2, 4, 6, 4, 6, 8, 6, 8,11,&
  2, 3, 6, 7,11, 8, 0, 1, 4, 0, 0, 0,&
  0, 2, 8, 2, 8, 6, 8, 6,11, 0, 0, 0,&
  2, 3, 6, 7, 8,11, 0, 0, 0, 0, 0, 0,&
  4, 7, 6, 4, 6, 1, 1, 6, 2, 0, 0, 0,&
  2, 3, 6, 0, 1, 4, 0, 0, 0, 0, 0, 0,&
  0, 2, 7, 6, 2, 7, 0, 0, 0, 0, 0, 0,&
  2, 3, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  1, 9,11, 1, 3,11, 0, 0, 0, 0, 0, 0,&
  1, 9,11, 1, 0,11, 0, 7,11, 0, 0, 0,&
  9, 3,11, 0, 3, 9, 0, 9, 4, 0, 0, 0,&
  4, 7,11, 4, 9,11, 0, 0, 0, 0, 0, 0,&
  1, 3, 9, 3, 9, 8, 3, 7, 8, 0, 0, 0,&
  0, 1, 8, 1, 8, 9, 0, 0, 0, 0, 0, 0,&
  4, 8, 9, 0, 3, 7, 0, 0, 0, 0, 0, 0,&
  4, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  4, 8, 1, 8,11, 1, 1,11, 3, 0, 0, 0,&
  7,11, 8, 0, 1, 4, 0, 0, 0, 0, 0, 0,&
  0, 3,11, 0,11, 8, 0, 0, 0, 0, 0, 0,&
  7,11, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  3, 7, 4, 3, 4, 1, 0, 0, 0, 0, 0, 0,&
  0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 3, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0,&
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/),(/3,4,256/))


END MODULE iso_surf_lut
