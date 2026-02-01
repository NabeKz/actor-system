// Command層: 状態変更を伴う操作（CQRS）

import features/account/model.{type AccountId, type Balance}

pub type CreateAccount =
  fn(AccountId, Int) -> Result(Nil, String)

pub type Deposit =
  fn(AccountId, Int) -> Result(Int, String)

pub type Withdraw =
  fn(AccountId, Int) -> Result(Int, String)

pub type CreateAccountResult {
  CreateAccountResult(account_id: AccountId, balance: Balance)
}

pub fn create_account(
  create: CreateAccount,
  generate_id: fn() -> AccountId,
  initial_balance: Int,
) -> Result(CreateAccountResult, String) {
  let account_id = generate_id()

  case create(account_id, initial_balance) {
    Ok(_) -> {
      let assert Ok(balance) = model.new_balance(initial_balance)
      Ok(CreateAccountResult(account_id:, balance:))
    }
    Error(error_msg) -> Error(error_msg)
  }
}

pub fn deposit(
  deposit_fn: Deposit,
  account_id: AccountId,
  amount: Int,
) -> Result(Int, String) {
  deposit_fn(account_id, amount)
}

pub fn withdraw(
  withdraw_fn: Withdraw,
  account_id: AccountId,
  amount: Int,
) -> Result(Int, String) {
  withdraw_fn(account_id, amount)
}
