//
//  ReverseWordsService.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import Foundation

protocol ReverseWordsServiceProtocol {
    func reverseWords(in text: String) -> String
}

class ReverseWordsService: ReverseWordsServiceProtocol {
    func reverseWords(in text: String) -> String {
        return text.split(separator: " ").map { String($0.reversed()) }.joined(separator: " ")
    }
}
