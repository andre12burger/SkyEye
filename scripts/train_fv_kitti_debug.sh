#!/bin/bash

# Versão debug: sem launcher distribuído, força --debug True para evitar init do NCCL.
# Usa mesmo checkpoint e paths; imprime os [DEBUG] do dataset antes de falhar se o caminho estiver errado.
# Execute: bash scripts/train_fv_kitti_debug.sh

python train_fv.py \
  --run_name="SkyEye_FV_Debug_$(date +%Y%m%d_%H%M%S)" \
  --project_root_dir="/home/pdi-05/Documentos/automni/SkyEye" \
  --seam_root_dir="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523/DATASETS/automni/kitti360_bev/kitti360_skyeye_release" \
  --dataset_root_dir="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523/DATASETS/automni/kitti360_original" \
  --mode=train \
  --defaults_config=kitti_defaults.ini \
  --config=kitti_fv.ini \
  --use_wandb=False \
  --resume="/home/pdi-05/Documentos/automni/SkyEye/experiments/skyeye_fv_train_SkyEye_FV_Run_resume_20251110_144252/saved_models/model_latest.pth" \
  --comment="Debug dataset path" \
  --debug True

# Após rodar, capture as primeiras linhas com [DEBUG] e me envie.
