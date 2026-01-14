// Adapter: Port インターフェースの実装
// Registry を使って AccountRepository Port を実装する

import features/account/adaptor/registry/registry
import features/account/application/port
import gleam/erlang/process

// Registry を AccountRepository Port として提供
pub fn from_registry(reg: registry.Registry) -> port.AccountRepository {
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
  reg: registry.Registry,
  account_id: String,
  initial_balance: Int,
) -> Result(Nil, String) {
  let registry_subject = registry.subject(reg)

  let result =
    fn(reply_to) {
      registry.GetOrCreateAccount(
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

fn get_balance(
  _reg: registry.Registry,
  _account_id: String,
) -> Result(Int, String) {
  // TODO: Phase 2で実装
  Error("Not implemented yet")
}

fn deposit(
  _reg: registry.Registry,
  _account_id: String,
  _amount: Int,
) -> Result(Int, String) {
  // TODO: 実装
  Error("Not implemented yet")
}

fn withdraw(
  _reg: registry.Registry,
  _account_id: String,
  _amount: Int,
) -> Result(Int, String) {
  // TODO: 実装
  Error("Not implemented yet")
}
