#!/bin/bash
# Script para instalar modelscan em ambiente isolado

set -e

cd "$(dirname "$0")"

echo "🔧 Detectando Python adequado..."

# Tenta encontrar Python 3.10+
if command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
elif command -v python3.11 &> /dev/null; then
    PYTHON_CMD="python3.11"
elif command -v python3.10 &> /dev/null; then
    PYTHON_CMD="python3.10"
else
    echo "❌ Python 3.10+ não encontrado"
    echo "Instale com: brew install python@3.10"
    exit 1
fi

echo "✅ Usando: $($PYTHON_CMD --version)"

echo "🔧 Criando ambiente virtual para modelscan..."

# Remove venv antigo se existir
rm -rf .venv-modelscan

# Cria venv
$PYTHON_CMD -m venv .venv-modelscan

# Ativa o venv
source .venv-modelscan/bin/activate

echo "📦 Instalando dependências..."

# Instala NumPy<2 primeiro (requisito do TensorFlow antigo)
pip install --upgrade pip
pip install "numpy<2"

# Instala modelscan (que vai puxar TensorFlow compatível)
pip install modelscan

echo ""
echo "✅ Instalação completa!"
echo ""
echo "Para usar o modelscan:"
echo "  source .venv-modelscan/bin/activate"
echo "  modelscan -p ./sentiment_model.pkl"
echo ""
echo "Para sair do ambiente:"
echo "  deactivate"

