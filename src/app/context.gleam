import features/account/registry
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub opaque type Context {
  Context(registry: registry.Registry, generate_id: fn() -> uuid.UUID)
}

pub fn initialize() -> Result(Context, actor.StartError) {
  use registry <- result.try(registry.start())

  Context(registry:, generate_id: uuid.v4) |> Ok()
}
