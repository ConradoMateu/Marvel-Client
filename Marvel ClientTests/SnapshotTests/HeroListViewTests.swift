//
//  HeroListViewTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu on 28/4/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Marvel_Client

class HeroListViewTests: XCTestCase {

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

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      viewController = nil
    }

    @MainActor
    func testLoadingView() throws {
        let viewModel = HeroesViewModel(repository: DependencyInjector.fakeRepository())
        let mockHeroRow = HeroesListView(viewmodel: viewModel)
        viewController = UIHostingController(rootView: mockHeroRow)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8, precision: 0.90, traits: traitDarkMode))
    }

    @MainActor
    func testListView() throws {
        let viewModel = HeroesViewModel(repository: DependencyInjector.fakeRepository())
        let mockHeroRow = HeroesListView(viewmodel: viewModel)
        viewController = UIHostingController(rootView: mockHeroRow)
        viewModel.isLoading = false
        viewModel.viewModelError = nil
        viewModel.heroes = [HeroDTO.randomThumbnail, HeroDTO.randomThumbnail]
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8, precision: 0.80, traits: traitDarkMode))
    }

    @MainActor
    func testEmptyView() throws {
        let viewModel = HeroesViewModel(repository: DependencyInjector.fakeRepository())
        let mockHeroRow = HeroesListView(viewmodel: viewModel)
        viewController = UIHostingController(rootView: mockHeroRow)
        viewModel.heroes = []
        viewModel.isLoading = false
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8, precision: 0.90, traits: traitDarkMode))
    }

}
