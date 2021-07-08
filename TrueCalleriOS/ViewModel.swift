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
    private var webContentFetcher: WebContentServiceProtocol
    
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
    
    init(webContentFetcher: WebContentServiceProtocol = WebContentService()) {
        self.webContentFetcher = webContentFetcher
    }
    
    func startFindTenthRequest() {
        self.fetchWebContent(type: .tenth)
    }
    
    func startFindEveryTenthRequest() {
        self.fetchWebContent(type: .everyTenth)
    }
    
    func startWordCount() {
        self.fetchWebContent(type: .wordCount)
    }
    
    private func fetchWebContent(type: RequestType) {
        webContentFetcher.getWebContent { result in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                do {
                    let htmlString = try result.get()
                    let webContentProcessor = WebContentProcessor(htmlString: htmlString)
                    switch type {
                    case .everyTenth:
                        self.htmlString = (type, try webContentProcessor.findEveryTenthCharacter())
                    case .tenth:
                        self.htmlString = (type, try webContentProcessor.findTenthCharacter())
                    case .wordCount:
                        self.htmlString = (type, webContentProcessor.wordCount().description)
                    case .none:
                        break
                    }
                } catch let error {
                    self.handleErrorOnUIThread(errorString: self.handleWebContentError(error: error))
                }
            }
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

enum UserError : String {
    case badURL = "The url is not working"
    case badEncoding = "Can not conver the web content, please check the url"
    case contentTooShort = "The web content is less than expected"
    case unknown = "Unknow error, please try again"
}

enum RequestType {
    case tenth
    case everyTenth
    case wordCount
    case none
}
