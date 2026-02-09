#!/bin/bash
# Script para montar o disco de datasets antes do treinamento

MOUNT_POINT="/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523"

if mountpoint -q "$MOUNT_POINT"; then
    echo "✅ Disco já montado em $MOUNT_POINT"
else
    echo "🔄 Montando disco..."
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount /dev/sdb1 "$MOUNT_POINT"
    
    if mountpoint -q "$MOUNT_POINT"; then
        echo "✅ Disco montado com sucesso!"
    else
        echo "❌ Erro ao montar disco"
        exit 1
    fi
fi

# Verificar se os metadados existem
if [ -f "$MOUNT_POINT/DATASETS/automni/kitti360_bev/kitti360_skyeye_release/metadata_ortho.bin" ]; then
    echo "✅ Metadados encontrados"
else
    echo "❌ Metadados não encontrados. Verifique o caminho."
    exit 1
fi
