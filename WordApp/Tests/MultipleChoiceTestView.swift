//
//  MultipleChoiceTestView.swift
//  WordApp
//  
//  Created by 柚木芹香☕️ on 2025/03/20
//  
//

import SwiftUI

/// `MultipleChoiceTestView` は選択肢形式のテストですよ～☕️
struct MultipleChoiceTestView: View {
    
    let words: [Word]
    
    /// 出題される単語リストですね～📖
    @State private var questions: [Word] = []
    
    /// 現在の問題のインデックスですよ～☕️
    @State private var currentIndex: Int = 0
    
    /// 選択肢のリストですね📖
    @State private var options: [String] = []
    
    /// 正解かどうかの判定ですよ～✨
    @State private var isCorrect: Bool? = nil
    
    /// 正解数をカウントするんです📖
    @State private var correctCount: Int = 0
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            if currentIndex >= questions.count {
                
                /// テストが終わったときのメッセージですよ📖
                Text("Test Finished!")
                    .font(.largeTitle)
                    .padding()
                
                Text("Correct: \(correctCount) / \(questions.count)")
                    .font(.title)
                    .padding()
                
                Button("Close") {
                    dismiss()
                }
                .padding(.top)
                
            } else {
                let currentWord = questions[currentIndex]
                let correctMeaning = currentWord.meanings.randomElement()?.definition ?? "No meaning"

                Text("What is the meaning of this word?")
                    .font(.title2)
                
                Text(currentWord.word)
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            checkAnswer(selected: option, correctAnswer: correctMeaning)
                        } label: {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .disabled(isCorrect != nil)
                    }
                }
                .padding()
                
                if let valid = isCorrect {
                    Text(valid ? "⭕️ Correct!" : "❌ Wrong!")
                        .font(.title)
                        .foregroundColor(valid ? .green : .red)
                        .padding()

                    Button("Next") {
                        nextQuestion()
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onAppear {
            startTest()
        }
    }

    private func startTest() {
        questions = words.shuffled()
        currentIndex = 0
        correctCount = 0
        isCorrect = nil
        generateOptions(for: questions[currentIndex])
    }

    private func checkAnswer(selected option: String, correctAnswer: String) {
        isCorrect = (correctAnswer == option)
        if isCorrect == true { correctCount += 1 }
    }

    private func nextQuestion() {
        isCorrect = nil
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            generateOptions(for: questions[currentIndex])
        }
    }

    private func generateOptions(for word: Word) {
        let correctMeaning = word.meanings.randomElement()?.definition ?? "No meaning"
        var dummyOptions = words.flatMap { $0.meanings.map { $0.definition } }.filter { $0 != correctMeaning }
        dummyOptions.shuffle()
        options = (Array(dummyOptions.prefix(3)) + [correctMeaning]).shuffled()
    }
}
