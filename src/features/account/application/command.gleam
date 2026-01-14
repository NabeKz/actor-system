// Command層: 状態変更を伴う操作（CQRS）

import features/account/application/port
import features/account/model.{type Balance}

pub type AccountCommand {
  AccountCommand(
    repository: port.AccountRepository,
    generate_id: fn() -> String,
  )
}

pub fn new(
  repository: port.AccountRepository,
  generate_id: fn() -> String,
) -> AccountCommand {
  AccountCommand(repository:, generate_id:)
}

pub type CreateAccountResult {
  CreateAccountResult(account_id: String, balance: Balance)
}

pub fn create_account(
  command: AccountCommand,
  initial_balance: Int,
) -> Result(CreateAccountResult, String) {
  let account_id = command.generate_id()

  // Port 経由でアカウント作成
  case command.repository.create_account(account_id, initial_balance) {
    Ok(_) -> {
      let assert Ok(balance) = model.new_balance(initial_balance)
      Ok(CreateAccountResult(account_id:, balance:))
    }
    Error(error_msg) -> Error(error_msg)
  }
}
