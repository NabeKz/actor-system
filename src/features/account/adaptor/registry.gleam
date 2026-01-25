import features/account/adaptor/registry/actor.{type AccountMessage}
import features/account/port
import gleam/otp/actor as ac
import gleam/result
import shared/registry_ets as registry

pub opaque type Registry {
  Registry(inner: registry.Registry(AccountMessage))
}

pub fn start() -> Result(Registry, ac.StartError) {
  registry.start()
  |> result.map(Registry)
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
  let Registry(inner) = reg
  let factory = fn() {
    actor.start(account_id, initial_balance)
    |> result.map(actor.subject)
  }

  registry.create(inner, account_id, factory)
  |> result.map(fn(_) { Nil })
}

fn get_balance(reg: Registry, account_id: String) -> Result(Int, String) {
  // TODO: Phase 2で実装
  let _ = reg
  let _ = account_id
  Error("Not implemented yet")
}

fn deposit(
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
