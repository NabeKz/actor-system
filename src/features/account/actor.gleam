import features/account/model.{type Balance}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

// Actor のインターフェース
pub type AccountMessage {
  GetBalance(reply_to: Subject(Balance))
  Deposit(amount: Int, reply_to: Subject(Result(Balance, String)))
  Withdraw(amount: Int, reply_to: Subject(Result(Balance, String)))
}

pub opaque type AccountActor {
  AccountActor(subject: Subject(AccountMessage))
}

pub fn start(
  account_id: String,
  initial_balance: Int,
) -> Result(AccountActor, actor.StartError) {
  let assert Ok(balance) = model.new_balance(initial_balance)
  let initial_state = model.AccountState(account_id:, balance:, events: [])

  actor.new(initial_state)
  |> actor.on_message(handle_message)
  |> actor.start()
  |> result.map(fn(started) { AccountActor(started.data) })
}

pub fn handle_message(
  state: model.AccountState,
  message: AccountMessage,
) -> actor.Next(model.AccountState, AccountMessage) {
  case message {
    GetBalance(reply_to) -> {
      process.send(reply_to, state.balance)
      actor.continue(state)
    }
    Deposit(amount, reply_to) -> {
      let event = validate_deposit(state, amount)
      case event {
        Ok(e) -> {
          let new_state = state |> model.apply(e)
          process.send(reply_to, Ok(new_state.balance))
          actor.continue(new_state)
        }
        Error(e) -> {
          process.send(reply_to, Error(e))
          actor.continue(state)
        }
      }
    }
    Withdraw(amount, reply_to) -> {
      let event = validate_withdraw(state, amount)
      case event {
        Ok(e) -> {
          let new_state = state |> model.apply(e)
          process.send(reply_to, Ok(new_state.balance))
          actor.continue(new_state)
        }
        Error(e) -> {
          process.send(reply_to, Error(e))
          actor.continue(state)
        }
      }
    }
  }
}

pub fn subject(actor: AccountActor) -> Subject(AccountMessage) {
  actor.subject
}

fn validate_deposit(
  state: model.AccountState,
  amount: Int,
) -> Result(model.AccountEvent, String) {
  case amount > 0 {
    True -> {
      let timestamp = 0
      model.MoneyDeposited(state.account_id, amount, timestamp)
      |> Ok()
    }
    False -> {
      Error("Amount must be positive")
    }
  }
}

fn validate_withdraw(
  state: model.AccountState,
  amount: Int,
) -> Result(model.AccountEvent, String) {
  let current_balance = model.balance_to_int(state.balance)
  case amount > 0, amount <= current_balance {
    True, True -> {
      let timestamp = 0
      model.MoneyWithdrawn(state.account_id, amount, timestamp)
      |> Ok()
    }
    False, _ -> {
      Error("Amount must be positive")
    }
    _, False -> {
      Error("Insufficient balance")
    }
  }
}
