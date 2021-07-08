//
//  WordCounter.swift
//  TrueCalleriOS
//
//  Created by Jason Lee on 06/07/2021.
//

import Foundation

struct WebContentProcessor {
    let htmlString: String
    let tenthCharacter = 10
    
    init(htmlString: String) {
        self.htmlString = htmlString
    }
    
    func findEveryTenthCharacter() throws -> String {
        if self.htmlString.count < tenthCharacter {
            throw WebContentProcessorError.stringTooShort
        }
        
        var result = [String]()
        var i = tenthCharacter - 1
        
        for (index, char) in htmlString.enumerated() {
            if index == i {
                result.append(String(char))
            } else {
                continue
            }
            
            i += tenthCharacter
        }
        
        return result.joined(separator: ",")
    }
    
    func findTenthCharacter() throws -> String {
        for (index, char) in htmlString.enumerated() {
            if index ==  tenthCharacter - 1 {
                return String(char)
            }
        }
        
        throw WebContentProcessorError.stringTooShort
    }
    
    func wordCount() -> Dictionary<String, Int> {
        let words = htmlString.components(separatedBy: " ")
        var wordDictionary = Dictionary<String, Int>()
        for word in words {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
    
}

enum WebContentProcessorError: Error {
    case stringTooShort
}
