//
//  TwitterCounterViewControllerTests.swift
//  
//
//  Created by Moataz Akram on 01/10/2022.
//

import XCTest
@testable import TwitterCounterPackage

final class TwitterCounterViewControllerTests: XCTestCase {
    var viewController: TwitterCounterViewController?

    override func setUp() {
        super.setUp()
        viewController = TwitterCounterViewController(appURL: "")
        viewController!.loadViewIfNeeded()
    }
    
    func testSetupUI() {
        viewController!.typedCount.text = "0/280"
        viewController!.remainingCount.text = "280"
        viewController!.textField.text = ""
        viewController!.textField.layer.cornerRadius = 0
        viewController!.copyTextButton.layer.cornerRadius = 0
        viewController!.clearTextButton.layer.cornerRadius = 0
        viewController!.postTweetButton.layer.cornerRadius = 0

        viewController!.setupUI()

        XCTAssertEqual(viewController!.typedCount.text, "0/280")
        XCTAssertEqual(viewController!.remainingCount.text, "280")
        XCTAssertEqual(viewController!.textField.text, viewController!.placeHolderText)
        XCTAssertEqual(viewController!.textField.layer.cornerRadius, 10)
        XCTAssertEqual(viewController!.copyTextButton.layer.cornerRadius, 10)
        XCTAssertEqual(viewController!.clearTextButton.layer.cornerRadius, 10)
        XCTAssertEqual(viewController!.postTweetButton.layer.cornerRadius, 10)
    }
    
    func testClearTextDidPress() {
        viewController!.textField.text = "test"
        XCTAssertNotEqual(viewController!.textField.text, viewController!.placeHolderText)
        viewController!.clearTextDidPress(viewController!)
        XCTAssertEqual(viewController!.textField.text, viewController!.placeHolderText)
    }
    
    func testTextViewDidBeginEditing() {
        viewController!.textField.text = viewController!.placeHolderText
        viewController!.textViewDidBeginEditing(viewController!.textField)
        XCTAssertEqual(viewController!.textField.text, "")
        viewController!.textField.text = "test"
        viewController!.textViewDidBeginEditing(viewController!.textField)
        XCTAssertEqual(viewController!.textField.text, "test")
    }

    func testTextViewDidEndEditing() {
        viewController!.textField.text = ""
        viewController!.textViewDidEndEditing(viewController!.textField)
        XCTAssertEqual(viewController!.textField.text, viewController!.placeHolderText)
    }

    func testTextViewDidChange() {
        viewController!.textField.text = "test"
        viewController!.textViewDidChange(viewController!.textField)
        XCTAssertEqual(viewController!.typedCount.text, "4/280")
        XCTAssertEqual(viewController!.remainingCount.text, "276")
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

}
