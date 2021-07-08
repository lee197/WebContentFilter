//
//  MockDataSourceService.swift
//  TrueCalleriOSTests
//
//  Created by Jason Lee on 08/07/2021.
//

import Foundation
@testable import TrueCalleriOS

class MockDataSourceService {
    var isFetchDataCalled = false
    var completeWebData: String?
    var completeClosure: ((Result<String, WebContentFetchError>) -> Void)!
    
    func fetchSuccess() {
        completeClosure(.success(completeWebData!))
    }
    
    func fetchFail(error: WebContentFetchError) {
        completeClosure(.failure(error))
    }
}

extension MockDataSourceService: WebContentServiceProtocol {
    
    func getWebContent(complete completionHandler: @escaping (Result<String, WebContentFetchError>) -> ()) {
        isFetchDataCalled = true
        completeClosure = completionHandler
    }
}

class DataGenerator {
    static func finishFetchWebData() -> String {
        let sampleURL = Bundle.main.path(forResource: "sample", ofType: "txt")!
        if let sampleWords = try? String(contentsOf: URL(fileURLWithPath: sampleURL)) {
                return sampleWords
        }
        return ""
    }
}
