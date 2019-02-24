//
//  Instabug_MoviesUITests.swift
//  Instabug MoviesUITests
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import XCTest
@testable import Instabug_Movies

class Instabug_MoviesUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["24/02/2016"]/*[[".cells.staticTexts[\"24\/02\/2016\"]",".staticTexts[\"24\/02\/2016\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Instabug_Movies.UserMoviesVC"].buttons["Movies"].tap()
        
        let tttStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Ttt"]/*[[".cells.staticTexts[\"Ttt\"]",".staticTexts[\"Ttt\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tttStaticText.tap()
        tttStaticText.tap()
        
        
    }
    
    


    func testLunchScreen(){
        app.launch()
    }
    func testMoviesListVC()  {
        app.launch()
        let movieListViewIsDisplay = app.otherElements["movieListView"]
        XCTAssertTrue(movieListViewIsDisplay.exists)
        
        let movies_tableView = app.tables["movies_tableView"]
        XCTAssertTrue(movies_tableView.exists)
        
        let cells = XCUIApplication().tables.cells
        if cells.count != 0 {
            let firstCell = cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists)
            // to expand cell
            firstCell.tap()
            // return cell to current size
            firstCell.tap()
            
            self.testingPullToRefresh(firstCell: movies_tableView)
        }else{
            self.testingPullToRefresh(firstCell: movies_tableView)
        }
        app.swipeUp()
        app.swipeUp()
        app.swipeDown()
        
    }
    func testingPullToRefresh(firstCell : XCUIElement ){
        let start = firstCell.coordinate(withNormalizedOffset:CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 3))
        start.press(forDuration: 0.1, thenDragTo: finish)
        
    }
    func test_addNewMovie(){
        app.launch()
  
        let movieListViewIsDisplay = app.otherElements["movieListView"]
        XCTAssertTrue(movieListViewIsDisplay.exists)
        
        let addButton = app.navigationBars["Movies"].buttons["Add"]
        XCTAssertTrue(movieListViewIsDisplay.exists)
        addButton.tap()
        
      
        
        
        let btn_save = app.buttons["btn_saveMovieElement"]
        XCTAssertTrue(btn_save.exists)
        btn_save.tap()
        app.alerts["!"].buttons["Dismiss"].tap()
        
        
        let btn_select_img = app.buttons["btn_selectImageElement"]
        XCTAssertTrue(btn_select_img.exists)

        let txt_title = app.textFields["movie_txt_titleElement"]
        XCTAssertTrue(txt_title.exists)
        txt_title.tap()
   
        
        // SET KEYBOARD INPUT IS ENG
        let tKey = app.keys["t"]
        let eKey = app.keys["e"]
        let sKey = app.keys["s"]
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        app.buttons["Return"].tap()

        
        let txt_date = app.textFields["movie_txt_dateElement"]
        XCTAssertTrue(txt_date.exists)
        txt_date.tap()

        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "March")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2019")
        app.toolbars["Toolbar"].buttons["Select"].tap()
        
        txt_date.tap()
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        
        
        let txt_overview = app.textViews["overviewElement"]
        XCTAssertTrue(txt_overview.exists)
        
        txt_overview.tap()
        app.keyboards.keys["more, numbers"].tap()
        app.keyboards.keys["1"].tap()
        app.keyboards.keys["2"].tap()
        app.keyboards.keys["3"].tap()
        app.keyboards.keys["4"].tap()

        btn_save.tap()
        
        
    }
    
    
    func testMyMoviesView ()  {
        app.launch()
        app.navigationBars["Movies"].buttons["My Movies"].tap()
        
        let myMovies_tableView = app.tables["myMovies_tableView"]
        XCTAssertTrue(myMovies_tableView.exists)
        
        let cells = XCUIApplication().tables.cells
        if cells.count != 0 {
            let firstCell = cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists)
            // to expand cell
            firstCell.tap()
            // return cell to current size
            firstCell.tap()
            
            app.swipeUp()
            app.swipeUp()
            app.swipeDown()
        }
     
    }
}
