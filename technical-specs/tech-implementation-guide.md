# 技術実装ガイド - 個人事業主向け営業AI

## 🏗️ アーキテクチャ概要

### システム全体図
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   External      │
│   Vue.js 3      │────│   Node.js       │────│   OpenAI API    │
│   Tailwind CSS  │    │   Express       │    │   Stripe API    │
│   Vite          │    │   Prisma ORM    │    │   SendGrid      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CDN/Hosting   │    │   Database      │    │   Monitoring    │
│   Netlify       │    │   PostgreSQL    │    │   Sentry        │
│   CloudFlare    │    │   Redis Cache   │    │   Analytics     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 セットアップ手順

### 1. 開発環境準備
```bash
# Node.js 18+ インストール確認
node --version

# プロジェクト初期化
mkdir business-ai-app
cd business-ai-app

# Frontend セットアップ
npm create vue@latest frontend
cd frontend
npm install
npm install -D tailwindcss daisyui @tailwindcss/forms
npm install @vueuse/core axios pinia vue-router

# Backend セットアップ
cd ../
mkdir backend
cd backend
npm init -y
npm install express cors helmet morgan dotenv
npm install prisma @prisma/client openai stripe nodemailer
npm install -D nodemon typescript @types/node
```

### 2. フロントエンド設定

#### Vue.js + Composition API 構成
```javascript
// src/main.js
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import './assets/main.css'

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.mount('#app')
```

#### Tailwind CSS + DaisyUI設定
```javascript
// tailwind.config.js
module.exports = {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        'warm-orange': '#FF8A65',
        'soft-blue': '#64B5F6',
        'gentle-green': '#81C784'
      },
      fontFamily: {
        'handwriting': ['Klee One', 'cursive'], // 手書き風フォント
      }
    }
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: ['light', 'dark', 'cupcake'] // 親しみやすいテーマ
  }
}
```

#### メインコンポーネント例
```vue
<!-- src/components/EmailGenerator.vue -->
<template>
  <div class="max-w-4xl mx-auto p-6 bg-base-100 rounded-box shadow-lg">
    <h2 class="text-2xl font-bold text-center mb-6 font-handwriting">
      📧 親しみやすい営業メール作成
    </h2>
    
    <!-- 入力フォーム -->
    <div class="grid md:grid-cols-2 gap-6">
      <div class="space-y-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text text-lg">お客様のお名前</span>
          </label>
          <input 
            v-model="formData.customerName"
            type="text" 
            placeholder="田中様"
            class="input input-bordered w-full text-lg"
          />
        </div>
        
        <div class="form-control">
          <label class="label">
            <span class="label-text text-lg">業種</span>
          </label>
          <select v-model="formData.businessType" class="select select-bordered text-lg">
            <option value="">選択してください</option>
            <option value="restaurant">飲食店</option>
            <option value="beauty">美容・理容</option>
            <option value="retail">小売店</option>
            <option value="construction">建設・工務店</option>
            <option value="consulting">コンサルティング</option>
          </select>
        </div>
        
        <div class="form-control">
          <label class="label">
            <span class="label-text text-lg">メールの目的</span>
          </label>
          <textarea 
            v-model="formData.purpose"
            class="textarea textarea-bordered h-24 text-lg"
            placeholder="例：新サービスのご紹介をしたい"
          ></textarea>
        </div>
        
        <button 
          @click="generateEmail"
          :disabled="isGenerating"
          class="btn btn-primary btn-lg w-full"
        >
          <span v-if="isGenerating" class="loading loading-spinner"></span>
          {{ isGenerating ? '作成中...' : '📝 メールを作成' }}
        </button>
      </div>
      
      <!-- 生成結果 -->
      <div class="space-y-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text text-lg">生成されたメール</span>
          </label>
          <textarea 
            v-model="generatedEmail"
            class="textarea textarea-bordered h-64 text-lg"
            placeholder="ここに親しみやすいメールが生成されます..."
          ></textarea>
        </div>
        
        <div class="flex gap-2">
          <button 
            @click="copyToClipboard"
            class="btn btn-outline flex-1"
          >
            📋 コピー
          </button>
          <button 
            @click="saveTemplate"
            class="btn btn-secondary flex-1"
          >
            💾 保存
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useEmailStore } from '@/stores/email'

const emailStore = useEmailStore()

const isGenerating = ref(false)
const generatedEmail = ref('')

const formData = reactive({
  customerName: '',
  businessType: '',
  purpose: ''
})

const generateEmail = async () => {
  if (!formData.customerName || !formData.businessType || !formData.purpose) {
    alert('すべての項目を入力してください')
    return
  }
  
  isGenerating.value = true
  try {
    const result = await emailStore.generateFriendlyEmail(formData)
    generatedEmail.value = result.content
  } catch (error) {
    alert('メール生成に失敗しました。もう一度お試しください。')
  } finally {
    isGenerating.value = false
  }
}

const copyToClipboard = async () => {
  await navigator.clipboard.writeText(generatedEmail.value)
  alert('📋 クリップボードにコピーしました！')
}

const saveTemplate = async () => {
  // テンプレート保存処理
  await emailStore.saveAsTemplate({
    ...formData,
    content: generatedEmail.value
  })
  alert('💾 テンプレートとして保存しました！')
}
</script>
```

