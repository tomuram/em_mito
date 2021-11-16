#!/bin/bash
#COBALT -t 180
#COBALT -n 1
#COBALT -q full-node
#COBALT -A MSEMNeuro

NODES=`cat $COBALT_NODEFILE | wc -l`
MIG=1
GPU=8
PPN=$((GPU * MIG))
PROCS=$((NODES * PPN))

ROOT='/eagle/BrainImagingML/turam/vs_mito/1073/train/theta_scripts'
# Update this checkpoint to the most recent or best-performing model
# in your checkpoints dir
CHECKPOINT=$ROOT'/checkpoints/model.ckpt-41191'
INPUT_VOLUME='/eagle/BrainImagingML/turam/vs_mito/1073/VS1073_Plaque1/image/'

module load conda/tensorflow
# Update this conda environment if you're using your own
conda activate /eagle/connectomics_aesp/software/env/thetagpu/conda_em_mask

orterun -hostfile $COBALT_NODEFILE -n $PROCS -npernode $PPN \
  python ~/dev/connectomics_aesp/EM_mask/predict_precomputed.py \
	--input_volume=$INPUT_VOLUME\
	--input_offset='150,150,0' \
  --input_size='10060,11390,913' \
  --input_mip=1 \
  --output_volume=${ROOT}/output \
  --model_name='models.unets.unet_dtu_2_pad_concat' \
  --model_args="{\"fov_size\":[782,782,50],\"num_classes\":1}" \
  --model_checkpoint=$CHECKPOINT \
  --overlap 128,128,16 \
  --batch_size 1 \
  --image_mean 137 \
  --image_stddev 66 \
  --use_gpu 0,1,2,3,4,5,6,7 \
  --alsologtostderr
