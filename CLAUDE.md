# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gleamで構築されたアプリケーション。ActorモデルとEvent Sourcingを学ぶための学習プロジェクト。

```sh
gleam run           # HTTPサーバー起動（ポート5000）
gleam test          # テスト実行
gleam build         # ビルド
gleam format        # コードフォーマット
```

## API Examples

```sh
curl localhost:5000/health
curl -X POST localhost:5000/auctions
```

## Architecture

### リクエストフロー

```
HTTP Request → routes.gleam → handlers/ → cqrs/command.gleam → Actor → Adapter(on_file等)
                                          cqrs/query.gleam
```

### Feature モジュール構造

各featureは以下のレイヤーで構成される（`features/auction/` が現在の実装例）:

- `model.gleam` — ドメインモデル・イベント型・純粋関数（apply, validate等）。副作用なし
- `application.gleam` — Port定義（関数型エイリアスによるインターフェース）
- `cqrs/command.gleam` — 書き込み操作。Portを通じてインフラを呼び出す
- `cqrs/query.gleam` — 読み取り操作
- `adaptor/actor.gleam` — Actor実装。Mailboxで並行アクセスを直列化
- `adaptor/on_file.gleam` — ファイル永続化アダプター（Portの具象実装）

### 依存関係の組み立て（Composition）

`app/composition.gleam` が全依存関係を組み立てる。Portは関数型として定義され、部分適用で具象実装を注入する:

```
composition.build_handlers()
  → file.init() でファイルストレージ初期化
  → on_file.save_event(file, _) で部分適用（SaveEvent Portの実装）
  → actor.initialize(save_event) でActor起動
  → actor.create(subject) でPort互換関数を返す
  → handlers.build() にPort関数を注入
```

### Event Sourcing

すべての状態変更はイベント（`AuctionEvent`）として記録。`model.gleam` の `apply()` でイベントを状態に適用。処理順序: **検証 → 永続化 → apply**（常にこの順序）。

### Actor

Actorの役割はMailboxによる直列化のみ。ビジネスロジックは `model.gleam` に置く。Subjectをクロージャでキャプチャし、Port互換の関数を返すパターンを使う。

### 共有レジストリ

`shared/registry.gleam`（Dict版）と `shared/registry_ets.gleam`（ETS版）の2実装あり。ETS版はread時にActorを経由しないFast Pathを持つ。

## Project Phases

詳細は `docs/plan.md` 参照。

## Development Notes

### 新しいイベント追加

1. `features/<feature>/model.gleam` の Event型に追加
2. `apply()` にイベント処理を追加
3. Actor の `handle_message()` で検証・永続化・apply

### 新しいfeature追加

1. `features/<name>/model.gleam` でドメインモデル・イベント・純粋関数を定義
2. `features/<name>/application.gleam` でPort型を定義
3. `features/<name>/cqrs/` にcommand/queryを実装
4. `features/<name>/adaptor/` にActor・永続化アダプターを実装
5. `app/composition.gleam` で依存関係を組み立て
6. `app/handlers/` にHTTPハンドラを追加
7. `app/routes.gleam` にルートを追加

### 実装順序

型定義 → model（ボトムアップ）→ command → actor → handler → composition → routes