### 3. バックエンド実装

#### Express.js サーバー設定
```javascript
// server.js
const express = require('express')
const cors = require('cors')
const helmet = require('helmet')
const morgan = require('morgan')
require('dotenv').config()

const app = express()
const PORT = process.env.PORT || 3000

// ミドルウェア
app.use(helmet())
app.use(cors())
app.use(morgan('combined'))
app.use(express.json({ limit: '10mb' }))

// ルート
app.use('/api/auth', require('./routes/auth'))
app.use('/api/ai', require('./routes/ai'))
app.use('/api/user', require('./routes/user'))
app.use('/api/billing', require('./routes/billing'))

// エラーハンドリング
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).json({ 
    error: 'サーバーエラーが発生しました',
    message: process.env.NODE_ENV === 'development' ? err.message : '内部エラー'
  })
})

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`)
})
```

#### AI生成エンドポイント
```javascript
// routes/ai.js
const express = require('express')
const OpenAI = require('openai')
const { PrismaClient } = require('@prisma/client')
const authMiddleware = require('../middleware/auth')
const rateLimitMiddleware = require('../middleware/rateLimit')

const router = express.Router()
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY })
const prisma = new PrismaClient()

// 親しみやすい営業メール生成
router.post('/generate-friendly-email', 
  authMiddleware, 
  rateLimitMiddleware, 
  async (req, res) => {
    try {
      const { customerName, businessType, purpose, region } = req.body
      const userId = req.user.id
      
      // ユーザーの使用制限チェック
      const usage = await checkUserUsage(userId)
      if (!usage.canGenerate) {
        return res.status(429).json({
          error: '月間生成制限に達しました',
          upgradeRequired: true
        })
      }
      
      // プロンプト生成
      const prompt = createFriendlyEmailPrompt({
        customerName,
        businessType,
        purpose,
        region: region || '全国',
        season: getCurrentSeason()
      })
      
      // OpenAI API呼び出し
      const completion = await openai.chat.completions.create({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: '親しみやすく温かみのある営業メールを作成する個人事業主のアシスタントです。'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        max_tokens: 500,
        temperature: 0.7
      })
      
      const generatedContent = completion.choices[0].message.content
      
      // 使用ログ保存
      await prisma.usageLog.create({
        data: {
          userId,
          actionType: 'generate_email',
          tokensUsed: completion.usage.total_tokens,
          contentType: 'friendly_email'
        }
      })
      
      // 生成履歴保存
      await prisma.generatedContent.create({
        data: {
          userId,
          contentType: 'friendly_email',
          prompt: JSON.stringify(req.body),
          generatedText: generatedContent
        }
      })
      
      res.json({
        success: true,
        content: generatedContent,
        tokensUsed: completion.usage.total_tokens,
        remainingUsage: usage.remaining - 1
      })
      
    } catch (error) {
      console.error('Email generation error:', error)
      res.status(500).json({
        error: 'メール生成中にエラーが発生しました',
        details: process.env.NODE_ENV === 'development' ? error.message : null
      })
    }
  }
)

