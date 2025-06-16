# 個人事業主・零細企業向け営業文書AI

## 🎯 サービス概要

### ミッション
「すべての個人事業主に、大企業並みの営業支援を、親しみやすく手頃な価格で」

### ターゲット
- **個人事業主**: 約300万人（全国）
- **零細企業**: 従業員20人未満（日本企業の95%）
- **地域サービス業**: 理美容、飲食、小売、建設、コンサル等

## 📊 市場分析

### 現状の課題
```
💸 価格問題
- 既存営業AI：月額3-10万円 → 個人事業主には高額
- ROI計算困難：個人規模では投資対効果が見えにくい

🔧 機能過多問題
- 大企業向け機能が多すぎて使いこなせない
- 複雑なダッシュボード・分析機能が不要
- セットアップが困難

📝 文体・トーン問題
- フォーマルすぎて地域ビジネスには不適切
- 親しみやすさ・人情味が不足
- 地域性・季節感への配慮なし
```

### 機会の大きさ
```
📈 市場規模
- 個人事業主：300万人 × 年間1.2万円 = 360億円市場
- 零細企業：100万社 × 年間3.6万円 = 360億円市場
- 合計：720億円の潜在市場

🎯 アドレサブル市場（現実的）
- 5年後目標：2%取得 = 14.4億円
- 当面目標：0.1%取得 = 7,200万円
```

## 🚀 サービス仕様

### コア機能

#### 1. 親しみやすい営業メール生成
```yaml
機能:
  - 業界別テンプレート（20業界以上）
  - 季節の挨拶自動挿入
  - 地域イベント連動
  - 関係性レベル別文体調整

特徴:
  - "いつもお世話になっております" → "こんにちは！"
  - 堅苦しくない、自然な文体
  - 手書き感・温かみのある表現
```

#### 2. 簡単提案書・見積書作成
```yaml
機能:
  - ドラッグ&ドロップ操作
  - 手書き風デザインテンプレート
  - 価格計算自動化
  - PDF出力・メール送信

特徴:
  - A4 1-2枚のシンプル構成
  - 専門用語を使わない分かりやすい説明
  - 個人事業主らしい温かみのあるデザイン
```

#### 3. 地域密着営業支援
```yaml
機能:
  - 47都道府県別営業アプローチ
  - 地域イベント・祭りカレンダー連動
  - 方言・地域表現配慮
  - 商店街・地域コミュニティ向け文章

特徴:
  - "○○祭りお疲れ様でした！"
  - 地域の特色を活かした営業文
  - 地元密着感のある表現
```

#### 4. 継続フォロー自動化
```yaml
機能:
  - 感謝メール自動送信
  - 誕生日・記念日メッセージ
  - 季節のご挨拶
  - リピート促進メッセージ

特徴:
  - 人情味あふれる継続的関係構築
  - 自動だが手作り感のある文章
  - 個人事業主らしい心配り表現
```

## 🛠️ 技術仕様

### システム構成
```yaml
Frontend:
  Framework: Vue.js 3 + Composition API
  Styling: Tailwind CSS + DaisyUI (親しみやすいデザイン)
  Build: Vite
  State: Pinia
  Router: Vue Router

Backend:
  Runtime: Node.js 18+
  Framework: Express.js
  Database: SQLite (初期) → PostgreSQL (スケール時)
  ORM: Prisma
  Cache: Redis (セッション管理)

AI Integration:
  Primary: OpenAI GPT-3.5-turbo (コスト重視)
  Fallback: GPT-4 (高品質が必要な場合)
  Prompt Engineering: 親しみやすい文体特化

Authentication:
  Service: Supabase Auth (簡単実装)
  Social Login: Google, LINE (個人事業主向け)

Payment:
  Primary: Stripe (カード決済)
  Alternative: PayPal (海外対応)

Storage:
  Files: Supabase Storage
  Templates: Database内保存

Deployment:
  Frontend: Netlify
  Backend: Railway
  Database: Railway PostgreSQL
  Monitoring: Sentry
```

