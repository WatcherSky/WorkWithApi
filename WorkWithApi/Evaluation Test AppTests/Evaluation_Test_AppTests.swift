//
//  Evaluation_Test_AppTests.swift
//  Evaluation Test AppTests
//
//  Created by Владимир on 13.10.2021.
//

import XCTest
@testable import Evaluation_Test_App

class Evaluation_Test_AppTests: XCTestCase {
   private  var resultsData: ResultsData?
   private  let urlStringRequest = "https://itunes.apple.com/search?term=Happier&media=music&entity=album"
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        resultsData = nil
    }

    func testForJsonGetData() throws { //Test if data from json isnt Nil
        NetworkManager.shared.getAlbums(urlString: urlStringRequest) { [unowned self] (resultsData) in
            guard let resultsData = resultsData else { return }
            self.resultsData = resultsData
            XCTAssertNotNil(resultsData)
        }
    }
}
