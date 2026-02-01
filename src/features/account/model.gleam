// ドメインモデル

pub type AccountId {
  AccountId(String)
}

// 残高（opaque type で型安全に）
pub opaque type Balance {
  Balance(Int)
}

// Balance のコンストラクタ
pub fn new_balance(value: Int) -> Result(Balance, String) {
  case value >= 0 {
    True -> Ok(Balance(value))
    False -> Error("Balance cannot be negative")
  }
}

// Balance を Int に変換
pub fn balance_to_int(balance: Balance) -> Int {
  let Balance(value) = balance
  value
}

// Balance に加算
pub fn add_balance(balance: Balance, amount: Int) -> Balance {
  let Balance(value) = balance
  Balance(value + amount)
}

// Balance から減算
pub fn subtract_balance(balance: Balance, amount: Int) -> Balance {
  let Balance(value) = balance
  Balance(value - amount)
}

pub type AccountEvent {
  AccountOpened(account_id: String, initial_balance: Int, timestamp: Int)
  MoneyDeposited(account_id: String, amount: Int, timestamp: Int)
  MoneyWithdrawn(account_id: String, amount: Int, timestamp: Int)
}

pub type AccountState {
  AccountState(account_id: String, balance: Balance, events: List(AccountEvent))
}

pub fn apply(state: AccountState, event: AccountEvent) -> AccountState {
  case event {
    AccountOpened(account_id, initial_balance, _) -> {
      let assert Ok(balance) = new_balance(initial_balance)
      AccountState(account_id:, balance:, events: [event, ..state.events])
    }
    MoneyDeposited(_, amount, _) ->
      AccountState(
        ..state,
        balance: add_balance(state.balance, amount),
        events: [event, ..state.events],
      )
    MoneyWithdrawn(_, amount, _) ->
      AccountState(
        ..state,
        balance: subtract_balance(state.balance, amount),
        events: [event, ..state.events],
      )
  }
}

pub fn replay(state: AccountState, events: List(AccountEvent)) -> AccountState {
  case events {
    [] -> state
    [event, ..other] -> state |> apply(event) |> replay(other)
  }
}
