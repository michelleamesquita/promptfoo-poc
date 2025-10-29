#!/bin/bash
# Script para instalar e configurar Promptfoo

set -e

cd "$(dirname "$0")"

echo "🔧 Instalando Promptfoo..."

# Verifica se Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado"
    echo "Instale com: brew install node"
    exit 1
fi

echo "✅ Node.js: $(node --version)"
echo "✅ NPM: $(npm --version)"

# Instala promptfoo globalmente
echo "📦 Instalando promptfoo via npm..."
npm install -g promptfoo

# Verifica instalação
if command -v promptfoo &> /dev/null; then
    echo "✅ Promptfoo instalado: $(promptfoo --version)"
else
    echo "❌ Erro na instalação do promptfoo"
    exit 1
fi

echo ""
echo "🎉 Instalação completa!"
echo ""
echo "Próximos passos:"
echo "  1. Inicie a API: python serve_pickle_server.py"
echo "  2. Execute os testes: promptfoo eval"
echo "  3. Veja resultados: promptfoo view"
echo ""

