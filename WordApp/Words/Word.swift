//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import Foundation

/// `Word` 構造体ですね☕️
/// - 単語の情報、複数の意味や例文を保存できるんですよ☕️
struct Word: Identifiable, Codable {
  /// この `Word` の識別用IDですね☕️
  let id: UUID?

  /// 単語そのものです☕️
  let word: String

  /// 単語の意味リストですね☕️
  var meanings: [Meaning]

  /// `Word` を作るための初期化関数です☕️
  /// - id がなかったら新しいUUIDを作るんです☕️
  init(id: UUID? = nil, word: String, meanings: [Meaning] = []) {
    self.id = id ?? UUID()
    self.word = word
    self.meanings = meanings
  }
}

/// `Meaning` 構造体ですよ☕️
/// - 単語の意味と複数の例文をセットでまとめています☕️
struct Meaning: Identifiable, Codable {
  /// `Meaning` の識別用IDですね☕️
  let id: UUID?

  /// この意味の定義なんです☕️
  var definition: String

  /// 例文のリストです☕️
  var examples: [String]

  /// `Meaning` を作るための初期化関数です☕️
  /// - id がなかったら新しいUUIDを作るんですよ☕️
  init(id: UUID? = nil, definition: String, examples: [String] = []) {
    self.id = id ?? UUID()
    self.definition = definition
    self.examples = examples
  }
}
