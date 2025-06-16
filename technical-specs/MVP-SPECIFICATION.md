# MVP仕様書 - 個人事業主向け営業文書AI

## 🎯 MVP概要

### プロダクト名
**BizMate AI** - 個人事業主の営業パートナー

### 価値提案
「個人事業主でも大企業並みの営業文書が、親しみやすく簡単に作れる」

### MVP範囲
最小限の機能で価値を提供し、ユーザーフィードバックを収集する

## 👥 ターゲットユーザー

### プライマリペルソナ: 田中さん（45歳、建設業個人事業主）
```yaml
基本情報:
  - 年齢: 45歳
  - 職業: 建設業個人事業主（リフォーム専門）
  - 年収: 400万円
  - 地域: 地方都市

ペインポイント:
  - 営業メールを書くのに毎回30分かかる
  - 適切な敬語・表現が分からない
  - 見積書・提案書作成が苦手
  - お客様との継続的な関係作りが難しい

目標:
  - 営業文書作成時間を1/3に短縮
  - お客様に失礼のない文章を書きたい
  - リピート客を増やしたい
  - 月1-2件の新規受注獲得
```

### セカンダリペルソナ: 佐藤さん（38歳、美容院経営）
```yaml
基本情報:
  - 年齢: 38歳
  - 職業: 美容院経営（従業員3名）
  - 年収: 600万円
  - 地域: 地方都市

ペインポイント:
  - 新規顧客獲得のアプローチ方法
  - 季節に応じたDM・メール作成
  - 既存客へのフォローアップ
  - 同業他店との差別化

目標:
  - 月10名の新規顧客獲得
  - 既存客の来店頻度向上
  - 地域での認知度アップ
  - 売上20%向上
```

## 🎨 ユーザーストーリー

### エピック1: 営業メール作成
```yaml
As a 個人事業主
I want to 親しみやすい営業メールを簡単に作成したい
So that お客様との良好な関係を築ける

User Stories:
  - 顧客名と業種を入力するだけでメールが生成される
  - 季節の挨拶が自動で入る
  - 地域性を考慮した表現になる
  - 丁寧だが親しみやすい文体になる
  - 生成されたメールを編集できる
```

### エピック2: テンプレート管理
```yaml
As a 個人事業主
I want to よく使う文書パターンを保存・再利用したい
So that 作業効率を向上させる

User Stories:
  - 生成した文書をテンプレートとして保存できる
  - 保存したテンプレートを一覧で確認できる
  - テンプレートを選択して再利用できる
  - テンプレートを編集・削除できる
  - 業種別にテンプレートを分類できる
```

### エピック3: ユーザー管理
```yaml
As a 個人事業主
I want to 自分の情報を登録・管理したい
So that 個人に最適化されたサービスを受けられる

User Stories:
  - メールアドレスで簡単にアカウント作成できる
  - 事業の基本情報（業種、地域等）を登録できる
  - 利用プランを選択・変更できる
  - 使用履歴を確認できる
  - アカウント情報を編集できる
```

## 🔧 機能仕様

### 1. 営業メール生成機能
```yaml
入力項目:
  - 顧客名（必須）
  - 自社の業種（必須）
  - メールの目的（必須）
  - 地域（任意）
  - 既存関係（新規/既存）

出力:
  - 200-300文字の営業メール
  - 季節の挨拶付き
  - 業種に適した表現
  - 地域性を考慮した内容

処理フロー:
  1. 入力値検証
  2. プロンプト生成
  3. OpenAI API呼び出し
  4. 応答内容の整形
  5. 結果表示・編集可能状態
```

### 2. 簡易提案書作成機能
```yaml
入力項目:
  - 顧客名・会社名
  - 提案内容・サービス概要
  - 価格・期間
  - 特徴・メリット

出力:
  - A4 1枚の提案書
  - 親しみやすいデザイン
  - 必要最小限の情報
  - PDF出力対応

テンプレート:
  - 建設・リフォーム用
  - 美容・理容用
  - 飲食店用
  - 小売店用
  - コンサルティング用
```

