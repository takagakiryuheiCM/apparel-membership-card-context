# [BE] 会員情報登録API

## Issue情報
- **Issue番号**: #3
- **ステータス**: ✅ Done
- **ラベル**: backend
- **親Issue**: #2 [PBI] 会員情報が登録できる
- **担当者**: @takahashi

## 概要

会員情報を登録するAPIを実装する。

## タスク

- [x] `POST /api/users` エンドポイントの実装
- [x] リクエストバリデーションの実装
- [x] Usersテーブルへの保存処理
- [x] LINE UserIDとの紐付け処理
- [x] ユニットテストの作成

## 実装詳細

### エンドポイント
`POST /api/users`

### リクエスト
```json
{
  "lastName": "山田",
  "firstName": "太郎",
  "lastNameKana": "やまだ",
  "firstNameKana": "たろう",
  "birthDate": "19900101",
  "gender": 0,
  "postalCode1": "150",
  "postalCode2": "0001",
  "prefectureCode": 13,
  "city": "渋谷区",
  "address": "神宮前1-2-3",
  "building": "○○マンション101",
  "phoneNumber": "09012345678"
}
```

### レスポンス
```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2025-12-20T10:00:00+09:00"
}
```

## 関連PR
- #15 feat: 会員情報登録API実装

## 完了日
2025/12/18
