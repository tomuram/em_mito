#!/bin/bash
ROOT_PATH='/media/Nova/data_vandana/mitochondria/1073/03_train'
horovodrun -np 2 -H localhost:2 \
    python /home/hanyu/workspace/EM_mask/train.py \
    --data_volumes='mito:'$ROOT_PATH'/train.h5:image' \
    --label_volumes='mito:'$ROOT_PATH'/train.h5:mito_signed' \
    --tf_coords=$ROOT_PATH'/tf_coord_files_v1/tf_coord_file' \
    --train_dir=$ROOT_PATH'/checkpoints/gw_p105_mito_unet_dtu_2_pad_concat' \
    --model_name models.unets.unet_dtu_2_pad_concat \
    --model_args "{\"fov_size\": [161, 161, 14], \"num_classes\": 1, \"label_size\": [161, 161, 14]}" \
    --learning_rate 0.0001 \
    --batch_size 2 \
    --image_mean 137 \
    --image_stddev 66 \
    --rotation \
    --max_steps 20000 \
