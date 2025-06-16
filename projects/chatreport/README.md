# ChatReport - AI-Powered Chat Analytics Platform

## 🎯 概要
チャットログを自動要約し、インサイトフルなレポートを生成するWebサービス

## 🚀 クイックスタート
```bash
# リポジトリクローン
git clone https://github.com/your-org/chatreport.git
cd chatreport

# 開発環境セットアップ
./scripts/setup.sh

# フロントエンド起動
cd frontend && npm run dev

# バックエンド起動
cd backend && uvicorn main:app --reload



### 5. GitHub設定ファイル作成
```bash
# Issue テンプレート作成
cat > projects/chatreport/.github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: 🐛 Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: ['bug', 'needs-triage']
assignees: ''
---

**🐛 Bug Description**
A clear and concise description of what the bug is.

**📋 Steps to Reproduce**
1. Go to '...'
2. Click on '....'
3. See error

**✅ Expected Behavior**
What you expected to happen.

**📸 Screenshots**
If applicable, add screenshots.

**💻 Environment**
- OS: [e.g. macOS, Windows]
- Browser: [e.g. chrome, safari]
- Version: [e.g. 22]
