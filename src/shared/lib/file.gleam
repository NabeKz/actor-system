import gleam/result
import gleam/string
import simplifile

pub type File {
  File(dir: String, name: String)
}

pub fn init(dir: String, name: String) -> File {
  let file = File(dir:, name:)
  let assert Ok(_) = simplifile.create_directory_all(file.dir)
  file
}

pub fn append(file: File, contents: List(String)) -> Result(Nil, String) {
  let contents = contents |> string.join(",") <> "\n"

  simplifile.append(to: file |> file_name, contents:)
  |> result.map_error(simplifile.describe_error)
}

pub fn read(file: File) -> Result(String, simplifile.FileError) {
  simplifile.read(from: file |> file_name)
}

pub fn rows(file: File) -> List(String) {
  case file |> read() {
    Ok(rows) -> rows |> string.trim_end |> string.split("\n")
    Error(_) -> []
  }
}

fn file_name(file: File) -> String {
  file.dir <> "/" <> file.name
}
