# [BE] 仮会員証発行API

## 目的
ユーザーが選択した店舗で利用できる仮会員証を発行するAPIを提供する。
POS Gatewayと連携し、仮会員情報を登録してQRコードを取得する。

## 対象（このAPIが満たすこと）
- POS Gatewayに仮会員登録リクエストを送信する
- QRコードと仮会員IDを取得する
- DynamoDBのMembershipCardsテーブルに仮会員証レコードを作成する
- TTLを設定して30分後に自動削除されるようにする

## DynamoDB設計

### テーブル定義
詳細は [DB設計](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計) を参照。

| 項目 | 値 |
|------|-----|
| テーブル名 | `MembershipCards` |
| パーティションキー（PK） | `userId`（String） |
| ソートキー（SK） | `shopCodeCreatedAt`（String） |
| TTL属性 | `ttl` |

### 属性（本API関連）
| 属性名 | 型 | 必須 | 説明 |
|--------|-----|:----:|------|
| userId | String | ○ | ユーザーID（PK） |
| shopCodeCreatedAt | String | ○ | 店舗コード+作成日時（SK） |
| shopCode | String | ○ | 店舗コード |
| memberId | String | ○ | 会員証ID（POS様から発行） |
| status | String | ○ | ステータス（temporary） |
| expiresAt | String | ○ | 有効期限（発行から30分後） |
| ttl | Number | ○ | TTL（epoch秒、30分後） |
| createdAt | String | ○ | 作成日時 |
| updatedAt | String | ○ | 更新日時 |

### アクセスパターン
| パターン | 操作 | キー条件 |
|----------|------|----------|
| 仮会員証登録 | PutItem | PK = userId, SK = shopCodeCreatedAt |
| 会員証一覧取得 | Query | PK = userId |

## エンドポイント
`POST /api/membership-cards`

## リクエスト

### Headers
| ヘッダー名 | 必須 | 説明 |
|------------|:----:|------|
| Authorization | ○ | Bearer {LINEアクセストークン} |
| Content-Type | ○ | application/json |

### Body
```json
{
  "shopCode": "SHP001"
}
```

## レスポンス

### 201 Created
成功時。

```json
{
  "cardId": "550e8400-e29b-41d4-a716-446655440000#SHP001#2026-01-20T10:00:00+09:00",
  "memberId": "TMP-550E8400E29B41D4",
  "qrCode": "data:image/png;base64,iVBORw0KGgo...",
  "expiresAt": "2026-01-20T10:30:00+09:00",
  "status": "temporary",
  "shopCode": "SHP001",
  "shopName": "ファッションモール渋谷店"
}
```

### 400 Bad Request
バリデーションエラー時。

```json
{
  "error": "VALIDATION_ERROR",
  "message": "店舗コードは必須です"
}
```

### 404 Not Found
店舗が見つからない場合。

```json
{
  "error": "SHOP_NOT_FOUND",
  "message": "指定された店舗が見つかりません"
}
```

### 503 Service Unavailable
POS Gateway接続エラー時。

```json
{
  "error": "POS_CONNECTION_ERROR",
  "message": "しばらく時間をおいて再度お試しください"
}
```

## 関連ドキュメント
- [DB設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計)
- [API設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/API設計)
- [IF仕様書](Backlog/documents/IF仕様書.md) - POS様API連携仕様
- [会員アクティベートシーケンス図](Backlog/documents/会員アクティベートシーケンス図.md)

## タスク
- [ ] API実装
  - [ ] ルーティング実装（`POST /api/membership-cards`）
  - [ ] ユーザー情報取得（DynamoDB）
  - [ ] 店舗存在チェック
  - [ ] POS Gateway への仮会員登録リクエスト
  - [ ] MembershipCardsテーブルへの保存（status=temporary）
  - [ ] TTL設定（30分後に自動削除）
  - [ ] レスポンス整形
- [ ] テスト実装
  - [ ] ユニットテスト
  - [ ] 結合テスト

## テストケース

### 正常系
- [ ] 仮会員証が正常に発行される
- [ ] QRコードがレスポンスに含まれる
- [ ] 有効期限が30分後に設定される
- [ ] ステータスがtemporaryで登録される
- [ ] TTLが正しく設定される

### 異常系（バリデーション）
- [ ] shopCodeが空の場合、400エラーが返る
- [ ] 存在しない店舗コードの場合、404エラーが返る

### 異常系（その他）
- [ ] 認証に失敗した場合、401エラーが返る
- [ ] POS Gatewayへの接続がタイムアウトした場合、503エラーが返る（リトライ3回後）

## 完了条件
- [ ] 上記タスクが完了していること
- [ ] テストケースがすべて満たされること
- [ ] レビューが承認されていること

## Blocked by
- [ ] POS連携APIの仕様確定
- [ ] POS Gateway接続設定
