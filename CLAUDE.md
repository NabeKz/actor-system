# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gleamで構築された分散銀行アプリケーション。ActorモデルとEvent Sourcingを学ぶための学習プロジェクト。

## Commands

```sh
gleam run           # HTTPサーバー起動（ポート5000）
gleam test          # テスト実行
gleam build         # ビルド
gleam format        # コードフォーマット
```

## Core Concepts

### Actor階層

Account Registry Actorが複数のAccount Actorを管理。各アカウントは独立したActorで、Mailboxにより並行アクセスが自動的に直列化される。

### Event Sourcing

すべての状態変更はイベントとして記録。`model.gleam` の `apply()` でイベントを適用し、`replay()` でイベントリストから状態を再構築。

### CQRS

`application/command.gleam` が状態変更、`application/query.gleam` が読み取りを担当。

### Port/Adapter

`port.gleam` がインターフェース定義、`adaptor/` が実装。アプリケーション層はインフラ詳細（Actor/Subject）を知らない。

## Project Phases

詳細は `docs/plan.md` 参照。現在 Phase 1（基本Actor + HTTP API）を実装中。

## Development Notes

### 新しいイベント追加

1. `model.gleam` の `AccountEvent` に追加
2. `apply()` にイベント処理を追加
3. Actor の message handler で検証・イベント生成

### 新しいActorメッセージ追加

1. `adaptor/registry/actor.gleam` の `AccountMessage` に追加
2. `handle_message()` にハンドラを追加
3. Port に対応するメソッドを追加
