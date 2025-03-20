//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import SwiftUI

/// `ContentView` ですよ☕️
/// - ここでは単語リストを表示したり、追加したり、削除できちゃうんです☕️
/// - それと、単語テストモードに入ることもできますよ☕️
struct ContentView: View {
    
    

    /// アプリの単語リストですね☕️
    /// - `UserDefaults` に保存されるので、アプリを閉じてもデータは消えませんよ☕️
    @State private var words: [Word] = []
    

    /// 単語追加画面を表示するかどうかのフラグです☕️
    @State private var showingAddWord = false
    

    /// 単語テスト画面を表示するかどうかのフラグですね☕️
    @State private var showingTestView = false



    /// 画面のレイアウトを管理するメインUIです☕️
    /// - 単語リストを見たり、追加・削除したりできます☕️
    /// - そして、単語テストを開始するボタンもあります☕️
    var body: some View {
        /// ナビゲーションビューを使って全体のレイアウトを管理するんです☕️
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                /// ここでは登録された単語をリスト表示しちゃいます☕️
                List {
                    ForEach(words) { word in
                        VStack(alignment: .leading) {
                            Text(word.word)
                                .font(.headline)
                            ForEach(word.meanings) { meaning in
                                Text(meaning.definition)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteWord)
                }
                .navigationTitle("Word List")
                .toolbar {
                    /// 追加ボタン（+）です。単語を追加したい時に使うんです☕️
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingAddWord = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    /// 編集ボタンです🛠 削除機能を使いたい時に押してみてください☕️
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                
                /// 画面右下にある「Test」ボタンですね☕️
                /// - タップすると、テストモード選択のアクションシートが出てきます☕️
                Button {
                    showingTestView = true
                } label: {
                    Text("Test")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                .padding()
            }
            
            /// 単語追加画面をモーダル表示します☕️
            .sheet(isPresented: $showingAddWord) {
                AddWordView { newWord in
                    words.append(newWord)
                    WordDataManager.saveWords(words)
                }
            }
            
            /// 画面が開かれた時に、保存された単語リストを読み込みます☕️
            .onAppear {
                words = WordDataManager.loadWords()
            }
            
            /// テスト画面をモーダル表示します☕️
            .sheet(isPresented: $showingTestView) {
                TestView(words: words)
            }
        }
    }



    /// これは単語を削除する処理ですね☕️
    /// - `words` から選択した単語を削除して、保存データも更新します☕️
    private func deleteWord(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
        WordDataManager.saveWords(words)
    }
}



/// `ContentView` のプレビューです☕️
#Preview {

    

    /// デバッグ用のフラグですね☕️
    /// - これを `true` にすると、プレビュー時に保存された単語を削除しちゃいます☕️
    let debugClearPreviewData = false
    
    

    if debugClearPreviewData {
        UserDefaults.standard.removeObject(forKey: "SavedWords")
    }
    

    return ContentView()
}