### 3. ユーザー管理機能
```yaml
認証:
  - メール認証
  - パスワードリセット
  - ソーシャルログイン（Google）

プロフィール:
  - 基本情報（名前、メール）
  - 事業情報（業種、地域、規模）
  - 利用設定（デフォルト地域等）

利用状況:
  - 月間生成回数
  - 残り利用可能回数
  - 利用履歴（直近10件）
```

### 4. サブスクリプション管理
```yaml
プラン:
  - フリープラン（月10回まで）
  - ベーシックプラン（月50回、1,000円）
  - プレミアムプラン（無制限、3,000円）

決済:
  - Stripe連携
  - クレジットカード決済
  - 月額自動課金
  - 請求書発行
```

## 🎨 UI/UX設計

### デザインコンセプト
```yaml
キーワード:
  - 親しみやすい
  - 温かみのある
  - シンプル
  - 使いやすい

カラーパレット:
  - メインカラー: 温かいオレンジ (#FF8A65)
  - サブカラー: やわらかいブルー (#64B5F6)
  - アクセント: 優しいグリーン (#81C784)
  - ベース: 白 (#FFFFFF)、薄いグレー (#F5F5F5)

フォント:
  - メイン: Noto Sans JP
  - アクセント: Klee One（手書き風）
```

### 主要画面設計

#### 1. ホーム画面
```yaml
レイアウト:
  - ヘッダー: ロゴ、ナビゲーション、ログイン状態
  - ヒーロー: キャッチコピー、機能説明、CTA
  - 機能紹介: 3つの主要機能をカード形式
  - 料金プラン: 3プラン比較表
  - フッター: 企業情報、利用規約等

CTA:
  - 「無料で始める」（目立つボタン）
  - 「まずは試してみる」（サブボタン）
```

#### 2. メール生成画面
```yaml
レイアウト:
  - 左側: 入力フォーム
    * 顧客名入力
    * 業種選択（ドロップダウン）
    * 目的入力（テキストエリア）
    * 地域選択（任意）
  - 右側: 生成結果
    * 生成されたメール表示
    * 編集可能テキストエリア
    * コピー・保存ボタン

UX配慮:
  - リアルタイム文字数カウント
  - 生成中のローディング表示
  - エラー時の分かりやすいメッセージ
```

#### 3. マイページ
```yaml
レイアウト:
  - サイドバー: ナビゲーション
  - メインエリア: 利用状況、履歴、設定

機能:
  - 今月の利用状況（プログレスバー）
  - 生成履歴（直近10件）
  - 保存テンプレート一覧
  - アカウント設定
  - プラン変更
```

## 🛠️ 技術仕様

### アーキテクチャ
```yaml
Frontend:
  - Vue.js 3 (Composition API)
  - Tailwind CSS + DaisyUI
  - Vite (ビルドツール)
  - Pinia (状態管理)

Backend:
  - Node.js + Express
  - Prisma ORM
  - PostgreSQL
  - Redis (セッション管理)

External APIs:
  - OpenAI GPT-3.5-turbo
  - Stripe (決済)
  - SendGrid (メール送信)

Infrastructure:
  - Frontend: Netlify
  - Backend: Railway
  - Database: Railway PostgreSQL
  - Cache: Railway Redis
```

### データベース設計
```sql
-- Users テーブル
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    business_type VARCHAR(50),
    region VARCHAR(50),
    plan_type VARCHAR(20) DEFAULT 'free',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Subscriptions テーブル
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    started_at TIMESTAMP,
    ends_at TIMESTAMP,
    stripe_subscription_id VARCHAR(255)
);

-- Generated Contents テーブル
CREATE TABLE generated_contents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content_type VARCHAR(50) NOT NULL,
    input_data JSONB NOT NULL,
    generated_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Templates テーブル
CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    template_data JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Usage Logs テーブル
CREATE TABLE usage_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    action_type VARCHAR(50) NOT NULL,
    tokens_used INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### API設計
```yaml
Authentication:
  POST /api/auth/register - ユーザー登録
  POST /api/auth/login - ログイン
  POST /api/auth/logout - ログアウト
  GET /api/auth/me - 現在のユーザー情報

