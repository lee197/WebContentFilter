//
//  ViewModel.swift
//  TrueCalleriOS
//
//  Created by Jason Lee on 06/07/2021.
//

import Foundation

class ViewModel {
    
    var htmlString: (type: RequestType, result: String) = (RequestType.none, "Loading") {
        didSet {
            self.updateHtmlString?(htmlString)
        }
    }
    
    var updateHtmlString: (((type: RequestType, result: String)) -> ())?

    init() {
        
    }
    
    func startRequests() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            let tenthChar = self.findtenth()
            DispatchQueue.main.async { [weak self] in
                self?.htmlString = (RequestType.tenth, tenthChar)
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            let everyTenthChar = self.findEveryTenth()
            DispatchQueue.main.async { [weak self] in
                self?.htmlString = (RequestType.everyTenth, everyTenthChar)
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            let wordCount = self.wordCount()
            DispatchQueue.main.async { [weak self] in
                self?.htmlString = (RequestType.wordCount, wordCount)
            }
        }
    }
    
    private func findtenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findTenthCharacter()
        } catch let error {
            print(error)
            return ""
        }
    }
    
    private func findEveryTenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findEveryTenthCharacter()
        } catch let error {
            print(error)
            return ""
        }
    }
    
    private func wordCount() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        return webContentProcessor.wordCount().description
    }
    
    private func fetchHtml() -> String {
        
        let myURLString = "https://truecaller.blog/2018/03/15/how-to-become-an-ios-developer/"

        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }

        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
            return ""
        }
    }
}

enum RequestType {
    case tenth
    case everyTenth
    case wordCount
    case none
}
