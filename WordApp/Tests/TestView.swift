import SwiftUI

/// 単語がない時のデバッグのためのフラグです📖
let showWhenNoWordsLoaded = false


enum TestMode: Identifiable {
    case mode1
    case mode2

    var id: Self { self } // Identifiable に適合させる
}

/// `TestView` はテストモードを選択する画面ですよ～☕️
/// - ユーザーが「選択肢モード」か「入力モード」を選べるんです📖✨
struct TestView: View {
    
    let words: [Word]

    /// 選択されたテストモードですね～☕️
    @State private var selectedMode: TestMode? = nil

    var body: some View {
        VStack(spacing: 20) {
            
            /// タイトルですよ～📖✨
            Text("Select Test Mode")
                .font(.largeTitle)
                .bold()
                .padding()

            /// 選択肢モードへのナビゲーションボタンです☕️
            Button("🔘 Multiple Choice Test") {
                selectedMode = .mode1
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)

            /// 入力モードへのナビゲーションボタンですよ📖✨
            Button("⌨️ Text Input Test") {
                selectedMode = .mode2
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .sheet(item: $selectedMode) { mode in
            if mode == .mode1 {
                MultipleChoiceTestView(words: words)
            } else {
                TextInputTestView(words: words)
            }
        }
    }
}

#Preview {
    if showWhenNoWordsLoaded {
        TestView(words: [])
    } else {
        TestView(words: [
            Word(word: "go", meanings: [Meaning(definition: "行く", examples: ["I go to school every day."])]),
            Word(word: "run", meanings: [Meaning(definition: "走る", examples: ["He runs every morning."])])
        ])
    }
}
