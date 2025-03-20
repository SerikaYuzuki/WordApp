//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import Foundation

/// 単語データの管理を行うユーティリティです☕️
/// TODO: たくさんの単語リストを扱えるようにする予定です☕️
struct WordDataManager {
  /// JSONファイルから単語リストを読み込むんです☕️
  /// - Parameter fileName: 読み込む JSON ファイルの名前（拡張子なし）ですよ☕️
  /// - Returns: 読み込んだ単語の配列（失敗時は空配列になっちゃいます💦）☕️
  static func loadWordsFromJSON(fileName: String) -> [Word] {
    /// JSONファイルから単語リストを読み込むんです☕️
    /// - Parameter fileName: 読み込む JSON ファイルの名前（拡張子なし）ですね☕️
    /// - Returns: 読み込んだ単語の配列（失敗したら空になっちゃいます…💦）☕️
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
      let jsonData = try? Data(contentsOf: url),
      let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        as? [[String: Any]]
    else {
      return []
    }

    /// あとで返す単語のリストを作るんです☕️
    var loadedWords: [Word] = []

    /// JSONデータを解析して、単語のリストを作るんです☕️
    /// 中身としては、単語のテキストとその意味のリストをJSONから一個ずつ読み込んでいる感じです☕️
    for item in jsonArray {
      if let wordText = item["word"] as? String,
        let meaningsArray = item["meanings"] as? [[String: Any]]
      {
        /// 意味のリストを作るんです☕️
        var meanings: [Meaning] = []
        for meaningItem in meaningsArray {
          if let definition = meaningItem["definition"] as? String,
            let examples = meaningItem["examples"] as? [String]
          {
            meanings.append(Meaning(definition: definition, examples: examples))
          }
        }

        /// 単語を作ってリストに追加しちゃいますね☕️
        let word = Word(word: wordText, meanings: meanings)
        loadedWords.append(word)
      }
    }

    return loadedWords
  }

  /// 単語リストを UserDefaults に保存するんです☕️
  /// - Parameter words: 保存する単語の配列なんです☕️
  /// TODO: もっと柔軟にリストを管理できるようにしたいですね…！
  static func saveWords(_ words: [Word]) {
    if let encoded = try? JSONEncoder().encode(words) {
      UserDefaults.standard.set(encoded, forKey: "SavedWords")
    }
  }

  /// UserDefaults から単語リストをロードするんです☕️
  /// - もしデータが保存されていなかったら、デフォルトの単語リストを読み込むんです☕️
  /// - Returns: ロードした単語の配列を返しちゃいます☕️
  /// TODO: 複数の単語リストを管理できるようにしたいですね…☕️
  static func loadWords() -> [Word] {
    if let data = UserDefaults.standard.data(forKey: "SavedWords"),
      let decoded = try? JSONDecoder().decode([Word].self, from: data)
    {
      return decoded
    } else {
      /// デフォルトの単語リストを読み込むんです☕️
      let defaultWords = loadWordsFromJSON(fileName: "DefaultWordsData")

      /// ついでに保存しておきますね📂☕️
      saveWords(defaultWords)

      return defaultWords
    }
  }
}
