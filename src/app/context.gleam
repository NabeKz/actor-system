import features/account/adaptor/registry/adapter
import features/account/adaptor/registry/registry
import features/account/application/port
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub opaque type Context {
  Context(repository: port.AccountRepository, id_generator: fn() -> String)
}

pub fn initialize() -> Result(Context, actor.StartError) {
  use account_registry <- result.try(registry.start())
  let repository = adapter.from_registry(account_registry)

  Ok(
    Context(repository: repository, id_generator: fn() { uuid.value(uuid.v4()) }),
  )
}

pub fn repository(ctx: Context) -> port.AccountRepository {
  ctx.repository
}

pub fn id_generator(ctx: Context) -> fn() -> String {
  ctx.id_generator
}
