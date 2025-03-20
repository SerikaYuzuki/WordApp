//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import SwiftUI
import UIKit

struct AddWordView: View {
    @State private var english = ""
    @State private var meanings: [Meaning] = [] // List of added meanings
    @State private var fetchedMeanings: [Meaning] = [] // Ensure API results are stored
    @State private var showingSearchPopup: Bool = false // Controls search popup visibility
    
    var onAdd: (Word) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                // ✅ 英単語の入力フィールド
                Section(header: Text("英単語")) {
                    TextField("例: Apple", text: $english)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // ✅ 意味リスト (追加・削除・編集可能)
                Section(header: Text("意味リスト")) {
                    ForEach($meanings) { $meaning in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("意味を入力", text: $meaning.definition)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("例文を入力", text: Binding(
                                get: { meaning.examples.first ?? "" },
                                set: { meaning.examples = [$0] }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                            HStack {
                                Spacer()
                                Button(action: {
                                    meanings.removeAll { $0.id == meaning.id }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // ✅ 意味追加ボタン
                Button("意味を追加") {
                    meanings.append(Meaning(definition: "", examples: [""]))
                }
                .disabled(english.isEmpty) // 🔹 単語がないと追加できない

                // ✅ API検索ボタン
                Button("検索") {
                    showingSearchPopup = true
                }
                .disabled(english.isEmpty) // 🔹 単語がないと検索できない
                
                // ✅ 単語帳への追加
                Button("追加する") {
                    let newWord = Word(word: english, meanings: meanings)
                    onAdd(newWord)
                    dismiss()
                }
                .disabled(english.isEmpty || meanings.isEmpty) // 🔹 単語・意味がないと追加できない
                .disabled(english.isEmpty) // 🔹 単語が空なら辞書を開けない
            }
            .navigationTitle("単語追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingSearchPopup) {
                MeaningSearchPopupView(selectedMeanings: $meanings, fetchedMeanings: $fetchedMeanings, word: english)
            }
        }
    }
}

// ✅ 意味検索ポップアップ
struct MeaningSearchPopupView: View {
    @Binding var selectedMeanings: [Meaning]
    @Binding var fetchedMeanings: [Meaning]
    @Environment(\.dismiss) var dismiss
    var word: String

    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedMeanings) { meaning in
                    Button(action: {
                        if !selectedMeanings.contains(where: { $0.id == meaning.id }) {
                            selectedMeanings.append(meaning)
                        }
                        dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text(meaning.definition)
                                .font(.headline)
                            if let example = meaning.examples.first {
                                Text(example)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("意味を選択")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                fetchMeaning(for: word) // 🔹 画面が開いたときに検索実行！
            }
        }
    }

    // ✅ APIから意味を取得
    private func fetchMeaning(for word: String) {
        guard !word.isEmpty else { return }
        
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())"
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decoded = try? JSONDecoder().decode([DictionaryAPIResponse].self, from: data) {
                    let fetched = decoded.first?.meanings.flatMap { $0.definitions }.map { def in
                        Meaning(definition: def.definition, examples: def.example.map { [$0] } ?? [])
                    } ?? []
                    DispatchQueue.main.async {
                        fetchedMeanings = fetched // 🔹 検索結果を反映
                    }
                }
            } catch {
                print("API呼び出し失敗: \(error.localizedDescription)")
            }
        }
    }
}

// ✅ APIレスポンス用のデータ型
struct DictionaryAPIResponse: Codable {
    struct Meaning: Codable {
        struct Definition: Codable {
            let definition: String
            let example: String?
        }
        let definitions: [Definition]
    }
    let meanings: [Meaning]
}

#Preview {
    AddWordView { _ in }
}
