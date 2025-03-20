//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import Foundation

/// 活用形のデバッグ表示のためのフラグです☕️
let debugShowInflectionData: Bool = false
/// JSONデータの読み込みのデバッグ表示のためのフラグです☕️
let debugShowJsonDataLoad: Bool = false

/// `InflectionData` ですよ☕️
/// - 単語の活用形を生成するための構造体なんです☕️
/// - JSONで不規則動詞のデータを読み込んで、不規則動詞の活用形を生成しますよ☕️
/// TODO: この構造体を使うとき、ずっと一回は大きめなJSONファイルを読み込むことになっているので、その部分を改善したいです☕️
struct InflectionData {

    /// 不規則動詞のリストですね☕️
    /// 構造体が作られる時にはすでに読み込まれています☕️
    static var irregularVerbs: [String: [String]] = loadInflections()
    
    /// JSONファイルから不規則動詞のデータを読み込むんです☕️
    /// - Returns: 不規則動詞の辞書です☕️
    private static func loadInflections() -> [String: [String]] {
        /// JSONファイルのURLを取得するんです📂☕️
        guard let url = Bundle.main.url(forResource: "IrregularVerbs", withExtension: "json") else {
            if debugShowJsonDataLoad { print("❌ inflections.json が見つかりません") }
            return [:]
        }
        do {
            /// JSONデータを読み込んでデコードするんです☕️
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([[String: String]].self, from: data)
            
            var dictionary: [String: [String]] = [:]
            
            /// JSONのデータをパースして、不規則動詞のリストを作るんですよ☕️
            for entry in decoded {
                if let base = entry["base form"],
                   let past = entry["past simple"],
                   let pastParticiple = entry["past participle"],
                   let ingForm = entry["-ing form"] {
                    /// JSONデータで/使って分かれているものもあるので、それを分割して配列にしています☕️
                    let pastForms = past.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
                    let pastParticipleForms = pastParticiple.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    dictionary[base.lowercased()] = pastForms + pastParticipleForms + [ingForm]
                }
            }
            return dictionary
        } catch {
            /// もしエラーがあったらコメントと空の辞書を返すんです☕️
            if debugShowJsonDataLoad { print("❌ JSON 読み込みエラー: \(error.localizedDescription)") }
            return [:]
        }
    }

    /// `word` の活用形を生成するんですよ☕️
    /// - Parameter word: 活用を作りたい単語を入れます☕️
    /// - Returns: 活用形のリストですよ☕️
    static func generateInflections(for word: String) -> [String] {
        var inflections: [String]

        /// もし不規則動詞の活用があれば、それを使うんです☕️
        /// コードがちょっとめんどくさいですが、irrefularVerbsには不規則動詞が全部入ってるので、それの中にword.lowercased()が入ってるか確認しています☕️
        /// そうじゃない時は、デフォルトの活用形を使うんです☕️
        if let irregular = irregularVerbs[word.lowercased()] {
            inflections = irregular
        } else {
            inflections = defaultInflections(for: word)
        }
        
        /// 三人称単数形を追加します☕️
        let thirdPersonSingular = generateThirdPersonSingular(for: word)
        inflections.append(thirdPersonSingular)
        
        /// デバッグで活用形を表示するんです☕️
        if debugShowInflectionData {
            print("✅ '\(word)' の活用形: \(inflections)")
        }
        return inflections
    }

    /// 規則的な動詞の活用形を生成するんですよ☕️
    /// - Parameter word: 活用を作りたい単語なんです☕️
    /// - Returns: 活用形のリストですね☕️
    private static func defaultInflections(for word: String) -> [String] {
        var result = [String]()
        
        /// "y" で終わる単語は "-ies" に変えるんです☕️
        if word.hasSuffix("y") {
            result.append(word.dropLast() + "ies") // study → studies
        } else if word.hasSuffix("e") {
            result.append(word + "d") // love → loved
        } else {
            result.append(word + "ed") // play → played
        }
        
        /// 進行形と三単現の形も追加するんです☕️
        result.append(word + "ing") // play → playing
        result.append(word + "s")   // play → plays
        
        return result
    }

    /// 三人称単数形を生成する関数なんですよ☕️
    /// - Parameter word: 変換したい単語なんです☕️
    /// - Returns: 三人称単数形の単語ですよ☕️
    private static func generateThirdPersonSingular(for word: String) -> String {
        /// 不規則な三単現形のリストです☕️
        let irregularThirdPerson: [String: String] = [
            "have": "has",
            "be": "is",
            "do": "does",
            "go": "goes"
        ]
        
        /// 不規則な変化がある場合は、それを適用するんです☕️
        if let irregular = irregularThirdPerson[word.lowercased()] {
            return irregular
        }
        
        /// "y" で終わる単語は "-ies" に変えるんです☕️
        if word.hasSuffix("y") && !"aeiou".contains(word.dropLast().last ?? " ") {
            return word.dropLast() + "ies" // study → studies
        }
        
        /// "o", "s", "x", "z" で終わる単語や "ch", "sh" で終わる単語は "-es" をつけるんです☕️
        if ["o", "s", "x", "z"].contains(where: { word.hasSuffix(String($0)) }) ||
            word.hasSuffix("ch") || word.hasSuffix("sh") {
            return word + "es" // go → goes, watch → watches
        }
        
        /// それ以外は "-s" をつけるんですよ☕️
        return word + "s"
    }
}
