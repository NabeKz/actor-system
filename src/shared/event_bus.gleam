import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor

pub type Publish(event) =
  fn(event) -> Nil

pub type Subscriber(event) =
  fn(event) -> Nil

pub type Message(event) {
  Dispatch(event)
}

pub fn initialize(
  subscribers: List(Subscriber(event)),
) -> Subject(Message(event)) {
  let assert Ok(ac) =
    subscribers
    |> actor.new()
    |> actor.on_message(handle_message)
    |> actor.start()

  ac.data
}

pub fn publish(subject: Subject(Message(event))) -> Publish(event) {
  fn(event) { process.send(subject, Dispatch(event)) }
}

fn handle_message(
  subscribers: List(Subscriber(event)),
  message: Message(event),
) -> actor.Next(List(Subscriber(event)), Message(event)) {
  case message {
    Dispatch(event) -> {
      list.each(subscribers, fn(subscriber) { subscriber(event) })
      actor.continue(subscribers)
    }
  }
}
