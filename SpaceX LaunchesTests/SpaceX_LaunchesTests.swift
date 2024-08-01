//
//  SpaceX_LaunchesTests.swift
//  SpaceX LaunchesTests
//
//  Created by Jekabs Solovjovs on 29/07/2024.
//

import XCTest
import SwiftUI
@testable import SpaceX_Launches

final class SpaceX_LaunchesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchCoding() throws {
        let sampleLaunch = Launch(
            id: "id",
            name: "name",
            date: Date(timeIntervalSince1970: 1583556631),
            success: true,
            upcoming: false,
            details: "Details",
            article: "article link",
            wikipedia: "wkipedia link",
            presskit: "presskit link",
            patchImageSmall: "patch small",
            patchImageLarge: "patch large",
            flickrImages: ["image1"]
        )
        
        let json = try JSONEncoder().encode(sampleLaunch)
        let testLaunch = try JSONDecoder().decode(Launch.self, from: json)
        XCTAssertEqual(testLaunch, sampleLaunch)
    }
    
    func testFormatDate() throws {
        let date1 = Date(timeIntervalSince1970: 0)
        let formattedDate1 = formatDate(date1)
        XCTAssertEqual(formattedDate1, "01.01.1970.")
        
        let date2 = Date(timeIntervalSince1970: 1711559957)
        let formattedDate2 = formatDate(date2)
        XCTAssertEqual(formattedDate2, "27.03.2024.")
    }
    
    func testFormatLaunchStatus() throws {
        let launchStatus1 = formatLaunchStatus(upcoming: true, success: nil)
        XCTAssertEqual(launchStatus1, LaunchStatus(title: "Upcoming", color: Color.yellow))
        
        let launchStatus2 = formatLaunchStatus(upcoming: true, success: true)
        XCTAssertEqual(launchStatus2, LaunchStatus(title: "Upcoming", color: Color.yellow))
        
        let launchStatus3 = formatLaunchStatus(upcoming: true, success: false)
        XCTAssertEqual(launchStatus3, LaunchStatus(title: "Upcoming", color: Color.yellow))
        
        let launchStatus4 = formatLaunchStatus(upcoming: false, success: true)
        XCTAssertEqual(launchStatus4, LaunchStatus(title: "Successful", color: Color.green))
        
        let launchStatus5 = formatLaunchStatus(upcoming: false, success: false)
        XCTAssertEqual(launchStatus5, LaunchStatus(title: "Unsuccessful", color: Color.red))
        
        let launchStatus6 = formatLaunchStatus(upcoming: false, success: nil)
        XCTAssertEqual(launchStatus6, LaunchStatus(title: "Unknown", color: Color.gray))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
