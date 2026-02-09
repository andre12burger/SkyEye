# 🔧 Configuração do Weights & Biases (W&B)

## Por que usar W&B?
- ✅ Monitoramento em tempo real do treinamento (de qualquer lugar)
- ✅ Gráficos de loss, accuracy, mIoU automáticos
- ✅ Comparação entre diferentes runs
- ✅ Alertas por email quando treinamento para/completa
- ✅ Salvamento automático de logs e métricas

## Passo a Passo

### 1. Criar conta no W&B (se não tiver)
Acesse: https://wandb.ai/signup

### 2. Obter sua API Key
1. Login em https://wandb.ai
2. Vá em: https://wandb.ai/authorize
3. Copie sua API key

### 3. Fazer login no terminal

```bash
# Ativar ambiente
conda activate skyeye_env

# Login no W&B (cole a API key quando solicitado)
wandb login
```

**OU** adicione direto no script:

```bash
# Editar train_fv_kitti.sh
nano scripts/train_fv_kitti.sh

# Descomentar e adicionar sua key:
export WANDB_API_KEY="sua_api_key_aqui"
wandb login --relogin $WANDB_API_KEY
```

### 4. Executar o treinamento

```bash
cd /home/pdi-05/Documentos/automni/SkyEye/scripts

# Montar dataset
bash mount_dataset.sh

# Iniciar treinamento com W&B
bash train_fv_kitti.sh
```

### 5. Monitorar o treinamento

Após iniciar, o W&B mostrará um link no terminal:
```
wandb: 🚀 View run at https://wandb.ai/seu-usuario/po_bev_unsupervised/runs/xxxxx
```

Abra esse link no navegador para acompanhar em tempo real!

## 📊 Métricas Monitoradas

O SkyEye envia automaticamente para o W&B:

**Durante treinamento:**
- Loss (total, fv_sem_loss, bev_sem_loss)
- Learning rate
- Batch time / Data time
- Confusion matrix do FV

**Durante validação:**
- FV Semantic mIoU (por classe e média)
- Visualizações de predições
- Confusion matrix

## 🔔 Configurar Alertas (Opcional)

No W&B dashboard:
1. Clique no seu run
2. "Settings" > "Alerts"
3. Configure alertas para:
   - Run terminou
   - Métrica atingiu threshold
   - Run crashou

## 💡 Dicas

- O projeto W&B se chama `po_bev_unsupervised` (definido no código)
- Cada run terá nome `skyeye_fv_train_{timestamp}`
- Todos os runs ficam salvos online (pode deletar runs antigos depois)
- Modo offline: se não fizer login, W&B salva localmente e pode sincronizar depois

## 🚫 Se Preferir Desabilitar W&B

Edite o script e mude:
```bash
--use_wandb=False
```

Os logs continuarão sendo salvos em TensorBoard localmente.
