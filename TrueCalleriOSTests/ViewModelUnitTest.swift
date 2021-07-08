//
//  ViewModelUnitTest.swift
//  TrueCalleriOSTests
//
//  Created by Jason Lee on 08/07/2021.
//

import XCTest
@testable import TrueCalleriOS

class ViewModelUnitTest: XCTestCase {
    var sut: ViewModel!
    var mockService: MockDataSourceService!
    
    override func setUpWithError() throws {
        mockService = MockDataSourceService()
        sut = ViewModel(webContentFetcher: mockService)

    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testFindFirstTenth() {
        let expectation = XCTestExpectation(description: "Test finding tenth char")
        
        self.sut.updateHtmlString = { result in
            XCTAssertEqual(result.type, .tenth)
            XCTAssertEqual(result.result, "h")
            expectation.fulfill()
        }
        
        findFirstTenthRequestFinished()
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFindEveryTenth() {
        let expectation = XCTestExpectation(description: "Test finding every tenth char")
        
        self.sut.updateHtmlString = { result in
            XCTAssertEqual(result.type, .everyTenth)
            XCTAssertEqual(result.result, "h,r,e")
            expectation.fulfill()
        }
        
        findEveryTenthRequestFinished()
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFindWordCount() {
        let expectation = XCTestExpectation(description: "Test finding word count")
        
        self.sut.updateHtmlString = { result in
            XCTAssertEqual(result.type, .wordCount)
            expectation.fulfill()
        }
        
        findWordCountRequestFinished()
        
        wait(for: [expectation], timeout: 3.0)
    }
}

extension ViewModelUnitTest {
    private func findFirstTenthRequestFinished() {
        mockService.completeWebData = DataGenerator.finishFetchWebData()
        self.sut.startFindTenthRequest()
        mockService.fetchSuccess()
    }
    
    private func findEveryTenthRequestFinished() {
        mockService.completeWebData = DataGenerator.finishFetchWebData()
        self.sut.startFindEveryTenthRequest()
        mockService.fetchSuccess()
    }
    
    private func findWordCountRequestFinished() {
        mockService.completeWebData = DataGenerator.finishFetchWebData()
        self.sut.startWordCount()
        mockService.fetchSuccess()
    }
}
