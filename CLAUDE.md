> 日本語で回答して下さい

## リポジトリ概要

本プロジェクトは、サンプル株式会社がファッションモール運営会社（FM様）に対して、アパレルショップ向けの会員証LINEミニアプリの開発を支援するプロジェクトの、主に資料管理と進捗管理を行うためのリポジトリです。

## プロジェクト概要と目的

従来、買い物客は利用するアパレルショップごとに個別の物理会員証カードを発行し、各店舗でポイント管理を行う必要がありました。本プロジェクトでは、この課題を解決するため、一つのLINEミニアプリ上で複数のアパレルショップの会員証を発行・管理できるデジタルソリューションを開発します。

既にFM様が提携しているベンダー（POS様）による店舗ごとの基幹システムが導入されているため、これらの既存システムと連携しながら、会員証の発行・認証・ポイント管理をデジタルで一元化することを目指します。

## ⚠️ 重要: リポジトリ構成

本プロジェクトは**複数のリポジトリ**で構成されています。作業前に必ず確認してください。

| リポジトリ | 用途 | URL |
|-----|---|-----|
| **apparel-membership-card** | ソースコード開発（./GitHub/issues） | https://github.com/example-corp/apparel-membership-card |
| **apparel-membership-card.wiki** | ドキュメント（./GitHub/wiki） | https://github.com/example-corp/apparel-membership-card.wiki |
| **apparel-membership-context** | コンテキスト管理（MTG/、共有資料/、Backlog/、Figma/） | このリポジトリ |

### 注意事項
- **GitHub CLIでPRやIssueを操作する際は、必ず `--repo example-corp/apparel-membership-card` を指定してください**
- このリポジトリは開発用ではなく、コンテキスト管理用です
- `GitHub/` フォルダ内のファイルは、上記リポジトリからエクスポートされたデータです

## フォルダ構成

```
apparel-membership-context/
├── MTG/                          # MTGの文字起こしと議事録
│   └── {YYYYMMDD}/              # 日付ごとのフォルダ
│       ├── *_minutes.md         # 議事録
│       └── *.docx               # Teamsの自動文字起こし
├── 共有資料/                     # 要件整理や見積もりなどの共有資料
│   ├── 要件整理/                # 要件に関する資料・シーケンス図
│   └── 見積もり/                # 見積もり資料
├── Backlog/                      # Backlogからエクスポートされたデータ
│   ├── issues/                  # Backlog課題（FM様との協議事項・依頼事項）
│   ├── documents/               # Backlogドキュメント（IF仕様書・シーケンス図）
│   └── wiki/                    # Backlog Wiki
├── GitHub/                       # GitHubからエクスポートされたデータ
│   ├── issues/                  # GitHub Issues（PBI・開発タスク）
│   │   ├── [PBI] xxx/          # Product Backlog Item
│   │   │   └── sub-issues/     # 子Issue（BE/FEタスク）
│   │   └── その他-issue/        # その他のIssue
│   ├── src/                     # ソースコード
│   └── wiki/                    # GitHub Wiki（設計書・手順書）
│       ├── 1.プロジェクト概要/
│       ├── 2.要件定義/
│       ├── 3.設計/              # DB設計、API設計、コーディング規約など
│       ├── 4.開発/              # ブランチ戦略、レビュー観点表など
│       ├── 5.テスト/
│       ├── 6.デプロイ/
│       ├── 7.保守・運用/
│       └── 8.リリース/
└── Figma/                        # Figmaからエクスポートされたデータ
```

## 作業開始時の自律的コンテキスト探索

**作業を開始する前に、必ず関連するコンテキストを自律的に探索してください。**

### 探索の優先順位

1. **Issue/タスクの確認**: `GitHub/issues/` から関連するIssueを確認
2. **設計書の確認**: `GitHub/wiki/3.設計/` から関連する設計書を確認
3. **要件の確認**: `GitHub/wiki/2.要件定義/` または `Backlog/documents/` から要件を確認
4. **過去の協議内容**: `Backlog/issues/` から関連する協議履歴を確認
5. **議事録の確認**: `MTG/` から関連するMTGの議事録を確認

### 探索のガイドライン

| 作業内容 | 探索すべきフォルダ |
|----|----|
| 新機能の実装 | `GitHub/issues/[PBI]*/`, `GitHub/wiki/3.設計/`, `Backlog/documents/` |
| バグ修正 | `GitHub/issues/`, `GitHub/wiki/3.設計/コーディング規約.md` |
| API開発 | `GitHub/wiki/API設計.md`, `Backlog/documents/IF仕様書.md`, `GitHub/wiki/3.設計/外部API仕様.md` |
| インフラ・デプロイ | `GitHub/wiki/6.デプロイ/`, `GitHub/wiki/3.設計/インフラ構成図.md` |
| 顧客との調整事項 | `Backlog/issues/`, `MTG/` |
| シーケンス図・仕様確認 | `Backlog/documents/`, `共有資料/要件整理/` |

### 自律探索の実行例

```
1. ユーザーから「店舗一覧機能を実装して」と依頼された場合:
   → GitHub/issues/ で「店舗一覧」「店舗詳細」を検索。
   → Backlog/issues/ で「店舗一覧」「店舗詳細」に関連するIssueを確認。完了サマリから決定した仕様などが確認可能。
   → GitHub/wiki/3.設計/ でAPI設計、DB設計を確認
   → Backlog/documents/ でシーケンス図、IF仕様書等を確認
```

**必ず関連コンテキストを読んでから作業を開始してください。推測で作業しないでください。**
