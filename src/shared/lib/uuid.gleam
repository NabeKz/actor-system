import youid/uuid

pub type UUID {
  UUID(String)
}

pub fn v4() -> UUID {
  uuid.v4_string()
  |> UUID()
}

pub fn value(uuid: UUID) -> String {
  let UUID(v) = uuid
  v
}
