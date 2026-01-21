# [BE] 店舗一覧取得API

## Issue情報
- **Issue番号**: #11
- **ステータス**: ✅ Done
- **ラベル**: backend
- **親Issue**: #10 [PBI] 店舗一覧が表示でき、検索できる
- **担当者**: @takahashi

## 概要

店舗一覧を取得するAPIを実装する。

## タスク

- [x] `GET /api/shops` エンドポイントの実装
- [x] Shopsテーブルからの取得処理（Scan）
- [x] isActive=true のフィルタリング
- [x] ソート処理（sort_order順）
- [x] ユニットテストの作成

## 実装詳細

### エンドポイント
`GET /api/shops`

### クエリパラメータ
| パラメータ | 必須 | 説明 |
|-----------|------|------|
| keyword | - | 店舗名での検索キーワード |
| area | - | エリアでの絞り込み |

### レスポンス
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

## 関連PR
- #20 feat: 店舗一覧取得API実装

## 完了日
2025/12/25
