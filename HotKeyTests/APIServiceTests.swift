//
//  HotKeyTests.swift
//  HotKeyTests
//
//  Created by Dev on 19/9/24.
//

import XCTest
@testable import HotKey

class APIServiceTests: XCTestCase {

    func testFetchHotKeywords() {
        let expectation = self.expectation(description: "Fetch Hot Keywords")
        
        APIService.shared.fetchHotKeywords { keywords in
            XCTAssertNotNil(keywords, "Keywords must not be nil")
            XCTAssertGreaterThan(keywords?.count ?? 0, 0, "Keywords must not be empty")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWithDI() {
        let expectation = self.expectation(description: "Fetch Hot Keywords")
        
        APIService.init(baseURL: BaseURL.uat.rawValue()).fetchHotKeywords { keywords in
            XCTAssertNotNil(keywords, "Keywords must not be nil")
            XCTAssertGreaterThan(keywords?.count ?? 0, 0, "Keywords must not be empty")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testParseHotKeywordResponse() {
        let jsonString = """
        {"data": {
                "items": [
                    {
                        "icon": "https://example.com/image1.png",
                        "name": "iPhone"
                    },
                    {
                        "icon": "https://example.com/image1.png",
                        "name": "iPhone"
                    },
                    {
                        "icon": "https://example.com/image1.png",
                        "name": "iPhone"
                    }
                ]
            }}
        """
        let jsonData = jsonString.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(HotKeywordResponse.self, from: jsonData)
            XCTAssertEqual(response.data.items.count, 3)
            XCTAssertEqual(response.data.items.first?.name, "iPhone")
        } catch {
            XCTFail("Parse JSON failed: \(error)")
        }
    }
}
