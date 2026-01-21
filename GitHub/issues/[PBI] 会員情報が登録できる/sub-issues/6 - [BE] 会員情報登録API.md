# [BE] 会員情報登録API

## 目的
会員情報登録画面から送信された会員情報をDynamoDBに保存し、LINEミニアプリの会員として登録するAPIを提供する。

## 対象（このAPIが満たすこと）
- LINEユーザーIDと会員情報を紐付けて保存する
- 入力データのバリデーションを行う
- 既に会員登録済みのユーザーは登録できないようにする

## DynamoDB設計

### テーブル定義
詳細は [DB設計](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計) を参照。

| 項目 | 値 |
|------|-----|
| テーブル名 | `Users` |
| パーティションキー（PK） | `userId`（String, UUID v4） |
| ソートキー（SK） | なし |
| GSI | `LineUserIdIndex`（PK: `lineUserId`） |

### 属性（本API関連）
| 属性名 | 型 | 必須 | 説明 |
|--------|-----|:----:|------|
| userId | String | ○ | ユーザーID（PK, UUID v4, サーバー生成） |
| lineUserId | String | ○ | LINEユーザーID（GSI-PK, 認証トークンから取得） |
| lastName | String | ○ | 姓 |
| firstName | String | ○ | 名 |
| lastNameKana | String | ○ | ふりがな（姓）※ひらがな |
| firstNameKana | String | ○ | ふりがな（名）※ひらがな |
| gender | Number | ○ | 性別（0: 男性, 1: 女性） |
| birthDate | String | ○ | 生年月日（YYYYMMDD形式） |
| postalCode1 | String | ○ | 郵便番号（上3桁） |
| postalCode2 | String | ○ | 郵便番号（下4桁） |
| prefectureCode | Number | ○ | 都道府県コード（0〜47） |
| city | String | ○ | 市区町村 |
| address | String | ○ | それ以降の住所 |
| building | String | - | 建物名・部屋番号 |
| phoneNumber | String | ○ | 電話番号 |
| createdAt | String | ○ | 作成日時（ISO8601） |
| updatedAt | String | ○ | 更新日時（ISO8601） |

### アクセスパターン
| パターン | 操作 | キー条件 |
|----------|------|----------|
| 会員情報取得 | GetItem | PK = userId |
| 会員情報登録 | PutItem | PK = userId |
| LINE認証→userId取得 | Query (GSI) | GSI: lineUserId |

## エンドポイント
`POST /api/users`

## リクエスト

### Headers
| ヘッダー名 | 必須 | 説明 |
|------------|:----:|------|
| Authorization | ○ | Bearer {LINEアクセストークン} |
| Content-Type | ○ | application/json |

### Body
```json
{
  "lastName": "山田",
  "firstName": "太郎",
  "lastNameKana": "やまだ",
  "firstNameKana": "たろう",
  "gender": 0,
  "birthDate": "19900101",
  "postalCode1": "150",
  "postalCode2": "0001",
  "prefectureCode": 13,
  "city": "渋谷区",
  "address": "神宮前1-2-3",
  "building": "○○マンション101",
  "phoneNumber": "09012345678"
}
```

## バリデーションルール
| 項目名 | 必須 | 文字数 | 文字種別 | 入力制限 |
|--------|:----:|--------|----------|----------|
| lastName | ○ | 64以下 | 文字列 | |
| firstName | ○ | 64以下 | 文字列 | |
| lastNameKana | ○ | 64以下 | ひらがな | ひらがなのみ |
| firstNameKana | ○ | 64以下 | ひらがな | ひらがなのみ |
| gender | ○ | - | 数値 | 0または1 |
| birthDate | ○ | 8 | 半角数字 | YYYYMMDD形式、過去日付 |
| postalCode1 | ○ | 3 | 半角数字 | |
| postalCode2 | ○ | 4 | 半角数字 | |
| prefectureCode | ○ | - | 数値 | 0-47 |
| city | ○ | 30以下 | 文字列 | |
| address | ○ | 40以下 | 文字列 | |
| building | - | 40以下 | 文字列 | |
| phoneNumber | ○ | 10-11 | 半角数字 | 0から始まる |

## レスポンス

### 201 Created
登録成功時。

```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2026-01-20T10:00:00Z"
}
```

### 400 Bad Request
バリデーションエラー時。

```json
{
  "error": "VALIDATION_ERROR",
  "message": "入力内容に誤りがあります",
  "details": [
    {
      "field": "lastName",
      "message": "姓は64文字以下で入力してください"
    }
  ]
}
```

### 409 Conflict
既に会員登録済みの場合。

```json
{
  "error": "ALREADY_REGISTERED",
  "message": "既に会員登録されています"
}
```

## 関連ドキュメント
- [DB設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計)
- [API設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/API設計)

## タスク
- [ ] API実装
  - [ ] ルーティング実装（`POST /api/users`）
  - [ ] ドメインモデル修正
  - [ ] リポジトリインターフェース作成
  - [ ] リポジトリ実装
  - [ ] ユースケース作成
  - [ ] ハンドラ作成
  - [ ] LINEアクセストークンからユーザーID取得
  - [ ] userId（UUID）の生成
  - [ ] リクエストバリデーション実装
  - [ ] 既存会員チェック処理（GSI: lineUserIdで検索）
  - [ ] DynamoDB登録処理
  - [ ] レスポンス整形
- [ ] テスト実装
  - [ ] ユニットテスト
  - [ ] 結合テスト

## テストケース

### 正常系
- [ ] 全ての必須項目を正しく入力した場合、201で登録が成功する
- [ ] 任意項目（building）を省略しても登録が成功する
- [ ] 登録成功時、createdAtとupdatedAtが正しく設定される

### 異常系（バリデーション）
- [ ] 必須項目が欠けている場合、400エラーが返る
- [ ] 姓・名が65文字以上の場合、400エラーが返る
- [ ] ふりがなにひらがな以外が含まれる場合、400エラーが返る
- [ ] genderが0,1以外の場合、400エラーが返る
- [ ] birthDateがYYYYMMDD形式でない場合、400エラーが返る
- [ ] birthDateが未来日の場合、400エラーが返る

### 異常系（その他）
- [ ] 既に会員登録済み（同じlineUserId）の場合、409エラーが返る
- [ ] 認証に失敗した場合、401エラーが返る

## 完了条件
- [ ] 上記タスクが完了していること
- [ ] テストケースがすべて満たされること
- [ ] レビューが承認されていること

## Blocked by
- [ ] バリデーションルールの最終確定
