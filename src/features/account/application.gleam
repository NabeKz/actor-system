// Application層: ユースケースの公開API
// command/query を re-export

import features/account/application/command
import features/account/application/query

// Command
pub type AccountCommand = command.AccountCommand
pub type CreateAccountResult = command.CreateAccountResult
pub const new_command = command.new
pub const create_account = command.create_account

// Query
pub type AccountQuery = query.AccountQuery
pub type AccountInfo = query.AccountInfo
pub const new_query = query.new
pub const get_account = query.get_account
