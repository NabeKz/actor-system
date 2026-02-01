// Query層: 読み取り専用の操作

import features/account/port.{type AccountId}

pub type AccountInfo {
  AccountInfo(account_id: AccountId, balance: Int)
}

// TODO: Phase 2でEvent Storeから読み取り実装
pub fn get_account(
  get_balance: port.GetBalance,
  account_id: AccountId,
) -> Result(AccountInfo, String) {
  case get_balance(account_id) {
    Ok(balance) -> Ok(AccountInfo(account_id:, balance:))
    Error(msg) -> Error(msg)
  }
}
