//
//  Instabug_MoviesTests.swift
//  Instabug MoviesTests
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import XCTest
@testable import Instabug_Movies

class Instabug_MoviesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
    
    func test_full_unitTest(){
        self.testCodableDecode()
        self.testCodableParseToJson()
        self.testSaveCoreData()
        self.testFeatchCoreData()
        self.testMovieViewModel()
    }
    
    
    private let temp_model = Movie.init(id: 0 ,
                                                title: "Movie Title",
                                                overview: "Movie Overview",
                                                release_date: "12/01/2019",
                                                poster_path: "poster url path")
    
    func testCodableDecode(){
        let temp_jsonData = ["title":"temp Title" as AnyObject,
                             "overview" : "temp overview"  as AnyObject,
                             "release_date": "12/01/2019" as AnyObject ,
                             "poster_path" : "poster url path" as AnyObject]
        
        if let movieJsonData = JsonHandler.jsonToNSData(json: temp_jsonData) {
            let modelParse = CodableHandler.decode(Movie.self, from: movieJsonData)
            if modelParse is Movie {
                print("Success")
            }else{
                fatalError("Can`t Decode Json")
            }
        }else{
            fatalError("Can`t parse Temp Array to Data")

        }
        
    }
    func testCodableParseToJson(){
      XCTAssert( ((CodableHandler.encode(temp_model) as? [String : AnyObject]) != nil)) 
        print("Success Parsing")
    }
    func testSaveCoreData() {
        guard let parseToJson = CodableHandler.encode(temp_model) as? [String : AnyObject] else {
            fatalError("Can`t parse TempModel to [String : AnyObject] Array")
        }
        XCTAssert(CoreDataHandler.inset(entityName: Constant.entityMovieName ,entityData: parseToJson))
        print("Success Adding")
    }
    func testFeatchCoreData(){
        if let result = CoreDataHandler.featchData(entityName: Constant.entityMovieName) {
             XCTAssert((result as Any) is [[String : AnyObject]])
        }else{
            fatalError("failures featch data")
        }
       

    }
    func testMovieViewModel()  {
        var temp_viewModel = MovieViewModel(movie: self.temp_model)
        XCTAssertEqual(temp_viewModel.titleString , self.temp_model.title)
        XCTAssertEqual(temp_viewModel.overViewString , self.temp_model.overview)
        XCTAssertEqual(temp_viewModel.dateString , self.temp_model.release_date)
        XCTAssertEqual(temp_viewModel.img_poster , "\(Constant.imgUrl)\(self.temp_model.poster_path ?? "")")
        
        temp_viewModel = MovieViewModel(movie: self.temp_model , isUserMovie : true)
        XCTAssertEqual(temp_viewModel.img_poster , self.temp_model.poster_path ?? "")
        
        print("Passed")

    }
    
    
    
    
    

}
