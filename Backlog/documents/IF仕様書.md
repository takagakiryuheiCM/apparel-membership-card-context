# IF仕様書（インターフェース仕様書）

## 概要

本ドキュメントは、アパレル会員証LINEミニアプリとPOS様システム間のAPI連携仕様を定義します。

## システム構成

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  LINEミニアプリ  │────▶│   API Gateway   │────▶│  Lambda (BE)    │
│   (Frontend)    │◀────│                 │◀────│                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                        │
                                                        ▼
                                                ┌─────────────────┐
                                                │    DynamoDB     │
                                                └─────────────────┘
                                                        │
                                                        ▼
                                                ┌─────────────────┐
                                                │  POS様 Gateway  │
                                                │   (pos-worker)  │
                                                └─────────────────┘
                                                        │
                                                        ▼
                                                ┌─────────────────┐
                                                │   POS Server    │
                                                └─────────────────┘
```

## API一覧

### LINEミニアプリ → バックエンド

| No | メソッド | エンドポイント | 説明 |
|----|----------|----------------|------|
| 1 | POST | /api/users | 会員情報登録 |
| 2 | GET | /api/users/me | 会員情報取得 |
| 3 | PUT | /api/users/me | 会員情報更新 |
| 4 | DELETE | /api/users/me | 退会 |
| 5 | GET | /api/shops | 店舗一覧取得 |
| 6 | GET | /api/shops/{shopCode} | 店舗詳細取得 |
| 7 | POST | /api/membership-cards | 仮会員証発行 |
| 8 | GET | /api/membership-cards | 会員証一覧取得 |
| 9 | GET | /api/membership-cards/{cardId} | 会員証詳細取得（ポイント含む） |
| 10 | DELETE | /api/membership-cards/{cardId} | 店舗単位退会 |

### バックエンド → POS様 Gateway

| No | メソッド | エンドポイント | 説明 |
|----|----------|----------------|------|
| 1 | POST | /members/temporary | 仮会員登録 |
| 2 | GET | /members/{memberId} | 会員情報取得 |
| 3 | GET | /members/{memberId}/points | ポイント残高取得 |

### POS様 Gateway → バックエンド（Webhook）

| No | メソッド | エンドポイント | 説明 |
|----|----------|----------------|------|
| 1 | POST | /webhook/member-activated | 本会員アクティベート通知 |

---

## API詳細仕様

### 1. 仮会員登録 API

**エンドポイント**: `POST /members/temporary`

**リクエスト**:
```json
{
  "shopCode": "SHP001",
  "lastName": "山田",
  "firstName": "太郎",
  "lastNameKana": "ヤマダ",
  "firstNameKana": "タロウ",
  "birthDate": "19900101",
  "gender": 0,
  "postalCode": "1500001",
  "prefecture": "東京都",
  "city": "渋谷区",
  "address": "神宮前1-2-3",
  "phoneNumber": "09012345678"
}
```

**レスポンス（成功）**:
```json
{
  "memberId": "TMP-550E8400E29B41D4",
  "qrCode": "data:image/png;base64,iVBORw0KGgo...",
  "expiresAt": "2026-01-15T15:30:00+09:00"
}
```

**レスポンス（エラー）**:
```json
{
  "error": {
    "code": "INVALID_SHOP_CODE",
    "message": "指定された店舗コードは存在しません"
  }
}
```

---

### 2. ポイント残高取得 API

**エンドポイント**: `GET /members/{memberId}/points`

**レスポンス（成功）**:
```json
{
  "memberId": "SHP01000000001",
  "points": 1500,
  "pointsExpireAt": "2027-03-31T23:59:59+09:00",
  "lastUpdatedAt": "2026-01-15T10:30:00+09:00"
}
```

---

### 3. 本会員アクティベート通知 Webhook

**エンドポイント**: `POST /webhook/member-activated`

**リクエスト**:
```json
{
  "temporaryMemberId": "TMP-550E8400E29B41D4",
  "memberId": "SHP01000000001",
  "shopCode": "SHP001",
  "activatedAt": "2026-01-15T15:00:00+09:00"
}
```

**レスポンス（成功）**:
```json
{
  "status": "ok"
}
```

---

## エラーコード一覧

| コード | 説明 |
|--------|------|
| INVALID_SHOP_CODE | 店舗コードが不正 |
| MEMBER_NOT_FOUND | 会員が見つからない |
| TEMPORARY_EXPIRED | 仮会員証の有効期限切れ |
| ALREADY_ACTIVATED | 既にアクティベート済み |
| POS_CONNECTION_ERROR | POSシステムへの接続エラー |
| RATE_LIMIT_EXCEEDED | レート制限超過 |

---

## 非機能要件

### タイムアウト
- API呼び出しタイムアウト: 5秒
- リトライ回数: 最大3回
- リトライ間隔: 1秒（指数バックオフ）

### レート制限
- 1ユーザーあたり: 60リクエスト/分
- 全体: 1000リクエスト/分

### セキュリティ
- 通信: HTTPS (TLS 1.3)
- 認証: API Key + HMAC署名
- IPアドレス制限: ホワイトリスト方式