### データベース設計
```sql
-- ユーザー管理
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  business_type VARCHAR(50), -- 業種
  location VARCHAR(100),     -- 地域
  plan_type VARCHAR(20) DEFAULT 'free',
  created_at TIMESTAMP DEFAULT NOW()
);

-- サブスクリプション管理
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  plan VARCHAR(20) NOT NULL, -- free, basic, premium
  status VARCHAR(20) NOT NULL, -- active, inactive, canceled
  billing_cycle VARCHAR(10), -- monthly, yearly
  amount DECIMAL(10,2),
  started_at TIMESTAMP,
  ends_at TIMESTAMP
);

-- 生成コンテンツ履歴
CREATE TABLE generated_contents (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  content_type VARCHAR(50), -- email, proposal, follow_up
  prompt TEXT,
  generated_text TEXT,
  is_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- テンプレート管理
CREATE TABLE templates (
  id UUID PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50), -- business_type
  region VARCHAR(50),   -- geographical area
  prompt_template TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 使用状況トラッキング
CREATE TABLE usage_logs (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  action_type VARCHAR(50), -- generate_email, create_proposal
  tokens_used INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### AIプロンプト設計例
```javascript
// 親しみやすい営業メール生成用プロンプト
const generateFriendlyEmail = (businessType, customerName, purpose) => `
あなたは${businessType}を営む個人事業主です。
以下の条件で、親しみやすく温かみのある営業メールを作成してください：

【条件】
- 顧客名: ${customerName}
- 目的: ${purpose}
- トーン: フレンドリーで親しみやすい
- 文体: 丁寧だが堅すぎない
- 長さ: 200-300文字程度

【必須要素】
- 季節の挨拶を含める
- 地域への配慮を示す
- 個人事業主らしい温かみ
- 押し付けがましくない提案

【避けるべき表現】
- 過度に丁寧な敬語
- 企業的で冷たい表現
- 長すぎる文章
- 専門用語の多用
`;
```

## 💰 ビジネスモデル

### 料金設定
```yaml
🆓 フリープラン:
  価格: 無料
  制限: 月10通まで
  機能: 基本テンプレート5種類
  広告: あり
  目的: お試し・口コミ獲得

💡 ベーシックプラン:
  価格: 月額1,000円（税込1,100円）
  制限: 月50通まで
  機能: 全テンプレート利用可能
  特典: 地域情報連動、広告非表示
  目的: 個人事業主メイン層

🚀 プレミアムプラン:
  価格: 月額3,000円（税込3,300円）
  制限: 無制限
  機能: カスタムテンプレート作成、A/Bテスト
  特典: 効果測定レポート、優先サポート
  目的: 積極的活用層・小規模企業
```

### 収益予測（3年計画）
```yaml
Year 1 目標:
  ユーザー数: 1,000人
  内訳: Free 70% / Basic 25% / Premium 5%
  月次収益: 100万円
  年間収益: 1,200万円

Year 2 目標:
  ユーザー数: 5,000人
  内訳: Free 60% / Basic 30% / Premium 10%
  月次収益: 500万円
  年間収益: 6,000万円

Year 3 目標:
  ユーザー数: 15,000人
  内訳: Free 50% / Basic 35% / Premium 15%
  月次収益: 1,500万円
  年間収益: 1.8億円
```

## 🎯 マーケティング戦略

### Phase 1: 地域密着展開（0-6ヶ月）
```yaml
戦術:
  - 商工会議所との連携
  - 地域創業セミナーでの実演
  - 個人事業主向けコミュニティ参加
  - 地域メディアでの紹介

目標:
  - 認知度向上
  - 初期ユーザー100人獲得
  - フィードバック収集
```

### Phase 2: 口コミ拡散（6-18ヶ月）
```yaml
戦術:
  - 友達紹介キャンペーン（1ヶ月無料）
  - 成功事例のSNS共有
  - YouTuber/ブロガーとのタイアップ
  - 個人事業主向けインフルエンサー活用

