//
//  TextInputTestView.swift
//  WordApp
//
//  Created by 柚木芹香☕️ on 2025/03/20
//
//

import SwiftUI

/// `TextInputTestView` は入力式のテストなんです～📖
struct TextInputTestView: View {
    
    let words: [Word]
    
    @State private var questions: [Word] = []
    @State private var currentIndex: Int = 0
    @State private var userAnswer: String = ""
    @State private var isCorrect: Bool? = nil
    @State private var correctCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            if currentIndex >= questions.count {
                Text("Test Finished!")
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
                
                Text(currentWord.meanings.first?.examples.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Submit") {
                    isCorrect = (userAnswer.lowercased() == currentWord.word.lowercased())
                    if isCorrect == true { correctCount += 1 }
                    nextQuestion()
                }
                .disabled(userAnswer.isEmpty || isCorrect != nil)
            }
        }
        .padding()
        .onAppear {
            startTest()
        }
    }

    /// テストを開始するための関数
    private func startTest() {
        questions = words.shuffled()
        currentIndex = 0
        correctCount = 0
        isCorrect = nil
    }

    /// 次の問題へ進む関数
    private func nextQuestion() {
        isCorrect = nil
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        }
    }
    
    /// 編集中
//
//    /// 例文の単語をアンダーラインに変える関数です☕️
//    private func underlineExample(word: Word) -> String {
//        var underlinedExample: [String] = []
//        let inflections = InflectionData.generateInflections(for: word.word)
//        
//        for meaning in word.meanings {
//            for example in meaning.examples {
//                
//            }
//        }
//                
//        
//        return ""
//    }
//    
//    private func underlineForOneMeaning(for meaning :String, of word: Word) -> String {
//        var underlinedExample: String = word.meanings
//        let inflections = InflectionData.generateInflections(for: word.word)
//
//        for inflection in inflections {
//            let pattern = "\\b" + NSRegularExpression.escapedPattern(for: inflection) + "\\b"
//            let regex = try! NSRegularExpression(pattern: pattern, options: [])
//            
//            underlinedExample = regex.stringByReplacingMatches(
//                in: meaning,
//                options: [],
//                range: NSRange(location: 0, length: meaning.count),
//                withTemplate: "____") ??
//        }
//        
//        return ""
//    }
        
        
}

#Preview {
    TextInputTestView(words: WordDataManager.loadWords())
}