Content Generation:
  POST /api/generate/email - メール生成
  POST /api/generate/proposal - 提案書生成
  GET /api/generate/history - 生成履歴

Templates:
  GET /api/templates - テンプレート一覧
  POST /api/templates - テンプレート作成
  PUT /api/templates/:id - テンプレート更新
  DELETE /api/templates/:id - テンプレート削除

Subscription:
  GET /api/subscription - サブスクリプション情報
  POST /api/subscription/checkout - 決済開始
  POST /api/subscription/cancel - 解約

Usage:
  GET /api/usage/current - 当月利用状況
  GET /api/usage/history - 利用履歴
```

## 📊 成功指標

### ユーザー獲得指標
```yaml
登録関連:
  - 月間新規登録数: 100名
  - 登録完了率: 80%
  - 有料転換率: 15%

エンゲージメント:
  - 月間アクティブユーザー: 70%
  - 機能利用率: 60%
  - セッション時間: 5分以上
```

### 機能利用指標
```yaml
メール生成:
  - 生成成功率: 95%
  - 生成時間: 5秒以内
  - 編集率: 30%
  - 満足度: 4.0/5.0

テンプレート:
  - 保存率: 20%
  - 再利用率: 40%
  - テンプレート数/ユーザー: 3個
```

### ビジネス指標
```yaml
収益:
  - 月次経常収益(MRR): 15万円
  - 顧客獲得コスト(CAC): 2,000円
  - 顧客生涯価値(LTV): 12,000円
  - LTV/CAC比: 6倍

継続:
  - 月次チャーン率: 10%以下
  - 6ヶ月継続率: 60%
  - NPS: 50以上
```

## 🚀 開発計画

### Sprint 1（Week 1-2）: 基盤構築
```yaml
タスク:
  □ プロジェクト初期設定
  □ 開発環境構築
  □ データベース設計・構築
  □ 認証システム実装
  □ 基本レイアウト作成

成果物:
  - 基本的なユーザー登録・ログイン機能
  - データベーススキーマ
  - 基本UI コンポーネント
```

### Sprint 2（Week 3-4）: コア機能実装
```yaml
タスク:
  □ OpenAI API統合
  □ メール生成機能実装
  □ プロンプトエンジニアリング
  □ 5業界テンプレート作成
  □ 生成結果表示・編集機能

成果物:
  - 動作するメール生成機能
  - 業界別テンプレート5種
  - 基本的な編集機能
```

### Sprint 3（Week 5-6）: UI/UX改善
```yaml
タスク:
  □ レスポンシブデザイン対応
  □ ユーザビリティ改善
  □ エラーハンドリング強化
  □ パフォーマンス最適化
  □ テスト実装

成果物:
  - モバイル対応完了
  - エラー処理実装
  - 基本テスト群
```

### Sprint 4（Week 7-8）: β版完成
```yaml
タスク:
  □ 決済システム統合
  □ サブスクリプション管理
  □ 利用制限機能
  □ 管理画面作成
  □ β版デプロイ

成果物:
  - 完全動作するβ版
  - 決済機能
  - 管理機能
```

## 🧪 テスト計画

### ユーザビリティテスト
```yaml
対象者:
  - 個人事業主5名
  - 零細企業経営者5名

テスト項目:
  - アカウント作成の容易さ
  - メール生成機能の使いやすさ
  - 生成結果の満足度
  - 全体的なUI/UXの評価

成功基準:
  - タスク完了率: 90%以上
  - 満足度: 4.0/5.0以上
  - 推奨意向: 70%以上
```

### 技術テスト
```yaml
機能テスト:
  - メール生成機能
  - ユーザー認証
  - 決済処理
  - データ保存・取得

パフォーマンステスト:
  - レスポンス時間: 3秒以内
  - 同時接続: 100ユーザー
  - API成功率: 99%以上

セキュリティテスト:
  - 認証・認可
  - データ暗号化
  - SQL インジェクション対策
  - XSS対策
```

この仕様書に基づいてMVP開発を進めることで、効率的に最小限の価値あるプロダクトを作成し、ユーザーフィードバックを収集して改善していくことができます。