//
//  HeroRowViewTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu on 28/4/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Marvel_Client

class HeroRowViewTests: XCTestCase {

    let mockHero = HeroDTO.randomThumbnail

    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewController: UIViewController!

    // To force theme color to be dark
    let traitDarkMode = UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)

    static override func setUp() {
        let device = UIDevice.current.name
        if device != "iPhone 8" {
            fatalError("Switch to using iPhone 8 for these tests.")
        }

        // To SpeedUp UITests
        UIView.setAnimationsEnabled(false)

        isRecording = false
    }

    override func setUpWithError() throws {
      try super.setUpWithError()
        let mockHeroRow = HeroRow(hero: mockHero).padding()
      viewController = UIHostingController(rootView: mockHeroRow)
    }

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      viewController = nil
    }

    func testHeroRow() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8, traits: traitDarkMode))
    }

}
