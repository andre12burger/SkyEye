#!/bin/bash

# Script já assume que você está no ambiente skyeye_env
# Se não estiver, execute: conda activate skyeye_env

# ===== CONFIGURAÇÃO WEIGHTS & BIASES =====
# Descomente e configure sua API key do W&B para monitoramento remoto
# export WANDB_API_KEY="sua_api_key_aqui"
# wandb login --relogin $WANDB_API_KEY

# ===== CHECKPOINT =====
# Usando o checkpoint MAIS AVANÇADO (epoch 16 - 85% completo!)
CHECKPOINT="/home/pdi-05/Documentos/automni/SkyEye/experiments/skyeye_fv_train_SkyEye_FV_Run_resume_20251119_145637/saved_models/model_latest.pth"

echo "========================================="
echo "Resumindo treinamento de: $CHECKPOINT"
echo "Progresso atual: Epoch 17/20 (85% completo)"
echo "Best mIoU: 0.6535 (melhor até agora!)"
echo "FALTAM APENAS 3 EPOCHS!"
echo "W&B habilitado para monitoramento remoto"
echo "========================================="

CUDA_VISIBLE_DEVICES="0" \
OMP_NUM_THREADS=4 \
/home/pdi-05/anaconda3/envs/skyeye_env/bin/python -m torch.distributed.run \
                            --nproc_per_node=1 \
                            --master_addr=127.0.0.1 \
                            --master_port=29501 \
                            train_fv.py \
                            --run_name="SkyEye_FV_Run_resume_$(date +%Y%m%d_%H%M%S)" \
                            --project_root_dir="/home/pdi-05/Documentos/automni/SkyEye" \
                            --seam_root_dir="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523/DATASETS/automni/kitti360_bev/kitti360_skyeye_release" \
                            --dataset_root_dir="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523/DATASETS/automni/kitti360_original" \
                            --mode=train \
                            --defaults_config=kitti_defaults.ini \
                            --config=kitti_fv.ini \
                            --use_wandb=True \
                            --resume="$CHECKPOINT" \
                            --comment="Resume epoch 7-20 com W&B monitoring";