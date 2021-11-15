#!/bin/bash -l
#COBALT -t 60
#COBALT -n 1
#COBALT -q full-node
#COBALT -A MSEMNeuro

NODES=`cat $COBALT_NODEFILE | wc -l`
MIG=1
GPU=8
PPN=$((GPU * MIG))
PROCS=$((NODES * PPN))

ROOT='/lus/theta-fs0/projects/MSEMNeuro/hanyuli/vs_mito/1073/train'
DATA_VOLUME='mito:'$ROOT'/train.h5:image'
LABEL_VOLUME='mito:'$ROOT'/train.h5:mito_signed'

START=`date +"%s"`
module load conda/tensorflow
# Update this conda environment if you're using your own
conda activate /eagle/connectomics_aesp/software/env/thetagpu/conda_em_mask
mpirun -mca pml ob1 -hostfile $COBALT_NODEFILE -n $PROCS -npernode $PPN \
 python ~/dev/connectomics_aesp/EM_mask/train.py \
    --data_volumes=$DATA_VOLUME \
    --label_volumes=$LABEL_VOLUME \
    --tf_coords=$ROOT'/tf_coord_files_v1/tf_coord_file' \
    --train_dir=$ROOT'/checkpoints \
    --model_name models.unets.unet_dtu_2_pad_concat \
    --model_args "{\"fov_size\":[161,161,14],\"num_classes\":1,\"label_size\":[161,161,14]}" \
    --learning_rate 0.0001 \
    --batch_size 8 \
    --image_mean 137 \
    --image_stddev 66 \
    --rotation \
    --max_steps 120000 \
