pub type AccountId {
  AccountId(String)
}

pub type CreateAccount =
  fn(AccountId, Int) -> Result(Nil, String)

pub type GetBalance =
  fn(AccountId) -> Result(Int, String)

pub type Deposit =
  fn(AccountId, Int) -> Result(Int, String)

pub type Withdraw =
  fn(AccountId, Int) -> Result(Int, String)
