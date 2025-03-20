//
//  Created by 柚木芹香☕️ on 2025/03/17.
//

import SwiftUI

enum QuizMode: Identifiable {
  case mode1
  case mode2

  var id: Self { self }  // Identifiable に適合させる☕️
}

/// `AnswerState` は回答の状態を管理する列挙型です☕️
/// - 正解、間違い、未回答、テスト終了の4種類があるんです☕️
enum AnswerState {

  case correct
  case incorrect(String)
  case unanswered
  case finished
}

/// `QuizView` はテストモードを選択する画面です☕️
/// - ユーザーが「選択肢モード」か「入力モード」を選べるんです☕️
struct QuizView: View {
  
  let words: [Word]
  
  /// 選択されたテストモードですね☕️
  @State private var selectedMode: QuizMode? = nil
  
  var body: some View {
    VStack(spacing: 20) {
      
      /// タイトルです☕️
      Text("Select Quiz Mode")
        .font(.largeTitle)
        .bold()
        .padding()
      
      /// 選択肢モードへのナビゲーションボタンです☕️
      Button("🔘 Multiple Choice Quiz") {
        if !words.isEmpty {
          selectedMode = .mode1
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.blue.opacity(0.2))
      .cornerRadius(10)
      
      /// 入力モードへのナビゲーションボタンです☕️
      Button("⌨️ Text Input Quiz") {
        if !words.isEmpty {
          selectedMode = .mode2
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.green.opacity(0.2))
      .cornerRadius(10)
      
      Spacer()
    }
    .padding()
    
    /// 選択後にテストに移動するためのシートです☕️
    .sheet(item: $selectedMode) { mode in
      switch mode {
      case .mode1:
        MultipleChoiceQuizView(words: words)
      case .mode2:
        TextInputQuizView(words: words)
      }
    }
  }
}

#Preview {
  
  /// 単語がない時のデバッグのためのフラグです☕️
  /// TODO: 単語がない時にMuitipleChoiceQuizがクラッシュするので、その回避を作りましょう☕️
  let showWhenNoWordsLoaded = false
  
  /// デバッグ用のフラグが有効な場合は空の単語リストを渡します☕️
  /// そうでない場合はダミーの単語リストを渡します☕️
  if showWhenNoWordsLoaded {
    QuizView(words: [])
  } else {
    QuizView(words: WordDataManager.loadWords())
  }
}