目標:
  - バイラル係数1.5以上
  - 月次成長率20%維持
  - 1,000人突破
```

### Phase 3: 全国展開（18ヶ月-）
```yaml
戦術:
  - Google/Facebook広告本格投下
  - SEO対策強化
  - パートナーシップ拡大
  - 機能拡張による差別化

目標:
  - 全国47都道府県でのユーザー獲得
  - 年間1万人以上の新規獲得
  - 市場シェア確立
```

## 🚀 開発ロードマップ

### Phase 1: MVP（2-3ヶ月）
```yaml
Week 1-4: 基盤構築
- [ ] プロジェクト初期設定
- [ ] UI/UXデザイン作成
- [ ] 基本認証システム
- [ ] データベース設計・構築

Week 5-8: コア機能開発
- [ ] 営業メール生成機能
- [ ] 5業界のテンプレート作成
- [ ] OpenAI API統合
- [ ] 基本的な管理画面

Week 9-12: β版完成
- [ ] 決済システム統合
- [ ] レスポンシブ対応
- [ ] セキュリティ強化
- [ ] β版テスト実施
```

### Phase 2: 本格版（3-6ヶ月）
```yaml
Month 4-5: 機能拡張
- [ ] 提案書作成機能
- [ ] 地域情報連動
- [ ] テンプレート20種類に拡大
- [ ] A/Bテスト機能

Month 6: 品質向上
- [ ] パフォーマンス最適化
- [ ] エラーハンドリング強化
- [ ] ユーザビリティ改善
- [ ] 正式リリース準備
```

### Phase 3: スケール（6ヶ月-）
```yaml
継続的改善:
- [ ] 機械学習による文章品質向上
- [ ] 音声入力対応
- [ ] モバイルアプリ開発
- [ ] 他ツールとの連携機能
```

## 📈 成功指標（KPI）

### ユーザー獲得
- **月次新規登録**: 前月比20%成長
- **アクティブユーザー率**: 70%以上
- **有料転換率**: フリーから有料への転換15%以上

### エンゲージメント
- **利用頻度**: 週2回以上の利用50%
- **生成回数**: ユーザー1人あたり月15回以上
- **継続率**: 6ヶ月継続率80%以上

### ビジネス指標
- **MRR成長率**: 月15%以上
- **チャーン率**: 月5%以下
- **LTV/CAC比**: 3倍以上
- **NPS**: 50以上

## 🤝 パートナーシップ戦略

### 優先パートナー
```yaml
商工会議所・商工会:
  メリット: 個人事業主への直接リーチ
  提供価値: 会員向け特別価格・セミナー

会計ソフト会社:
  対象: freee, MFクラウド, 弥生
  メリット: 顧客基盤の重複
  提供価値: 統合機能・データ連携

地域銀行:
  メリット: 創業支援パッケージ
  提供価値: 金融サービスとの組み合わせ

コワーキングスペース:
  メリット: フリーランス・起業家コミュニティ
  提供価値: 利用者向け特典・ワークショップ
```

## 🔍 競合分析・差別化

### 既存サービスとの比較
```yaml
vs 大手営業AI:
  価格: 1/10の低価格
  機能: シンプル・使いやすさ重視
  文体: 親しみやすい・地域密着

vs 汎用文章生成AI:
  特化性: 営業・ビジネス特化
  テンプレート: 業界別カスタマイズ
  地域性: 日本の商慣行対応

vs 既存メール作成ツール:
  AI活用: 高度な文章生成
  パーソナライゼーション: 顧客別最適化
  継続改善: 機械学習による品質向上
```

### 持続的競争優位
1. **地域密着データベース**: 47都道府県の詳細情報
2. **個人事業主特化ノウハウ**: 大手では対応困難
3. **親しみやすさの追求**: 技術だけでない人間味
4. **継続的学習**: ユーザーフィードバックによる改善

この戦略により、既存の大手営業AIサービスとは完全に異なる市場セグメントで独自のポジションを確立できます。