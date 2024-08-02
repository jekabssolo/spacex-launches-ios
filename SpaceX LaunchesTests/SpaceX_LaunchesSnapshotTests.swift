//
//  SpaceX_LaunchesSnapshotTests.swift
//  SpaceX LaunchesTests
//
//  Created by Jekabs Solovjovs on 02/08/2024.
//

import XCTest
import SwiftUI
import SwiftData
import SnapshotTesting
@testable import SpaceX_Launches

final class SpaceX_LaunchesSnapshotTests: XCTestCase {

    func testBadgeViewRed() {
        let view = BadgeView(color: Color.red, text: "Red badge")
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testBadgeViewGreen() {
        let view = BadgeView(color: Color.green, text: "Green badge")
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchListItemViewSuccessful() {
        let testLaunch = Launch.sampleLaunches[0]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchListItemView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchListItemViewUpcoming() {
        let testLaunch = Launch.sampleLaunches[1]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchListItemView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchListItemViewUnsuccessful() {
        let testLaunch = Launch.sampleLaunches[2]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchListItemView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchDetailsViewSuccessful() {
        let testLaunch = Launch.sampleLaunches[0]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchDetailsView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchDetailsViewUpcoming() {
        let testLaunch = Launch.sampleLaunches[1]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchDetailsView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testLaunchDetailsViewUnsuccessful() {
        let testLaunch = Launch.sampleLaunches[2]
        testLaunch.flickrImages = []
        testLaunch.patchImageSmall = nil
        testLaunch.patchImageLarge = nil
        
        let view = LaunchDetailsView(launch: testLaunch)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        
        assertSnapshot(of: viewController, as: .image)
    }
}
