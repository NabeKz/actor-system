import features/account/adaptor/registry/actor.{type AccountMessage}
import features/account/port.{type AccountId, AccountId}
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

// 各操作のファクトリー関数
pub fn create_account(reg: Registry) -> port.CreateAccount {
  fn(account_id: AccountId, initial_balance: Int) {
    let AccountId(id) = account_id
    let Registry(inner) = reg
    let factory = fn() {
      actor.start(id, initial_balance)
      |> result.map(actor.subject)
    }

    registry.create(inner, id, factory)
    |> result.map(fn(_) { Nil })
  }
}

pub fn get_balance(reg: Registry) -> port.GetBalance {
  fn(account_id: AccountId) {
    // TODO: Phase 2で実装
    let _ = reg
    let _ = account_id
    Error("Not implemented yet")
  }
}

pub fn deposit(reg: Registry) -> port.Deposit {
  fn(account_id: AccountId, amount: Int) {
    // TODO: 実装
    let _ = reg
    let _ = account_id
    let _ = amount
    Error("Not implemented yet")
  }
}

pub fn withdraw(reg: Registry) -> port.Withdraw {
  fn(account_id: AccountId, amount: Int) {
    // TODO: 実装
    let _ = reg
    let _ = account_id
    let _ = amount
    Error("Not implemented yet")
  }
}
