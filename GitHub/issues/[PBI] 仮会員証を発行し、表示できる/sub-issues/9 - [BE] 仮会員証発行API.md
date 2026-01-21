# [BE] 仮会員証発行API

## Issue情報
- **Issue番号**: #17
- **ステータス**: ✅ Done
- **ラベル**: backend
- **親Issue**: #3 [PBI] 仮会員証を発行し、表示できる
- **担当者**: @takahashi

## 概要

仮会員証を発行するAPIを実装する。

## タスク

- [x] `POST /api/membership-cards` エンドポイントの実装
- [x] POS Gateway への仮会員登録リクエスト
- [x] MembershipCardsテーブルへの保存（status=temporary）
- [x] TTL設定（30分後に自動削除）
- [x] ユニットテスト・結合テストの作成

## 実装詳細

### エンドポイント
`POST /api/membership-cards`

### リクエスト
```json
{
  "shopCode": "SHP001"
}
```

### レスポンス
```json
{
  "cardId": "550e8400-e29b-41d4-a716-446655440000#SHP001#2026-01-10T10:00:00+09:00",
  "memberId": "TMP-550E8400E29B41D4",
  "qrCode": "data:image/png;base64,iVBORw0KGgo...",
  "expiresAt": "2026-01-10T10:30:00+09:00",
  "status": "temporary"
}
```

### シーケンス
1. リクエスト受信
2. ユーザー情報取得（DynamoDB）
3. POS Gateway に仮会員登録リクエスト
4. MembershipCardsテーブルに保存
5. レスポンス返却

## 関連PR
- #25 feat: 仮会員証発行API実装

## 完了日
2026/01/08
