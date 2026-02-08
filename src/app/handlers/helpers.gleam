pub fn either(
  result: Result(a, b),
  ok ok: fn(a) -> c,
  error error: fn(b) -> c,
) -> c {
  case result {
    Ok(v) -> ok(v)
    Error(e) -> error(e)
  }
}
