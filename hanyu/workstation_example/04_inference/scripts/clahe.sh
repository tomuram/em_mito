#!/bin/bash
mpirun -n 8 hpn.io.clahe_volume \
  "/media/PubNova/neuroglancer/gw_p105/precom/image/" \
  "/media/PubNova/neuroglancer/gw_p105/precom/image_clahe/" \
  --verbose

