//
//  JsonFileRevisionServerTests.swift
//  JsonFileRevisionServer
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import JsonFileRevisionServerTests

extension JsonFileRevisionServerTests {

	static var allTests : [(String, (JsonFileRevisionServerTests) -> () throws -> Void)] {
		return [
			("test", test),
		]
	}

}

XCTMain([
	testCase(JsonFileRevisionServerTests.allTests),
])

