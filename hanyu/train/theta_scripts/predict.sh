#!/bin/bash
#COBALT -t 180
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

ROOT='/lus/theta-fs0/projects/MSEMNeuro/hanyuli/gw_p105_full/mito/train'
CHECKPOINT=$ROOT'/checkpoints/gw_p105_mito_unet_dtu_2_pad_concat/model.ckpt-49012'
INPUT_VOLUME='/lus/theta-fs0/projects/connectomics_aesp/hanyuli/gw_p105/data_full/image_clahe'
OUTPUT_VOLUME=$ROOT'/outputs/full_v1'

START=`date +"%s"`
orterun -hostfile $COBALT_NODEFILE -n $PROCS -npernode $PPN singularity exec --nv -B /lus/theta-fs0 $IMG \
python /container/EM_mask/predict_precomputed.py \
	--input_volume=$INPUT_VOLUME\
	--input_offset='150,150,0' \
  --input_size='10060,11390,913' \
  --input_mip=1 \
  --output_volume=$OUTPUT_VOLUME \
  --model_name='models.unets.unet_dtu_2_pad_concat' \
  --model_args="{\"fov_size\": [782, 782, 50], \"num_classes\": 1}" \
  --model_checkpoint=$CHECKPOINT \
  --overlap 128,128,16 \
  --batch_size 1 \
  --image_mean 137 \
  --image_stddev 66 \
  --use_gpu 0,1,2,3,4,5,6,7 \
  --alsologtostderr