// 親しみやすいメール用プロンプト生成関数
function createFriendlyEmailPrompt({ customerName, businessType, purpose, region, season }) {
  const seasonGreeting = getSeasonalGreeting(season)
  const businessTypeGreeting = getBusinessTypeGreeting(businessType)
  const regionalTouch = getRegionalTouch(region)
  
  return `
以下の条件で、個人事業主らしく親しみやすい営業メールを作成してください：

【基本情報】
- 顧客名: ${customerName}
- 業種: ${businessType}
- 目的: ${purpose}
- 地域: ${region}
- 季節: ${season}

【文体の指針】
- 温かみがあり親しみやすい
- 丁寧だが堅すぎない
- 個人事業主らしい人間味
- 押し付けがましくない

【必須要素】
- ${seasonGreeting}
- ${businessTypeGreeting}
- ${regionalTouch}
- 具体的で分かりやすい提案

【文字数】
200-300文字程度

【避けるべき表現】
- 過度に丁寧な敬語
- 企業的で冷たい表現
- 専門用語の多用
- 長すぎる説明
`
}

// 季節の挨拶を取得
function getSeasonalGreeting(season) {
  const greetings = {
    spring: '桜も咲き始め、新しい季節がやってきましたね',
    summer: '暑い日が続いていますが、お元気でお過ごしでしょうか',
    autumn: '秋の気配が感じられる今日この頃',
    winter: '寒さが厳しくなってきましたが、お変わりありませんか'
  }
  return greetings[season] || 'いつもお世話になっております'
}

// 業種別の親しみやすい表現
function getBusinessTypeGreeting(businessType) {
  const greetings = {
    restaurant: 'お店の方はいかがですか？',
    beauty: 'お客様にご好評いただいているようで何よりです',
    retail: '商売繁盛で何よりです',
    construction: '現場の方、お疲れ様です',
    consulting: 'お忙しい日々をお過ごしのことと思います'
  }
  return greetings[businessType] || 'お仕事の調子はいかがですか？'
}

// 地域性を加える表現
function getRegionalTouch(region) {
  if (region === '全国') return ''
  return `${region}の皆様にお役に立てることがあれば嬉しいです`
}

// 現在の季節を取得
function getCurrentSeason() {
  const month = new Date().getMonth() + 1
  if (month >= 3 && month <= 5) return 'spring'
  if (month >= 6 && month <= 8) return 'summer'
  if (month >= 9 && month <= 11) return 'autumn'
  return 'winter'
}

