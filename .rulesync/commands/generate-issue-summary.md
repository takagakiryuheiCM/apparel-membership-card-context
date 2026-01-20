---
description: 'GitHub Issuesの進捗サマリーを生成する'
targets:
  - '*'
---
GitHub/issues/配下のPBI（Product Backlog Item）の進捗状況をサマリーとして生成します。

## 手順

1. `GitHub/issues/[PBI]*/` 配下の全てのPBIを読み取る
2. 各PBIのステータス（Done/In Progress/Todo）を抽出する
3. サブIssueの完了状況も集計する
4. サマリーをMarkdown形式で出力する

## 出力フォーマット

```markdown
# PBI進捗サマリー

## 概要
- 完了: X件
- 進行中: Y件
- 未着手: Z件

## PBI一覧

| PBI | ステータス | サブIssue進捗 |
|-----|----------|--------------|
| [PBI名] | Done | 2/2 |
| [PBI名] | In Progress | 1/3 |
```

## 注意事項

- ステータスはIssueファイル内の「ステータス」行から抽出する
- サブIssueは`sub-issues/`配下のファイルを集計する
