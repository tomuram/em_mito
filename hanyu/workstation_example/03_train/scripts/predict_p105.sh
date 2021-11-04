#!/bin/bash
ROOT_PATH='/home/hanyu/hl_p14/mito/training'
CHECKPOINT='/home/hanyu/hl_p14/mito/training/checkpoints/hl007_mito_unet_dtu_2_pad_concat_v2/model.ckpt-10000'
#INPUT_VOLUME='/home/hanyu/ng/HL007/image_v3_clahe'
INPUT_VOLUME='/home/hanyu/ng/gw_p105/precom/image_clahe'
OUTPUT_VOLUME=$ROOT_PATH'/outputs/test_p105_v1'

mpirun -np 2 \
    python /home/hanyu/workspace/EM_mask/predict_precomputed.py \
    --input_volume=$INPUT_VOLUME \
    --input_offset='2000,2000,0' \
    --input_size='1024,1024,256' \
    --input_mip=1 \
    --output_volume=$OUTPUT_VOLUME \
    --model_name='models.unets.unet_dtu_2_pad_concat' \
    --model_args="{\"fov_size\": [512, 512, 36], \"num_classes\": 1}" \
    --model_checkpoint=$CHECKPOINT \
    --overlap 64,64,8 \
    --batch_size 2 \
    --image_mean 137 \
    --image_stddev 66 \
    --use_gpu 0,1 \
    --alsologtostderr
