//
//  TextInputQuizView.swift
//  WordApp
//  
//  Created by 柚木芹香☕️ on 2025/03/20
//  
//

import SwiftUI

/// `TextInputQuizView` は入力式のテストなんです～📖
struct TextInputQuizView: View {
    
    let words: [Word]
    
    @State private var questions: [Word] = []
    @State private var currentIndex: Int = 0
    @State private var userAnswer: String = ""
    @State private var isCorrect: Bool? = nil
    @State private var correctCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            if currentIndex >= questions.count {
                Text("Quiz Finished!")
                    .font(.largeTitle)
                    .padding()

                Text("Correct: \(correctCount) / \(questions.count)")
                    .font(.title)
                    .padding()
            } else {
                let currentWord = questions[currentIndex]

                Text("Enter the word for the meaning:")
                Text(currentWord.meanings.first?.definition ?? "")
                    .font(.headline)

                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Submit") {
                    isCorrect = (userAnswer.lowercased() == currentWord.word.lowercased())
                    if isCorrect == true { correctCount += 1 }
                }
                .disabled(userAnswer.isEmpty || isCorrect != nil)
            }
        }
        .padding()
    }
}

#Preview {
    TextInputQuizView(words: [
        Word(word: "go", meanings: [Meaning(definition: "行く", examples: ["I go to school every day."])]),
        Word(word: "run", meanings: [Meaning(definition: "走る", examples: ["He runs every morning."])])
    ]
    )
}

