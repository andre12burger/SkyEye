#!/bin/bash
################################################################################
# Script Master para Retomar Treinamento SkyEye FV
# 
# Execute simplesmente: bash run_training.sh
# Não precisa ativar ambiente, mudar diretório ou montar disco manualmente
################################################################################

set -e  # Para se houver erro

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOUNT_POINT="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523"
CONDA_ENV="skyeye_env"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     TREINAMENTO SKYEYE FV - RESUMO AUTOMÁTICO             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# 1. Verificar/Montar disco
echo "📀 [1/4] Verificando disco de datasets..."
if mountpoint -q "$MOUNT_POINT"; then
    echo "    ✅ Disco já montado"
else
    echo "    🔄 Montando disco..."
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount /dev/sdb1 "$MOUNT_POINT"
    
    if mountpoint -q "$MOUNT_POINT"; then
        echo "    ✅ Disco montado com sucesso"
    else
        echo "    ❌ ERRO ao montar disco"
        exit 1
    fi
fi

# Verificar metadados
METADATA_FILE="$MOUNT_POINT/DATASETS/automni/kitti360_bev/kitti360_skyeye_release/metadata_ortho.bin"
if [ -f "$METADATA_FILE" ]; then
    echo "    ✅ Metadados encontrados"
else
    echo "    ❌ ERRO: Metadados não encontrados em $METADATA_FILE"
    exit 1
fi

# 2. Verificar ambiente conda
echo ""
echo "🐍 [2/4] Configurando ambiente Python..."
eval "$(conda shell.bash hook)"
conda activate "$CONDA_ENV"
if [ $? -eq 0 ]; then
    echo "    ✅ Ambiente $CONDA_ENV ativado"
else
    echo "    ❌ ERRO ao ativar ambiente $CONDA_ENV"
    exit 1
fi

# 3. Verificar checkpoint
echo ""
echo "💾 [3/4] Verificando checkpoint de treinamento..."
# Usar SEMPRE o checkpoint mais avançado (epoch 16)
CHECKPOINT="$SCRIPT_DIR/experiments/skyeye_fv_train_SkyEye_FV_Run_resume_20251119_145637/saved_models/model_latest.pth"

if [ ! -f "$CHECKPOINT" ]; then
    # Fallback: procurar qualquer checkpoint disponível
    CHECKPOINT=$(find "$SCRIPT_DIR/experiments/skyeye_fv_train_SkyEye_FV_Run"* -name "model_latest.pth" -type f 2>/dev/null | head -1)
fi

if [ -f "$CHECKPOINT" ]; then
    echo "    ✅ Checkpoint encontrado:"
    echo "       $CHECKPOINT"
    
    # Mostrar info do checkpoint
    python3 -c "
import torch
cp = torch.load('$CHECKPOINT', map_location='cpu')
epoch = cp['training_meta']['epoch']
best = cp['training_meta']['best_score']
print(f'       Epoch: {epoch}/19 | Best mIoU: {best:.4f}')
print(f'       Progresso: {((epoch + 1) / 20 * 100):.1f}% completo')
" 2>/dev/null || echo "       (Não foi possível ler detalhes)"
else
    echo "    ❌ ERRO: Nenhum checkpoint encontrado"
    exit 1
fi

# 4. Iniciar treinamento
echo ""
echo "🚀 [4/4] Iniciando treinamento..."
echo "    📊 Monitor W&B: https://wandb.ai/andre12burger-universidade-federal-do-rio-grande-furg/skyeye_fv_training"
echo "    ⏱️  Tempo estimado: ~13 epochs restantes (várias horas)"
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Pressione Ctrl+C para interromper (checkpoint será salvo)║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
sleep 3

cd "$SCRIPT_DIR/scripts"
bash train_fv_kitti.sh

# Ao finalizar
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              TREINAMENTO FINALIZADO!                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
