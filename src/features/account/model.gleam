import gleam/erlang/process.{type Subject}

pub type AccountEvent {
  AccountOpened(account_id: String, initial_balance: Int, timestamp: Int)
  MoneyDeposited(account_id: String, amount: Int, timestamp: Int)
  MoneyWithdrawn(account_id: String, amount: Int, timestamp: Int)
}

pub type AccountMessage {
  GetBalance(reply_to: Subject(Int))
  Deposit(amount: Int, reply_to: Subject(Result(Int, String)))
  Withdraw(amount: Int, reply_to: Subject(Result(Int, String)))
}

pub type AccountState {
  AccountState(account_id: String, balance: Int, events: List(AccountEvent))
}

pub fn apply(state: AccountState, event: AccountEvent) -> AccountState {
  case event {
    AccountOpened(account_id, balance, _) ->
      AccountState(account_id:, balance:, events: [event, ..state.events])
    MoneyDeposited(_, amount, _) ->
      AccountState(..state, balance: state.balance + amount, events: [
        event,
        ..state.events
      ])
    MoneyWithdrawn(_, amount, _) ->
      AccountState(..state, balance: state.balance - amount, events: [
        event,
        ..state.events
      ])
  }
}

pub fn replay(state: AccountState, events: List(AccountEvent)) -> AccountState {
  case events {
    [] -> state
    [event, ..other] -> state |> apply(event) |> replay(other)
  }
}
