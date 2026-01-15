import features/account/adaptor/registry/actor.{type AccountMessage}
import features/account/port
import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor as ac
import gleam/result

pub type RegistryMessage {
  GetOrCreateAccount(
    account_id: String,
    initial_balance: Int,
    reply_to: Subject(Result(Subject(AccountMessage), String)),
  )
}

pub opaque type Registry {
  Registry(subject: Subject(RegistryMessage))
}

type RegistryState {
  RegistryState(accounts: Dict(String, Subject(AccountMessage)))
}

pub fn start() -> Result(Registry, ac.StartError) {
  let initial_state = RegistryState(accounts: dict.new())

  initial_state
  |> ac.new()
  |> ac.on_message(handle_message)
  |> ac.start()
  |> result.map(fn(started) { Registry(started.data) })
}

pub fn subject(registry: Registry) -> Subject(RegistryMessage) {
  let Registry(subject) = registry
  subject
}

fn handle_message(
  state: RegistryState,
  message: RegistryMessage,
) -> ac.Next(RegistryState, RegistryMessage) {
  case message {
    GetOrCreateAccount(account_id, initial_balance, reply_to) -> {
      case dict.get(state.accounts, account_id) {
        Ok(subject) -> {
          process.send(reply_to, Ok(subject))
          ac.continue(state)
        }
        Error(_) -> {
          case actor.start(account_id, initial_balance) {
            Ok(account_actor) -> {
              let subject = actor.subject(account_actor)
              let new_accounts =
                dict.insert(state.accounts, account_id, subject)
              process.send(reply_to, Ok(subject))
              ac.continue(RegistryState(accounts: new_accounts))
            }
            Error(_) -> {
              process.send(reply_to, Error("Failed to create account"))
              ac.continue(state)
            }
          }
        }
      }
    }
  }
}

// Registry を AccountRepository Port として提供
pub fn to_repository(reg: Registry) -> port.AccountRepository {
  port.AccountRepository(
    create_account: fn(account_id: String, initial_balance: Int) {
      create_account(reg, account_id, initial_balance)
    },
    get_balance: fn(account_id: String) { get_balance(reg, account_id) },
    deposit: fn(account_id: String, amount: Int) {
      deposit(reg, account_id, amount)
    },
    withdraw: fn(account_id: String, amount: Int) {
      withdraw(reg, account_id, amount)
    },
  )
}

fn create_account(
  reg: Registry,
  account_id: String,
  initial_balance: Int,
) -> Result(Nil, String) {
  let registry_subject = subject(reg)

  let result =
    fn(reply_to) {
      GetOrCreateAccount(
        account_id: account_id,
        initial_balance: initial_balance,
        reply_to: reply_to,
      )
    }
    |> process.call(registry_subject, 1000, _)

  case result {
    Ok(_actor_subject) -> Ok(Nil)
    Error(msg) -> Error(msg)
  }
}

fn get_balance(reg: Registry, account_id: String) -> Result(Int, String) {
  // TODO: Phase 2で実装
  let _ = reg
  let _ = account_id
  Error("Not implemented yet")
}

fn deposit(reg: Registry, account_id: String, amount: Int) -> Result(Int, String) {
  // TODO: 実装
  let _ = reg
  let _ = account_id
  let _ = amount
  Error("Not implemented yet")
}

fn withdraw(
  reg: Registry,
  account_id: String,
  amount: Int,
) -> Result(Int, String) {
  // TODO: 実装
  let _ = reg
  let _ = account_id
  let _ = amount
  Error("Not implemented yet")
}