module.exports = router
```

### 4. データベース設計（Prisma）

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id            String   @id @default(cuid())
  email         String   @unique
  name          String
  businessType  String?  @map("business_type")
  location      String?
  planType      String   @default("free") @map("plan_type")
  createdAt     DateTime @default(now()) @map("created_at")
  updatedAt     DateTime @updatedAt @map("updated_at")
  
  // Relations
  subscription  Subscription?
  contents      GeneratedContent[]
  usageLogs     UsageLog[]
  templates     SavedTemplate[]
  
  @@map("users")
}

model Subscription {
  id           String    @id @default(cuid())
  userId       String    @unique @map("user_id")
  plan         String    // free, basic, premium
  status       String    // active, inactive, canceled
  billingCycle String?   @map("billing_cycle") // monthly, yearly
  amount       Decimal?  @db.Decimal(10, 2)
  startedAt    DateTime? @map("started_at")
  endsAt       DateTime? @map("ends_at")
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("subscriptions")
}

model GeneratedContent {
  id            String   @id @default(cuid())
  userId        String   @map("user_id")
  contentType   String   @map("content_type") // email, proposal, follow_up
  prompt        String   @db.Text
  generatedText String   @db.Text @map("generated_text")
  isUsed        Boolean  @default(false) @map("is_used")
  createdAt     DateTime @default(now()) @map("created_at")
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("generated_contents")
}

model SavedTemplate {
  id          String   @id @default(cuid())
  userId      String   @map("user_id")
  name        String
  category    String   // business_type or custom
  region      String?
  prompt      String   @db.Text
  template    String   @db.Text
  isActive    Boolean  @default(true) @map("is_active")
  createdAt   DateTime @default(now()) @map("created_at")
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("saved_templates")
}

model UsageLog {
  id         String   @id @default(cuid())
  userId     String   @map("user_id")
  actionType String   @map("action_type") // generate_email, create_proposal
  tokensUsed Int      @map("tokens_used")
  createdAt  DateTime @default(now()) @map("created_at")
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("usage_logs")
}
```

### 5. デプロイメント設定

#### Netlify設定（フロントエンド）
```toml
# netlify.toml
[build]
  publish = "dist"
  command = "npm run build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[build.environment]
  NODE_VERSION = "18"
```

#### Railway設定（バックエンド）
```json
{
  "name": "business-ai-backend",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "healthcheckPath": "/health"
  }
}
```

## 🔧 開発・運用のベストプラクティス

### セキュリティ対策
```javascript
// セキュリティミドルウェア例
const rateLimit = require('express-rate-limit')
const slowDown = require('express-slow-down')

// レート制限
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分
  max: 100, // 最大100リクエスト
  message: 'リクエストが多すぎます。後でもう一度お試しください。'
})

// 段階的遅延
const speedLimiter = slowDown({
  windowMs: 15 * 60 * 1000,
  delayAfter: 50,
  delayMs: 500
})

app.use('/api/', apiLimiter)
app.use('/api/', speedLimiter)
```

### エラーハンドリング
```javascript
// グローバルエラーハンドラー
class AppError extends Error {
  constructor(message, statusCode) {
    super(message)
    this.statusCode = statusCode
    this.isOperational = true
    
    Error.captureStackTrace(this, this.constructor)
  }
}

const handleGlobalError = (err, req, res, next) => {
  let error = { ...err }
  error.message = err.message
  
  // ログ出力
  console.error(err)
  
  // Prismaエラー
  if (err.code === 'P2002') {
    const message = 'データがすでに存在します'
    error = new AppError(message, 400)
  }
  
  // OpenAIエラー
  if (err.status === 429) {
    const message = 'AI APIの利用制限に達しました'
    error = new AppError(message, 429)
  }
  
  res.status(error.statusCode || 500).json({
    success: false,
    error: error.message || 'サーバーエラー'
  })
}
```

### パフォーマンス最適化
```javascript
// Redisキャッシュ設定
const redis = require('redis')
const client = redis.createClient(process.env.REDIS_URL)

const cacheTemplate = async (key, data, expireSeconds = 3600) => {
  await client.setex(key, expireSeconds, JSON.stringify(data))
}

const getCache = async (key) => {
  const cached = await client.get(key)
  return cached ? JSON.parse(cached) : null
}

// よく使われるテンプレートのキャッシュ
router.get('/templates/:businessType', async (req, res) => {
  const cacheKey = `templates:${req.params.businessType}`
  
  let templates = await getCache(cacheKey)
  if (!templates) {
    templates = await prisma.savedTemplate.findMany({
      where: { category: req.params.businessType }
    })
    await cacheTemplate(cacheKey, templates)
  }
  
  res.json(templates)
})
```

この実装ガイドに従うことで、技術的に堅牢で実用的な個人事業主向け営業AIサービスを構築できます。