# [BE] 店舗一覧取得API

## 目的
店舗一覧画面に表示するための店舗情報を取得するAPIを提供する。

## 対象（このAPIが満たすこと）
- DynamoDBのShopsテーブルから有効な店舗を取得する
- 店舗名でのキーワード検索に対応する
- エリアでの絞り込みに対応する
- 表示順（sort_order）でソートして返却する

## DynamoDB設計

### テーブル定義
詳細は [DB設計](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計) を参照。

| 項目 | 値 |
|------|-----|
| テーブル名 | `Shops` |
| パーティションキー（PK） | `shopCode`（String） |
| ソートキー（SK） | なし |

### 属性（本API関連）
| 属性名 | 型 | 必須 | 説明 |
|--------|-----|:----:|------|
| shopCode | String | ○ | 店舗コード（PK） |
| shopName | String | ○ | 店舗名 |
| shopNameKana | String | ○ | 店舗名（カナ） |
| postalCode | String | ○ | 郵便番号 |
| prefecture | String | ○ | 都道府県 |
| address | String | ○ | 住所 |
| phoneNumber | String | ○ | 電話番号 |
| businessHours | String | ○ | 営業時間 |
| isActive | Boolean | ○ | 有効フラグ |
| areaName | String | ○ | エリア名 |
| sortOrder | Number | ○ | 表示順 |

### アクセスパターン
| パターン | 操作 | キー条件 |
|----------|------|----------|
| 店舗一覧取得 | Scan | isActive = true |
| 店舗詳細取得 | GetItem | PK = shopCode |

## エンドポイント
`GET /api/shops`

## リクエスト

### Headers
| ヘッダー名 | 必須 | 説明 |
|------------|:----:|------|
| Authorization | ○ | Bearer {LINEアクセストークン} |

### クエリパラメータ
| パラメータ | 必須 | 説明 |
|-----------|:----:|------|
| keyword | - | 店舗名での検索キーワード |
| area | - | エリアでの絞り込み |

## レスポンス

### 200 OK
成功時。

```json
{
  "shops": [
    {
      "shopCode": "SHP001",
      "shopName": "ファッションモール渋谷店",
      "areaName": "渋谷エリア",
      "address": "東京都渋谷区神宮前1-2-3"
    },
    {
      "shopCode": "SHP002",
      "shopName": "ファッションモール新宿店",
      "areaName": "新宿エリア",
      "address": "東京都新宿区新宿3-4-5"
    }
  ]
}
```

## 関連ドキュメント
- [DB設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/DB設計)
- [API設計（wiki）](https://github.com/takagakiryuheiCM/apparel-membership-card/wiki/API設計)
- [店舗マスター項目](Backlog/documents/店舗マスター項目.md)

## タスク
- [ ] API実装
  - [ ] ルーティング実装（`GET /api/shops`）
  - [ ] Shopsテーブルからの取得処理（Scan）
  - [ ] isActive=true のフィルタリング
  - [ ] キーワード検索処理
  - [ ] エリア絞り込み処理
  - [ ] ソート処理（sort_order順）
  - [ ] レスポンス整形
- [ ] テスト実装
  - [ ] ユニットテスト
  - [ ] 結合テスト

## テストケース

### 正常系
- [ ] 店舗一覧が取得できる
- [ ] キーワード検索で店舗名に部分一致する店舗が取得できる
- [ ] エリア絞り込みで該当エリアの店舗のみ取得できる
- [ ] sort_order順でソートされて返却される
- [ ] isActive=false の店舗は返却されない

### 異常系
- [ ] 認証に失敗した場合、401エラーが返る

## 完了条件
- [ ] 上記タスクが完了していること
- [ ] テストケースがすべて満たされること
- [ ] レビューが承認されていること

## Blocked by
- [ ] 店舗マスタCSV取り込み機能
