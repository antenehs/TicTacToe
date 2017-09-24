//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Anteneh Sahledengel on 8/30/17.
//  Copyright © 2017 Anteneh Sahledengel. All rights reserved.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let status = BoardManager.status(forBoard: Array(repeatElement(.x, count: 9)))
        XCTAssert(status == .Won, "Worng status")
        
        let status2 = BoardManager.status(forBoard: Array(repeatElement(.o, count: 9)))
        XCTAssert(status2 == .Lost, "Worng status")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
