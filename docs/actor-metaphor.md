# 郵便局メタファー - Actor モデルの理解

## 基本構造

```
🏛️ Registry Actor = 受付カウンター（案内所）
├─ お客さんを適切な窓口に案内
├─ 台帳（Dict）で窓口を管理
└─ 必要なら新しい窓口を開設

🏢 Account Actor = 各口座の窓口
├─ 窓口は独立して動く
├─ 一人ずつ順番に対応（メッセージキュー）
└─ バインダーで記録を管理（State）
```

## Message = 手紙

**手紙の構成**:
- 要件（GetBalance, Deposit, Withdraw）
- 詳細（amount など、省略可）
- 返信先（reply_to）

**現実世界との対応**:

| 現実世界 | Actor モデル |
|---------|-------------|
| 手紙を受け取る | `message` 引数 |
| 手紙を読む | `case message` |
| 考えて行動する | イベント作成・apply |
| 自分が変わる | `actor.continue(new_state)` |
| 返事を書く | `process.send(reply_to, ...)` |

## Actor の動き

```
handle_message = 窓口業務マニュアル
├─ 手紙を受け取る（message）
├─ 内容を読む（case message）
├─ 処理する（イベント作成、apply）
├─ お客さんに返事（process.send） ← 優先！お客さん待ってる
└─ 伝票をバインダーに閉じる（actor.continue） ← 内部整理
```

### コード例

```gleam
fn handle_message(state, message) {
  case message {
    // 手紙を開封
    Deposit(amount, reply_to) -> {
      // 1. 手紙の内容を理解
      case amount > 0 {
        True -> {
          // 2. 行動する（入金処理）
          let event = MoneyDeposited(state.account_id, amount, 0)
          let new_state = apply(state, event)

          // 3. 返事を書く（お客さん優先！）
          process.send(reply_to, Ok(new_state.balance))

          // 4. 自分の状態を更新（バインダーに記録）
          actor.continue(new_state)
        }
        False -> {
          // エラーの返事
          process.send(reply_to, Error("Amount must be positive"))
          // 状態は変えない（何も起きなかった）
          actor.continue(state)
        }
      }
    }
  }
}
```

## process.send と actor.continue の順序

**なぜこの順序？**

```gleam
process.send(reply_to, response)  // お客さんに返事（優先）
actor.continue(new_state)          // 事務処理（内部）
```

### 理由

1. **お客さん対応が最優先**
   - 窓口では待たせない
   - = `process.send` を先に実行

2. **事務処理は後回し**
   - バインダー整理は内部作業
   - = `actor.continue` は後

3. **構文的必然性**
   - 関数の戻り値は `actor.Next` である必要がある
   - 最後の式が戻り値になる
   - = `actor.continue` は必ず最後

### 戻り値の型

```gleam
process.send(...)    // → Nil を返す（副作用のみ）
actor.continue(...)  // → Next(state, message) を返す（これが関数の戻り値）
```

## 型の意味

### Before: Int（わかりにくい）

```gleam
Deposit(amount: Int, reply_to: Subject(Result(Int, String)))
//                                            ^^^ 何の数字？
```

パッと見で「何の Int？」がわからない

### After: Balance（明確）

```gleam
Deposit(amount: Int, reply_to: Subject(Result(Balance, String)))
//                                            ^^^^^^^ 残高だ！
```

**因果関係が明確**:
- 入金（Deposit）する → 新しい残高（Balance）が返る

### opaque type Balance

```gleam
pub opaque type Balance {
  Balance(Int)
}
```

**利点**:
- 外部から勝手に作れない → `new_balance()` を通す必要がある
- バリデーションが強制される → 負の数を防げる
- ドメインモデルが保護される → 不正な状態にならない

## Registry の役割

```
お客さん: 「口座番号123の窓口はどこですか？」
  ↓
受付: 台帳（Dict）を確認
  ↓
  ├─ 見つかった → 「3番窓口です」（Subject を返す）
  └─ 無い → 新しく窓口を開設 → 台帳に記録 → 「新設の4番窓口です」
```

### Registry の状態

```gleam
pub type RegistryState {
  RegistryState(
    accounts: Dict(String, Subject(AccountMessage))
    //        ^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    //        口座ID     その口座の窓口（Actor Subject）
  )
}
```

### Registry のメッセージ

```gleam
pub type RegistryMessage {
  GetOrCreateAccount(
    account_id: String,
    initial_balance: Int,
    reply_to: Subject(Result(Subject(AccountMessage), String))
    //                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
    //                       窓口への案内（Account Actor の Subject）
  )
}
```

## データフロー全体

```
HTTPリクエスト「口座123に100円入金」
  ↓
Registry（受付カウンター）
  ↓ 「口座123の窓口を探す」
  ↓ Dict.get(accounts, "123")
  ↓
  ├─ 見つかった → その窓口の Subject を返す
  └─ 無い → 新しく窓口を開設（actor.start）
            → 台帳に記録（Dict.insert）
            → 新しい窓口の Subject を返す
  ↓
Account Actor（窓口）
  ↓ Deposit メッセージ処理
  ├─ バリデーション（金額チェック）
  ├─ イベント作成（MoneyDeposited）
  ├─ 状態更新（apply → バインダーに記録）
  └─ 新しい残高を返信（process.send）
  ↓
HTTPレスポンス
```

## 設計の分離

### model.gleam = ドメイン知識（伝票の形式、バインダーの構造）

```gleam
// ドメインの基本型
pub opaque type Balance { Balance(Int) }

// イベント（処理済み伝票の記録）
pub type AccountEvent {
  AccountOpened(...)
  MoneyDeposited(...)
  MoneyWithdrawn(...)
}

// 状態（バインダーの内容）
pub type AccountState {
  AccountState(account_id: String, balance: Balance, events: List(AccountEvent))
}

// ドメインロジック
pub fn apply(state, event) -> AccountState
pub fn replay(state, events) -> AccountState
```

### actor.gleam = インターフェース（窓口の業務マニュアル）

```gleam
// お客さんが持ってくる伝票（窓口へのリクエスト）
pub type AccountMessage {
  GetBalance(reply_to: Subject(Balance))
  Deposit(amount: Int, reply_to: Subject(Result(Balance, String)))
  Withdraw(amount: Int, reply_to: Subject(Result(Balance, String)))
}

// 窓口を開く
pub fn start(account_id, initial_balance) -> Result(AccountActor, StartError)

// 窓口業務の手順
fn handle_message(state, message) -> actor.Next(...)
```

### registry.gleam = 受付（案内業務マニュアル）

```gleam
// 受付へのリクエスト
pub type RegistryMessage {
  GetOrCreateAccount(account_id, initial_balance, reply_to)
}

// 受付カウンターの台帳
pub type RegistryState {
  RegistryState(accounts: Dict(String, Subject(AccountMessage)))
}

// 受付業務
fn handle_message(state, message) -> actor.Next(...)
```

## まとめ

このメタファーで理解できること:

1. **Message = 手紙**
   - 要件、詳細、返信先が含まれる

2. **process.send = お客さんに返事**
   - 優先順位が高い（お客さんを待たせない）

3. **actor.continue = バインダーに記録**
   - 内部整理（事務処理）

4. **Registry = 受付カウンター**
   - 適切な窓口（Actor）に案内する

5. **Account Actor = 窓口**
   - 実際の業務処理を行う

6. **型 = 仕様書**
   - `Balance` という型で意図が明確になる
   - opaque type で安全性を確保

このメタファーを使えば、Actor モデルの本質が直感的に理解できます！
