#!/bin/bash
hpn.io.img_to_cloudvolume_v2 \
  --image_dir "/media/Nova/data_vandana/EM/Alz_Hypoxia/VS1073_Hippocampus_Control/Plaque_1/Aligntk/aligned" \
  --output_dir "/media/PubNova/neuroglancer/VS1073_Plaque1/image" \
  --resolution "10,10,40" \
  --mip 0 \
  --chunk_size 128,128,64 \
  --flip_xy \
