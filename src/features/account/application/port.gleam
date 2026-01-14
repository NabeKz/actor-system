// Port: アプリケーション層が定義するインターフェース
// Adapter (インフラ層) がこのインターフェースを実装する
//
// Subject/Actorなどの技術的詳細は隠蔽し、ビジネス操作のみを公開

// AccountRepository Port
// インフラ層（Adapter）が実装する責務
pub type AccountRepository {
  AccountRepository(
    // アカウントを作成（すでに存在する場合はエラー）
    create_account: fn(String, Int) -> Result(Nil, String),
    // アカウントの残高を取得
    get_balance: fn(String) -> Result(Int, String),
    // 入金
    deposit: fn(String, Int) -> Result(Int, String),
    // 出金
    withdraw: fn(String, Int) -> Result(Int, String),
  )
}
