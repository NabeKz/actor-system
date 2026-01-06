import features/account/model
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

// Actor のインターフェース
pub type AccountMessage {
  GetBalance(reply_to: Subject(Int))
  Deposit(amount: Int, reply_to: Subject(Result(Int, String)))
  Withdraw(amount: Int, reply_to: Subject(Result(Int, String)))
}

pub opaque type AccountActor {
  AccountActor(subject: Subject(AccountMessage))
}

pub fn start(
  account_id: String,
  initial_balance: Int,
) -> Result(AccountActor, actor.StartError) {
  let initial_state =
    model.AccountState(account_id:, balance: initial_balance, events: [])

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
  case amount > 0, amount <= state.balance {
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
