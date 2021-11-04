#!/bin/bash
#COBALT -t 60
#COBALT -n 1
#COBALT -q full-node
#COBALT -A MSEMNeuro

MPIPATH=/usr/mpi/gcc/openmpi-4.0.3rc4

export LD_LIBRARY_PATH=$MPIPATH/lib:$LD_LIBRARY_PATH
export PATH=$MPIPATH/bin:$PATH
echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
echo PATH=$PATH

NODES=`cat $COBALT_NODEFILE | wc -l`
MIG=1
GPU=8
PPN=$((GPU * MIG))
PROCS=$((NODES * PPN))

IMG='/lus/theta-fs0/projects/MSEMNeuro/hanyuli/singularity/theta_gpu_v8.simg'


ROOT_PATH_1='/lus/theta-fs0/projects/MSEMNeuro/hanyuli/vs_mito/1073/train'
DATA_VOLUME='mito:'$ROOT_PATH_1'/train.h5:image'
LABEL_VOLUME='mito:'$ROOT_PATH_1'/train.h5:mito_signed'

START=`date +"%s"`
orterun -hostfile $COBALT_NODEFILE -n $PROCS -npernode $PPN singularity exec --nv -B /lus/theta-fs0 $IMG \
  python /container/EM_mask/train.py \
    --data_volumes=$DATA_VOLUME \
    --label_volumes=$LABEL_VOLUME \
    --tf_coords=$ROOT_PATH_1'/tf_coord_files_v1/tf_coord_file' \
    --train_dir=$ROOT_PATH_1'/checkpoints/gw_p105_mito_unet_dtu_2_pad_concat' \
    --model_name models.unets.unet_dtu_2_pad_concat \
    --model_args "{\"fov_size\": [161, 161, 14], \"num_classes\": 1, \"label_size\": [161, 161, 14]}" \
    --learning_rate 0.0001 \
    --batch_size 8 \
    --image_mean 137 \
    --image_stddev 66 \
    --rotation \
    --max_steps 120000 \
    #--model_args "{\"fov_size\": [135, 135, 12], \"num_classes\": 1, \"label_size\": [135, 135, 12]}" \
    # --model_args "{\"fov_size\": [135, 135, 24], \"num_classes\": 1, \"label_size\": [135, 135, 24]}" \
