import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

type RegistryMessage(msg) {
  GetOrCreate(
    aggregate_id: String,
    factory: fn() -> Result(Subject(msg), actor.StartError),
    reply_to: Subject(Result(Subject(msg), String)),
  )
}

type RegistryState(msg) {
  RegistryState(actors: Dict(String, Subject(msg)))
}

pub opaque type Registry(msg) {
  Registry(subject: process.Subject(RegistryMessage(msg)))
}

pub fn start() -> Result(Registry(msg), actor.StartError) {
  let initial_state = RegistryState(actors: dict.new())

  initial_state
  |> actor.new()
  |> actor.on_message(handle_message)
  |> actor.start()
  |> result.map(fn(started) { Registry(started.data) })
}

pub fn get_or_create(
  registry: Registry(msg),
  aggregate_id: String,
  factory: fn() -> Result(Subject(msg), actor.StartError),
) -> Result(Subject(msg), String) {
  let Registry(subject) = registry

  process.call(subject, 5000, GetOrCreate(aggregate_id, factory, _))
}

fn handle_message(
  state: RegistryState(msg),
  message: RegistryMessage(msg),
) -> actor.Next(RegistryState(msg), RegistryMessage(msg)) {
  let GetOrCreate(aggregate_id, factory, reply_to) = message
  let #(result, new_state) = get_or_create_actor(state, aggregate_id, factory)
  process.send(reply_to, result)
  actor.continue(new_state)
}

fn get_or_create_actor(
  state: RegistryState(msg),
  aggregate_id: String,
  factory: fn() -> Result(Subject(msg), actor.StartError),
) -> #(Result(Subject(msg), String), RegistryState(msg)) {
  let create_new = fn() {
    factory()
    |> result.map(fn(subject) {
      let new_actors = dict.insert(state.actors, aggregate_id, subject)
      #(Ok(subject), RegistryState(actors: new_actors))
    })
  }

  dict.get(state.actors, aggregate_id)
  |> result.map(fn(subject) { #(Ok(subject), state) })
  |> result.try_recover(fn(_) { create_new() })
  |> result.lazy_unwrap(fn() { #(Error("Failed to create actor"), state) })
}
