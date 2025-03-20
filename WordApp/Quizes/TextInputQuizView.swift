//
//  TextInputQuizView.swift
//  WordApp
//
//  Created by 柚木芹香☕️ on 2025/03/20
//
//

import SwiftUI



/// `TextInputQuizView` は入力式のテストなんです☕️
struct TextInputQuizView: View {

  let words: [Word]

  @State private var questions: [Word] = []
  @State private var currentIndex: Int = 0
  @State private var userAnswer: String = ""
  @State private var answerState: AnswerState = .unanswered
  @State private var correctCount: Int = 0

  @Environment(\.dismiss) var dismiss
  

  var body: some View {
    VStack(spacing: 20) {

      if questions.isEmpty {
        
        /// テストする単語がないときの表示です☕️
        Text("テストする単語がないよ💦")
          .font(.largeTitle)
          .padding()
          /// 単語がないときはメイン画面に戻します☕️
          Button("Close") {
            dismiss()
          }
      } else if currentIndex < questions.count {
        let currentWord = questions[currentIndex]

        switch answerState {
        case .correct:

            /// 正解画面を表示します☕️
            TextInputQuizCorrectView(word: currentWord.word, onNext: { nextQuestion() })

        case .incorrect(let correctAnswer):

            /// 間違い画面を表示します☕️
            TextInputQuizWrongView(correctAnswer: correctAnswer, onNext: { nextQuestion() })

        case .unanswered:
            /// 入力式のクイズを表示します☕️
            TextInputQuizInputView(
              word: currentWord, userAnswer: $userAnswer,
              onSubmit: {
                if userAnswer.lowercased() == currentWord.word.lowercased() {
                  answerState = .correct
                  correctCount += 1
                } else {
                  answerState = .incorrect(currentWord.word)
                }
              })

        case .finished:

            /// クイズが終わったら結果画面を表示します☕️
            TextInputQuizFinishedView(
              correctCount: correctCount, totalQuestions: questions.count,
              finished: { dismiss() })
        }

      } else {

        /// ここには到達しないはずですが、念のために残しておきます☕️
        Text("Unknown answer state. Check the code in TextInputQuizView.swift.")
      }
    }
    .padding()
    .onAppear {
      startTest()
    }
  }

  /// テストを開始するための関数です☕️
  /// - 問題をシャッフルして、正解数を0にリセットします☕️
  private func startTest() {
    questions = words.shuffled()
    currentIndex = 0
    correctCount = 0
    answerState = .unanswered
  }

  /// 次の問題へ進む関数ですね☕️
  private func nextQuestion() {
    userAnswer = ""
    answerState = .unanswered
    if currentIndex + 1 < questions.count {
      currentIndex += 1
    } else {
      answerState = .finished
    }
  }

}

/// クイズの入力画面ですよ～☕️
struct TextInputQuizInputView: View {
  let word: Word
  @Binding var userAnswer: String
  let onSubmit: () -> Void

  var body: some View {
    VStack {

      /// ユーザーに回答を求めるテキストです☕️
      Text("回答を入力！")

      ForEach(Array(word.meanings.enumerated()), id: \.offset) {
        index, meaning in
        VStack(alignment: .leading, spacing: 10) {

          /// 単語の意味を表示します☕️
          Text(meaning.definition)
            .font(.headline)

          /// 例文をアンダーライン付きで表示します☕️
          let wdm = WordDataManager()
          ForEach(wdm.underlineExample(word: word), id: \.self) { example in
            Text(example)
              .font(.subheadline)
              .foregroundColor(.gray)
          }
        }
      }

      /// ユーザーが回答を入力するためのテキストフィールドです☕️
      TextField("Your answer", text: $userAnswer)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()

      /// 回答を送信するボタンです☕️
      Button("Submit") {
        onSubmit()
      }
    }
  }
}

/// 正解画面のビューです☕️
/// - 1.5秒後に次の問題に進むようにしています☕️
struct TextInputQuizCorrectView: View {
  let word: String
  let onNext: () -> Void

  var body: some View {
    VStack {

      /// 正解のメッセージです☕️
      Text("正解！")
        .font(.largeTitle)
        .foregroundColor(.green)
        .padding()

      /// 正解した単語を表示します☕️
      Text("\(word)")
        .font(.title)
        .bold()
        .padding()
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        onNext()
      }
    }
  }
}

/// 不正解画面のビューです☕️
/// - クリックするまで次の問題に進まないようにしています☕️
/// - ユーザーが正解を確認できるようにしています☕️
struct TextInputQuizWrongView: View {
  let correctAnswer: String
  let onNext: () -> Void

  var body: some View {
    VStack {

      /// 不正解のメッセージですよ～☕️
      Text("不正解！")
        .font(.largeTitle)
        .foregroundColor(.red)
        .padding()

      /// 正解を教えてあげるんです☕️
      Text("正解は「\(correctAnswer)」でした！")
        .font(.title)
        .padding()

      /// 次の問題に進むボタンですね☕️
      Button("次へ") {
        onNext()
      }
      .padding()
    }
  }
}

/// クイズ終了画面のビューですよ～☕️
struct TextInputQuizFinishedView: View {
  let correctCount: Int
  let totalQuestions: Int
  let finished: () -> Void

  var body: some View {
    VStack {

      /// クイズが終わったことを知らせるメッセージです☕️
      Text("Quiz Finished!")
        .font(.largeTitle)
        .padding()

      /// ユーザーの正解数を表示するんですよ☕️
      Text("Correct: \(correctCount) / \(totalQuestions)")
        .font(.title)
        .padding()
    }

    /// メイン画面に戻るボタンです☕️
    Button("Close") {
      finished()
    }
  }
}

/// `TextInputQuizView` のプレビューですね☕️
/// - ここでは `WordDataManager.loadWords()` を使ってテスト用のデータをロードするんです☕️
#Preview {

  /// 単語がない時のデバッグのためのフラグです☕️
  let showWhenNoWordsLoaded = false

  if showWhenNoWordsLoaded {
    TextInputQuizView(words: [])
  } else {
    TextInputQuizView(words: WordDataManager.loadWords())
  }
}
