---
description: ステージングされている差分についてcommitメッセージを考えてcommitを作成
---
今ステージングされている差分について、Conventional Commitに基づいた日本語のcommitメッセージを考えてcommitを作成してください。

## 実行手順

1. `git status` と `git diff --staged` を実行して、ステージングされている変更内容を確認
2. 変更内容に基づいて、.github/.COMMIT_TEMPLATEに従ってcommitメッセージを作成
3. `git commit -m "<message>"` でcommitを作成

## 重要な制約

- エラーが発生しているファイルはcommitしない
- リモートへのpushは**行わない**
- commitメッセージにClaude Codeの署名は**追加しない**
- ghコマンドが使用できない場合は、`gh`コマンドの有無の確認と`gh auth login`コマンドの実行を促してください。
