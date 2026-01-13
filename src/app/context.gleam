import features/account/adaptor/registry/registry
import features/account/service
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub opaque type Context {
  Context(account_service: service.AccountService)
}

pub fn initialize() -> Result(Context, actor.StartError) {
  use account_registry <- result.try(registry.start())

  let account_service =
    service.new(account_registry, fn() { uuid.value(uuid.v4()) })

  Context(account_service:) |> Ok()
}

pub fn account_service(ctx: Context) -> service.AccountService {
  ctx.account_service
}
