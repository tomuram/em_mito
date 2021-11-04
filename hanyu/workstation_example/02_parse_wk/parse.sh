#!/bin/bash

hpn.io.wkw_to_h5 \
  "./VS1073_Plaque1.zip" \
  "/media/PubNova/webknossos/kasthuri_lab/VS1073_plaque1" \
  --output_path "./parsed.h5" \
  --resolution 10,10,40 \
  --flip_xy
  #--bootstrap \
