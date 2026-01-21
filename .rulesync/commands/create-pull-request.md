---
description: コミットログと手順書を元にPRを作成
---
# Create Pull Request

今回のやったことの回想からPRの内容を作成。以下のテンプレートに従って作成してください。

## PRテンプレート

```markdown
## 課題へのリンク

<!-- * 課題へのリンクは？ -->

## やったこと

<!-- * このプルリクで何をしたのか？ -->

## できるようになること

<!-- * 何ができるようになるのか？（あれば。無いなら「無し」でOK） -->

## できなくなること

<!-- * 何ができなくなるのか？（あれば。無いなら「無し」でOK） -->

## 動作確認

<!-- * どのような動作確認を行ったのか？　結果はどうか？ -->
<!-- * フロントエンドタスクとバックエンドタスクで該当する方のみ記載してください -->
### UI（フロントエンドタスクの場合）

| 実装画面 | Figmaデザイン |
|:---:|:---:|
| <img width="255" alt="実装画面のスクリーンショット" src="実装画面の画像URL" /> | <img width="255" alt="Figmaデザインのスクリーンショット" src="Figmaデザインの画像URL" /> |

### API（バックエンドタスクの場合）
<!-- * 例：POST /membership-cardsの場合 -->
**エンドポイント:** `POST /membership-cards`

**Request:**
```bash
curl -X POST 'https://api.dev.golfrange-line.golfdigest.co.jp/membership-cards' \
  -H 'accept: */*' \
  -H 'authorization: Bearer YOUR_LINE_ACCESS_TOKEN' \
  -H 'content-type: application/json' \
  -H 'origin: https://localhost:3000' \
  -H 'referer: https://localhost:3000/' \
  -d '{
    "facilityCode": "FAC005"
  }'
```

**Response (200 OK):**
```json
{
  "memberId": "TMP-DC2C744EB9C24686",
  "facilityCode": "FAC005",
  "facilityName": "渋谷ゴルフ練習場",
  "status": "temporary",
  "expiresAt": "2026-01-08T15:47:42.519+09:00",
  "createdAt": "2026-01-08T15:17:42.519+09:00"
}
```

## その他

<!-- * レビュワーへの参考情報（実装上の懸念点や注意点などあれば記載） -->
```

## 実行手順

### Phase 1: 情報収集

1. ブランチ名やコミットメッセージから関連Issue番号を特定
2. 今回のやったことの回想からPRの内容を作成。何も情報がない場合は、commitのログを元に作成。
3. テンプレートに従って作成。

### Phase 2: PR本文の作成

「やったこと」セクションには、**各項目にコミットハッシュを付けて記載**する。

#### 「やったこと」の記載例

```markdown
## やったこと

1. 設定ファイルの追加 abc1234
2. DBスキーマの変更 def5678
3. 会員証発行APIのエンドポイント追加 ghi9012
4. ユニットテスト追加 jkl3456
```

※ GitHubではコミットハッシュが自動的にリンクになる

### Phase 3: PR作成

1. 未プッシュのコミットがある場合、**ユーザーにプッシュしてよいか確認する**
2. 確認後、`git push -u origin {branch-name}` でリモートにプッシュ
3. `gh pr create` でPRを作成
4. 作成したPRのURLを表示

## 重要な制約

- PRの本文は**日本語**で作成
- AIの署名は**追加しない**
- ghコマンドが使用できない場合は、`gh`コマンドの有無の確認と`gh auth login`コマンドの実行を促す
- 想定外の作業が発生したり、エラーが見つかった場合はユーザーに相談
