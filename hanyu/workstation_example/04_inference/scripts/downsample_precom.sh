#!/bin/bash

#mpirun -n 8 hpn.io.add_mip \
#  "../data/image/image/" \
#  --max_mip 6 \
#  --mode "image" \

mpirun -n 8 hpn.io.add_mip \
  "/media/PubNova/neuroglancer/gw_p105/precom/image_clahe" \
  --max_mip 6 \
  --mode "image" \
