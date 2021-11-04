#!/bin/bash
ROOT_PATH='/media/Nova/data_vandana/mitochondria/1073/02_train'

mpirun -n 40 python /home/hanyu/workspace/EM_mask/em_mask/tools/gen_coords.py \
  --in_path='mito:'$ROOT_PATH'/train.h5:label' \
  --out_path=$ROOT_PATH'/tf_coord_files_v1/tf_coord_file' \
  --lom_radius=6,12,12 \
  --margin=7,81,81 \
  --n_samples=4000000 \
  --true_ratio=0.8
