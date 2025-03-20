//
//  MultipleChoiceQuizView.swift
//  WordApp
//
//  Created by 柚木芹香☕️ on 2025/03/20
//
//

import SwiftUI

/// `MultipleChoiceQuizView` は選択肢形式のテストなんです☕️
struct MultipleChoiceQuizView: View {

    let words: [Word]

    @State private var questions: [Word] = []
    @State private var currentIndex: Int = 0
    @State private var options: [String] = []
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
                
                /// 単語がないときはメイン画面に戻すんです☕️
                Button("Close") {
                    dismiss()
                }
                
            } else if currentIndex < questions.count {
                let currentWord = questions[currentIndex]
                let correctMeaning = currentWord.meanings.randomElement()?.definition ?? "No meaning"
                
                switch answerState {
                case .correct:
                    
                    /// 正解画面を表示します☕️
                    MultipleChoiceQuizCorrectView(onNext: { nextQuestion() })
                    
                case .incorrect(let correctAnswer):
                    
                    /// 間違い画面を表示します☕️
                    MultipleChoiceQuizWrongView(correctAnswer: correctAnswer, onNext: { nextQuestion() })
                    
                case .unanswered:
                    
                    /// 選択肢形式のクイズを表示します☕️
                    MultipleChoiceQuizInputView(
                        word: currentWord, options: options,
                        onSelect: { selectedOption in
                            if selectedOption == correctMeaning {
                                answerState = .correct
                                correctCount += 1
                            } else {
                                answerState = .incorrect(correctMeaning)
                            }
                        })
                    
                case .finished:
                    
                    /// クイズが終わったら結果画面を表示します☕️
                    MultipleChoiceQuizFinishedView(
                        correctCount: correctCount, totalQuestions: questions.count,
                        finished: { dismiss() })
                }
                
            } else {
                
                /// ここには到達しないはずですが、念のために残しておきます☕️
                Text("Unknown answer state. Check the code in MultipleChoiceQuizView.swift.")
            }
        }
        .padding()
        .onAppear {
            startQuiz()
        }
    }

    /// テストを開始するための関数です☕️
    private func startQuiz() {
        questions = words.shuffled()
        currentIndex = 0
        correctCount = 0
        answerState = .unanswered
        generateOptions(for: questions[currentIndex])
    }

    /// 次の問題へ進む関数ですね☕️
    private func nextQuestion() {
        answerState = .unanswered
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            generateOptions(for: questions[currentIndex])
        } else {
            answerState = .finished
        }
    }

    /// 選択肢を生成する関数ですよ☕️
    private func generateOptions(for word: Word) {
        let correctMeaning = word.meanings.randomElement()?.definition ?? "No meaning"
        var dummyOptions = words.flatMap { $0.meanings.map { $0.definition } }.filter {
            $0 != correctMeaning
        }
        dummyOptions.shuffle()
        options = (Array(dummyOptions.prefix(3)) + [correctMeaning]).shuffled()
    }
}

/// 選択肢形式のクイズ画面ですよ～☕️
struct MultipleChoiceQuizInputView: View {
    let word: Word
    let options: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack {
            
            /// 問題の単語を表示します☕️
            Text("What is the meaning of this word?")
                .font(.title2)
            
            Text(word.word)
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button {
                        onSelect(option)
                    } label: {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}

/// 正解画面のビューですよ～☕️
struct MultipleChoiceQuizCorrectView: View {
    let onNext: () -> Void

    var body: some View {
        VStack {
            
            /// 正解のメッセージですよ☕️
            Text("⭕️ Correct!")
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onNext()
            }
        }
    }
}

/// 不正解画面のビューですよ～☕️
struct MultipleChoiceQuizWrongView: View {
    let correctAnswer: String
    let onNext: () -> Void

    var body: some View {
        VStack {
            
            /// 不正解のメッセージですよ☕️
            Text("❌ Wrong!")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding()
            
            Text("正解は「\(correctAnswer)」でした！")
                .font(.title)
                .padding()
            
            Button("次へ") {
                onNext()
            }
            .padding()
        }
    }
}

/// クイズ終了画面のビューですよ～☕️
struct MultipleChoiceQuizFinishedView: View {
    let correctCount: Int
    let totalQuestions: Int
    let finished: () -> Void

    var body: some View {
        VStack {
            
            /// クイズが終わったことを知らせるメッセージですよ☕️
            Text("Quiz Finished!")
                .font(.largeTitle)
                .padding()
            
            Text("Correct: \(correctCount) / \(totalQuestions)")
                .font(.title)
                .padding()
        }
        
        Button("Close") {
            finished()
        }
    }
}

/// `MultipleChoiceQuizView` のプレビューですよ～☕️
/// - ここでは `WordDataManager.loadWords()` を使ってテスト用のデータをロードするんです☕️
#Preview {
    MultipleChoiceQuizView(words: WordDataManager.loadWords())
}
