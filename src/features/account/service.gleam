// Use Case層: ビジネスロジックの調整

import features/account/adaptor/registry/actor
import features/account/adaptor/registry/registry
import features/account/model.{type Balance}
import gleam/erlang/process.{type Subject}

pub type AccountService {
  AccountService(registry: registry.Registry, generate_id: fn() -> String)
}

pub fn new(
  registry: registry.Registry,
  generate_id: fn() -> String,
) -> AccountService {
  AccountService(registry:, generate_id:)
}

pub type CreateAccountResult {
  CreateAccountResult(account_id: String, balance: Balance)
}

pub fn create_account(
  service: AccountService,
  initial_balance: Int,
) -> Result(CreateAccountResult, String) {
  let account_id = service.generate_id()
  let registry_subject = registry.subject(service.registry)

  let result =
    fn(reply_to: Subject(Result(Subject(actor.AccountMessage), String))) {
      registry.GetOrCreateAccount(
        account_id: account_id,
        initial_balance: initial_balance,
        reply_to: reply_to,
      )
    }
    |> process.call(registry_subject, 1000, _)

  case result {
    Ok(_account_subject) -> {
      let assert Ok(balance) = model.new_balance(initial_balance)
      Ok(CreateAccountResult(account_id:, balance:))
    }
    Error(error_msg) -> Error(error_msg)
  }
}
