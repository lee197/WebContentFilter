//
//  TrueCalleriOSTests.swift
//  TrueCalleriOSTests
//
//  Created by Jason Lee on 05/07/2021.
//

import XCTest
@testable import TrueCalleriOS

class TrueCalleriOSTests: XCTestCase {
    var wordContentProcessor: WebContentProcessor!
    var wordContentProcessorShortString: WebContentProcessor!

    override func setUpWithError() throws {
        wordContentProcessor = WebContentProcessor(htmlString: MockHtmlString.generateSampleData())
        wordContentProcessorShortString = WebContentProcessor(htmlString: MockHtmlString.generateShortString())
    }

    override func tearDownWithError() throws {
        wordContentProcessor = nil
        wordContentProcessorShortString = nil
    }

    func testFindTenthCharacter() throws {
        let tenthChar = try! wordContentProcessor.findTenthCharacter()
        XCTAssertEqual(tenthChar, "h")
    }
    
    func testFindEveryTenthCharacter() throws {
        let everyTenthChar = try! wordContentProcessor.findEveryTenthCharacter()
        XCTAssertEqual(everyTenthChar, "h,r,e")
    }
    
    func testWordCount() throws {
        let wordCount = wordContentProcessor.wordCount()
        XCTAssertEqual(wordCount["html"], 2)
        XCTAssertEqual(wordCount["This"], 1)
    }
    
    func testShortStringInput() throws {
        XCTAssertThrowsError(try wordContentProcessorShortString.findTenthCharacter()) { error in
            XCTAssertEqual(error as! WebContentProcessorError, WebContentProcessorError.stringTooShort)
        }
    }
}

class MockHtmlString {
    static func generateSampleData() -> String {
        return "This is the html string for test html"
    }
    
    static func generateShortString() -> String {
        return "too short"
    }
    
    static func generateEmptyString() -> String {
        return ""
    }
}
