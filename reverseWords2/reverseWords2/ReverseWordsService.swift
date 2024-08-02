//
//  ReverseWordsService.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import Foundation

protocol ReverseWordsServiceProtocol {
    func reverseWords(in text: String, ignoring ignoreWords: Set<String>, reverseDigits: Bool, reverseSpecialCharacters: Bool, isCustomMode: Bool) -> String
}

class ReverseWordsService: ReverseWordsServiceProtocol {
    func reverseWords(in text: String, ignoring ignoreWords: Set<String>, reverseDigits: Bool, reverseSpecialCharacters: Bool, isCustomMode: Bool) -> String {
        let words = text.components(separatedBy: " ")
        var reversedWords = [String]()
        
        for word in words {
            if ignoreWords.contains(word) {
                reversedWords.append(word)
            } else {
                let reversedWord = reverseCharacters(in: word, reverseDigits: reverseDigits, reverseSpecialCharacters: reverseSpecialCharacters, isCustomMode: isCustomMode)
                reversedWords.append(reversedWord)
            }
        }
        return reversedWords.joined(separator: " ")
    }
    
    private func reverseCharacters(in word: String, reverseDigits: Bool, reverseSpecialCharacters: Bool, isCustomMode: Bool) -> String {
        var charactersToReverse = [Character]()
        var result = Array(word)
    
        for char in word {
            if char.isLetter && !(isCustomMode && (char == "x" || char == "l")) {
                charactersToReverse.append(char)
            } else if reverseDigits && char.isNumber {
                charactersToReverse.append(char)
            } else if reverseSpecialCharacters && containsSpecialCharacter(char) {
                charactersToReverse.append(char)
            }
        }
        
        charactersToReverse.reverse()
        
        var index = 0
        for i in 0..<result.count {
            if (result[i].isLetter && !(isCustomMode && (result[i] == "x" || result[i] == "l"))) ||
               (reverseDigits && result[i].isNumber) ||
               (reverseSpecialCharacters && containsSpecialCharacter(result[i])) {
                result[i] = charactersToReverse[index]
                index += 1
            }
        }
        
        return String(result)
    }

    private func containsSpecialCharacter(_ char: Character) -> Bool {
        let specialCharacters = CharacterSet(charactersIn: "/!@#$%^&*()_+-=[]{}|;':\",.<>?")
        return char.unicodeScalars.allSatisfy { specialCharacters.contains($0) }
    }
}

