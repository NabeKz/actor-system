import features/account/adaptor/registry
import features/account/port.{type AccountId, AccountId}
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub opaque type Context {
  Context(
    registry: registry.Registry,
    id_generator: fn() -> AccountId,
  )
}

pub fn initialize() -> Result(Context, actor.StartError) {
  use account_registry <- result.try(registry.start())

  Ok(Context(
    registry: account_registry,
    id_generator: fn() { AccountId(uuid.value(uuid.v4())) },
  ))
}

pub fn create_account(ctx: Context) -> port.CreateAccount {
  registry.create_account(ctx.registry)
}

pub fn get_balance(ctx: Context) -> port.GetBalance {
  registry.get_balance(ctx.registry)
}

pub fn deposit(ctx: Context) -> port.Deposit {
  registry.deposit(ctx.registry)
}

pub fn withdraw(ctx: Context) -> port.Withdraw {
  registry.withdraw(ctx.registry)
}

pub fn id_generator(ctx: Context) -> fn() -> AccountId {
  ctx.id_generator
}
