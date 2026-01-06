import features/account/actor
import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}

pub type RegistryMessage {
  GetOrCreateAccount(
    account_id: String,
    initial_balance: Int,
    reply_to: Subject(Result(Subject(actor.AccountMessage), String)),
  )
}

pub type RegistryState {
  RegistryState(accounts: Dict(String, Subject(actor.AccountMessage)))
}
