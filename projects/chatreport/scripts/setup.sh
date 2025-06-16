#!/bin/bash

echo "🚀 ChatReport開発環境セットアップ"

# 環境変数ファイルコピー
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ .envファイルを作成しました"
    echo "📝 .envファイルを編集して環境変数を設定してください"
fi

# フロントエンド依存関係インストール
if [ -d "frontend" ]; then
    echo "📦 フロントエンド依存関係をインストール中..."
    cd frontend && npm install && cd ..
fi

# バックエンド依存関係インストール
if [ -d "backend" ]; then
    echo "🐍 バックエンド依存関係をインストール中..."
    cd backend && pip install -r requirements.txt && cd ..
fi

echo "✨ セットアップ完了！"
echo "📚 詳細は README.md をご確認ください"
