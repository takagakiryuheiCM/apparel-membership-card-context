# Backlog エクスポートデータ

このフォルダには、Backlogからエクスポートされたデータが格納されています。

## フォルダ構成

- `issues/` - Backlog課題（FM様との協議事項・依頼事項）
- `documents/` - Backlogドキュメント（IF仕様書・シーケンス図）
- `wiki/` - Backlog Wiki

## 同期方法

```bash
pnpm dlx backlog-exporter@latest all --domain $DOMAIN --projectIdOrKey $PROJECT_KEY --apiKey $BACKLOG_API_KEY --output ./Backlog
```

## 注意事項

- このフォルダのファイルは自動生成されます
- 手動での編集は避けてください
- 最新の情報はBacklogを参照してください
