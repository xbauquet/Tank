//
//  WebcastParserIntegrationTests.swift
//  TankTests
//
//  Created by Work on 03/03/2018.
//  Copyright © 2018 xbauquet. All rights reserved.
//

import Foundation
import XCTest
@testable import Tank

class WebcastParserIntegrationTests: XCTestCase, WebcastParserDelegate {
    
    var expectation: XCTestExpectation?
    
    func testPaserMethod() {
        expectation = XCTestExpectation(description: "Get Webcasts")
        WebcastParser().getWebcasts(delegate: self)
        wait(for: [expectation!], timeout: 5.0)
    }
    
    func parsed(webcasts: [Webcast]) {
        var isSuccessFull = true
        for webcast in webcasts {
            if webcast.title == nil || webcast.title!.isEmpty {
                isSuccessFull = false
                break
            }
            if webcast.date == nil || webcast.date!.isEmpty {
                isSuccessFull = false
                break
            }
            if webcast.description == nil || webcast.description!.isEmpty {
                isSuccessFull = false
                break
            }
            if webcast.url == nil || webcast.url!.isEmpty {
                isSuccessFull = false
                break
            }
            if webcast.imageLink == nil || webcast.imageLink!.isEmpty {
                isSuccessFull = false
                break
            }
        }
        XCTAssertTrue(isSuccessFull)
        if isSuccessFull {
            expectation?.fulfill()
        }
    }
}
