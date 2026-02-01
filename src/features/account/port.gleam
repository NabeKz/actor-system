pub type AccountRepository {
  AccountRepository(
    create_account: fn(String, Int) -> Result(Nil, String),
    get_balance: fn(String) -> Result(Int, String),
    deposit: fn(String, Int) -> Result(Int, String),
    withdraw: fn(String, Int) -> Result(Int, String),
  )
}

pub type AccountId {
  AccountId(String)
}

pub type CreateAccount =
  fn(AccountId, Int) -> Result(Nil, String)

pub type GetBalane =
  fn(AccountId) -> Result(Int, String)

pub type Deposit =
  fn(AccountId, Int) -> Result(Int, String)

pub type Withdraw =
  fn(String, Int) -> Result(Int, String)
