#!/bin/bash

echo "🔐 GitHub Authentication Setup"
echo "=============================="
echo ""
echo "GitHub tidak lagi mendukung password authentication."
echo "Kamu perlu menggunakan Personal Access Token."
echo ""
echo "📋 Langkah-langkah:"
echo "1. Buka: https://github.com/settings/tokens"
echo "2. Klik 'Generate new token' → 'Generate new token (classic)'"
echo "3. Beri nama: 'Linux Web UI Management'"
echo "4. Pilih scope: 'repo' (full control of private repositories)"
echo "5. Klik 'Generate token'"
echo "6. Copy token yang dihasilkan"
echo ""
echo "⚠️  PENTING: Token hanya ditampilkan sekali!"
echo ""

read -p "Masukkan Personal Access Token: " -s GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Token tidak boleh kosong!"
    exit 1
fi

echo "🔧 Setting up Git credentials..."

# Update remote URL dengan token
git remote set-url origin https://${GITHUB_TOKEN}@github.com/arulriyadi/linux-web-ui-mgmt.git

echo "✅ Git credentials updated!"
echo ""
echo "🚀 Sekarang coba push:"
echo "git push -u origin master"
echo ""
echo "💡 Tips: Token akan tersimpan di .git/config"
echo "   Untuk keamanan, setelah push berhasil, kamu bisa:"
echo "   git remote set-url origin https://github.com/arulriyadi/linux-web-ui-mgmt.git"
