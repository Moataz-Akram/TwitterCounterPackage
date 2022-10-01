//
//  TwitterCounterViewModelTests.swift
//  
//
//  Created by Moataz Akram on 01/10/2022.
//

import XCTest
@testable import TwitterCounterPackage
import Reachability

final class TwitterCounterViewModelTests: XCTestCase {
    var viewModel: TwitterCounterViewModel?

    override func setUp() {
        super.setUp()
        viewModel = TwitterCounterViewModel(oauthCallback: "")
    }
    
    func testInit() {
        XCTAssertNotNil(viewModel!.client)
        viewModel!.client = nil
        XCTAssertNil(viewModel!.client)
        viewModel = TwitterCounterViewModel(oauthCallback: "")
        XCTAssertNotNil(viewModel!.client)
    }
    
    func testReachability() {
        let reachability = try! Reachability()
        switch reachability.connection {
            case .wifi, .cellular:
            XCTAssertTrue(viewModel!.checkInternetConnection())
            default:
            XCTAssertFalse(viewModel!.checkInternetConnection())
        }
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }


}
