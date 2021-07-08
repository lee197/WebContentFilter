//
//  ViewModel.swift
//  TrueCalleriOS
//
//  Created by Jason Lee on 06/07/2021.
//

import Foundation

class ViewModel {
    var updateHtmlString: (((type: RequestType, result: String)) -> ())?
    var updateError: ((String) -> ())?
    
    private var htmlString: (type: RequestType, result: String) = (RequestType.none, "Loading") {
        didSet {
            self.updateHtmlString?(htmlString)
        }
    }
    
    private var userErrorString: String = "" {
        didSet {
            self.updateError?(userErrorString)
        }
    }
    
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
    
    private func fetchHtml() -> String {
        let myURLString = "https://truecaller.blog/2018/03/15/how-to-become-an-ios-developer/"
        
        guard let myURL = URL(string: myURLString) else {
            self.handleErrorOnUIThread(errorString: UserError.badURL.rawValue)
            return ""
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            return myHTMLString
        } catch {
            self.handleErrorOnUIThread(errorString: UserError.badEncoding.rawValue)
            return ""
        }
    }
}

extension ViewModel {
    private func handleErrorOnUIThread(errorString: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userErrorString = errorString
        }
    }
    
    private func handleWebContentError(error: Error) -> String {
        if let webProcessingError = error as? WebContentProcessorError {
            switch webProcessingError {
            case .stringTooShort:
                return UserError.contentTooShort.rawValue
            }
        } else {
            return UserError.unknown.rawValue
        }
    }
}

extension ViewModel {
    private func findtenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findTenthCharacter()
        } catch let error {
            self.handleErrorOnUIThread(errorString: self.handleWebContentError(error: error))
            return ""
        }
    }
    
    private func findEveryTenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findEveryTenthCharacter()
        } catch let error {
            self.handleErrorOnUIThread(errorString: self.handleWebContentError(error: error))
            return ""
        }
    }
    
    private func wordCount() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        return webContentProcessor.wordCount().description
    }
}

extension ViewModel {
    enum UserError : String {
        case badURL = "The url is not working"
        case badEncoding = "Can not conver the web content, please check the url"
        case contentTooShort = "The web content is less than expected"
        case unknown = "Unknow error, please try again"
    }
}

extension ViewModel {
    enum RequestType {
        case tenth
        case everyTenth
        case wordCount
        case none
    }
}
