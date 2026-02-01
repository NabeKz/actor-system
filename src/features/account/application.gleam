// Application層: ユースケースの公開API
// command/query を re-export

import features/account/application/command
import features/account/application/query

// Command
pub type CreateAccountResult =
  command.CreateAccountResult

pub const create_account = command.create_account

pub const deposit = command.deposit

pub const withdraw = command.withdraw

// Query
pub type AccountInfo =
  query.AccountInfo

pub const get_account = query.get_account
