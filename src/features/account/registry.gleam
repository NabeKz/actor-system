import features/account/actor.{type AccountMessage}
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

type RegistryState {
  RegistryState(accounts: Dict(String, Subject(AccountMessage)))
}

pub opaque type Registry {
  Registry(subject: Subject(RegistryMessage))
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
