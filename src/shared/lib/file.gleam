import gleam/result
import gleam/string
import simplifile

pub type File {
  File(data_dir: String, name: String)
}

pub type Contents {
  StringValue(String)
  ListValue(List(String))
}

pub fn init(file: File) -> Result(Nil, simplifile.FileError) {
  simplifile.create_directory_all(file.data_dir)
}

pub fn append(
  file: File,
  contents: Contents,
) -> Result(Nil, simplifile.FileError) {
  let contents =
    case contents {
      StringValue(contents) -> contents
      ListValue(contents) -> contents |> string.join(",")
    }
    <> "\n"

  simplifile.append(to: file |> file_name, contents:)
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
  [file.data_dir, "/", file.name] |> string.concat
}
