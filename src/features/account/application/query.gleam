// Query層: 読み取り専用の操作

import features/account/model.{type AccountId}

pub type GetBalance =
  fn(AccountId) -> Result(Int, String)

pub type AccountInfo {
  AccountInfo(account_id: AccountId, balance: Int)
}

// TODO: Phase 2でEvent Storeから読み取り実装
pub fn get_account(
  get_balance: GetBalance,
  account_id: AccountId,
) -> Result(AccountInfo, String) {
  case get_balance(account_id) {
    Ok(balance) -> Ok(AccountInfo(account_id:, balance:))
    Error(msg) -> Error(msg)
  }
}
