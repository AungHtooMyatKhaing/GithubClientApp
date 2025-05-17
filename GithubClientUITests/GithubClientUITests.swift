//
//  GithubClientUITests.swift
//  GithubClientUITests
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import XCTest

final class GithubClientUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_scroll_shouldDismissKeyboard() {
        // Given
        let searchTextField = app.textFields["SearchTextField"]
        
        // When
        searchTextField.tap()
        
        let keyboard = app.keyboards.element
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10))
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        
        element.swipeUp()
        
        // Then
        let disappeared = keyboard.waitForExistence(timeout: 1.0) == false
        XCTAssertTrue(disappeared)
    }
    
    func test_tap_shouldRouteToDetail() {
        // Given
        let scrollViewsQuery = app.scrollViews
        
        // When/Then
        scrollViewsQuery
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element.tap()
    }
    
    func test_detail_shouldOpenProfileWebView() {
        // Given
        let scrollViewsQuery = app.scrollViews
        
        // When
        scrollViewsQuery
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .image).element(boundBy: 0).tap()
        
        // Then
        scrollViewsQuery.otherElements.images["link"].tap()
    }
    
    func test_detail_shouldOpenRepoWebView() {
        // Given
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        // When
        scrollViewsQuery
            .children(matching: .other)
            .element(boundBy: 0)
            .children(matching: .other)
            .element.tap()
        
        // Then
        elementsQuery
            .children(matching: .image)
            .matching(identifier: "star")
            .element(boundBy: 0)
            .tap()
    }
    
    func test_detail_shouldSwitchFilterOptions() {
        // Given
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery
            .children(matching: .other)
            .element(boundBy: 0).children(matching: .other)
            .element.children(matching: .image)
            .element(boundBy: 0).tap()
        
        // When/Then
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["arrow.down"].tap()
        elementsQuery.buttons["arrow.up"].tap()
        
        let chevronDownImage = elementsQuery.images["chevron.down"]
        chevronDownImage.tap()
        
        let popoverdismissregionElement = app.windows
            .children(matching: .other)
            .element(boundBy: 1)
            .otherElements["PopoverDismissRegion"]
        popoverdismissregionElement.tap()
        chevronDownImage.tap()
        popoverdismissregionElement.tap()
        
    }
}
