//
//  Configuration.swift
//
//
//  Created by Alexandr Zalutskiy on 20/11/2023.
//

import SwiftMock
import XCTest

public enum SwiftMockConfiguration {
	public static func setUp() {
		testFailureReport = {
			XCTFail($0, file: $1, line: $2)
		}
	}
	
	public static func tearDown() {
		cleanUpMock()
	}
}
