# アパレル会員証LINEミニアプリ - コンテキストリポジトリ

## ⚠️ 重要: マルチリポジトリ構成

本プロジェクトは**複数のリポジトリ**で構成されています。

| リポジトリ | 用途 | URL |
|-----------|------|-----|
| **apparel-membership-card-context** | コンテキスト管理（議事録/資料/エクスポートデータ） | https://github.com/takagakiryuheiCM/apparel-membership-card-context（このリポジトリ） |
| **apparel-membership-card** | ソースコード開発（PR/CI/Issue管理） | https://github.com/takagakiryuheiCM/apparel-membership-card |

> **Note**: このリポジトリは開発用ではなく、コンテキスト管理用です。ソースコードの開発やIssue管理は `apparel-membership-card` リポジトリで行います。

### 関連リンク

| 種別 | URL |
|------|-----|
| GitHub Issues | https://github.com/takagakiryuheiCM/apparel-membership-card/issues |
| GitHub Wiki | https://github.com/takagakiryuheiCM/apparel-membership-card/wiki |

---

## プロジェクト概要

本プロジェクトは、サンプル株式会社がファッションモール運営会社（FM様）に対して、アパレルショップ向けの会員証LINEミニアプリの開発を支援するプロジェクトです。

従来、買い物客は利用するアパレルショップごとに個別の物理会員証カードを発行し、各店舗でポイント管理を行う必要がありました。本プロジェクトでは、この課題を解決するため、一つのLINEミニアプリ上で複数のアパレルショップの会員証を発行・管理できるデジタルソリューションを開発します。

既にFM様が提携しているベンダー（POS様）による店舗ごとの基幹システムが導入されているため、これらの既存システムと連携しながら、会員証の発行・認証・ポイント管理をデジタルで一元化することを目指します。

## 背景

### 現状の課題
- **物理カードの煩雑さ**: 買い物客は店舗ごとに個別の物理会員証カードを発行・携帯する必要がある
- **ポイント管理の手間**: 各店舗で個別にポイント確認が必要で、利便性が低い
- **管理の分散**: 複数の店舗を利用する場合、会員証やポイントの一元管理ができない
- **ユーザー体験の低下**: カードの紛失リスクや持ち歩きの負担がある

## 目的

買い物客とアパレルショップをLINEミニアプリ上でつなぎ、会員証の発行・認証・ポイント管理をデジタルで一元化すること

### 具体的な達成目標
- **デジタル化**: 物理カードからデジタル会員証への移行
- **一元管理**: 一つのLINEミニアプリで複数店舗の会員証を管理
- **利便性向上**: スマートフォン一つで複数店舗の利用が可能
- **アクセシビリティ**: 幅広い年齢層にも使いやすい直感的でシンプルなUI

## 開発戦略

LINEミニアプリ上で会員証サービスを提供するための一式のテンプレートコードが揃ったアセットプロジェクトを使用して、本プロジェクト用にカスタマイズします。

---

## ディレクトリ構成

```
apparel-membership-card-context/
├── MTG/                  # 議事録（Teamsの自動文字起こしを配置）
├── 共有資料/              # 要件整理・見積もりなど（Google Driveからインポート）
├── Backlog/              # Backlogからエクスポートされたデータ
│   ├── documents/        # 仕様書・シーケンス図など
│   └── issues/           # Backlog課題
├── GitHub/               # GitHubからエクスポートされたデータ
│   ├── issues/           # Issue定義ファイル → GitHubリポジトリにIssueとして作成済み
│   ├── src/              # ソースコード（開発リポジトリのミラー）
│   └── wiki/             # GitHub Wikiのエクスポート
└── Figma/                # Figmaからエクスポートされたデザインデータ
```

### GitHub/issues/ について

`GitHub/issues/` 配下のMarkdownファイルは、Issue定義のマスターデータです。
これらは `gh` コマンドを使用して、開発用リポジトリ（[apparel-membership-card](https://github.com/takagakiryuheiCM/apparel-membership-card)）にIssueとして作成されています。

---

## セットアップ

### ルールファイルの自動生成

```bash
pnpm dlx rulesync@latest generate
```

### Backlogの同期方法

BacklogのAPIキーを取得し、`.env`ファイルに設定して下さい。
その後、以下のコマンドを実行して下さい。

```bash
pnpm dlx backlog-exporter@latest all --domain $DOMAIN --projectIdOrKey $PROJECT_KEY --apiKey $BACKLOG_API_KEY --output ./Backlog
```
