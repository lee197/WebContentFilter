//
//  WebContentService.swift
//  TrueCalleriOS
//
//  Created by Jason Lee on 08/07/2021.
//

import Foundation

enum WebContentFetchError: String, Error {
    case urlError
    case webError
}

protocol WebContentServiceProtocol {
    func  getWebContent(complete completionHandler: @escaping (Result<String, WebContentFetchError>) -> Void)
}

final class WebContentService: WebContentServiceProtocol {
    let url = "https://truecaller.blog/2018/03/15/how-to-become-an-ios-developer/"
    
    func getWebContent(complete completionHandler: @escaping (Result<String, WebContentFetchError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            guard let myURL = URL(string: self.url) else {
                completionHandler(.failure(.urlError))
                return
            }
            
            do {
                let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
                completionHandler(.success(myHTMLString))
            } catch {
                completionHandler(.failure(.webError))
            }
        }
    }
}
