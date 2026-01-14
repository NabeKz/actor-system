// Query層: 読み取り専用の操作

import features/account/application/port

pub type AccountQuery {
  AccountQuery(repository: port.AccountRepository)
}

pub fn new(repository: port.AccountRepository) -> AccountQuery {
  AccountQuery(repository:)
}

pub type AccountInfo {
  AccountInfo(account_id: String, balance: Int)
}

// TODO: Phase 2でEvent Storeから読み取り実装
pub fn get_account(
  query: AccountQuery,
  account_id: String,
) -> Result(AccountInfo, String) {
  case query.repository.get_balance(account_id) {
    Ok(balance) -> Ok(AccountInfo(account_id:, balance:))
    Error(msg) -> Error(msg)
  }
}
