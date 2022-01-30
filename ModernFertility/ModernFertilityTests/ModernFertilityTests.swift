//
//  ModernFertilityTests.swift
//  ModernFertilityTests
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import XCTest
import OHHTTPStubs

@testable import ModernFertility

class ModernFertilityTests: XCTestCase {
    
    // MARK: - Properties
    
    var host: String = "jsonplaceholder.typicode.com"
    var path: String = "/album/1/photos"
    var stubbedJSON: [String : Any]!

    // MARK: - Testing Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        self.stubbedJSON = [:]
        HTTPStubs.removeAllStubs()
        
        try super.tearDownWithError()
    }
    
    // MARK: - Networking Tests
    
    func testRetrievingImages_isSuccessful() {
        // Create the GET stub for Images
        stub(condition: isHost(self.host)) { _ in
            let stubbedJSON = """
                              [
                                {
                                  "albumId": 1,
                                  "id": 1,
                                  "title": "accusamus beatae ad facilis cum similique qui sunt",
                                  "url": "https://via.placeholder.com/600/92c952",
                                  "thumbnailUrl": "https://via.placeholder.com/150/92c952"
                                },
                                {
                                  "albumId": 1,
                                  "id": 2,
                                  "title": "reprehenderit est deserunt velit ipsam",
                                  "url": "https://via.placeholder.com/600/771796",
                                  "thumbnailUrl": "https://via.placeholder.com/150/771796"
                                },
                                {
                                  "albumId": 1,
                                  "id": 3,
                                  "title": "officia porro iure quia iusto qui ipsa ut modi",
                                  "url": "https://via.placeholder.com/600/24f355",
                                  "thumbnailUrl": "https://via.placeholder.com/150/24f355"
                                }
                              ]
                              """
            
            return HTTPStubsResponse(
                data: stubbedJSON.data(using: .utf8)!,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        
        // Expectation
        let imageListExpectation = self.expectation(description: "We expected the getImages method's completion handler to be called.")
        
        // Code Under Test
        ImagesNetworking.getImages { (images, resultStatus) in
            switch resultStatus {
            case .success:
                
                if let imageList = images as? [Images] {
                    // Image One
                    XCTAssertEqual(imageList[0].id, 1)
                    XCTAssertEqual(imageList[0].url, "https://via.placeholder.com/600/92c952")
                    XCTAssertEqual(imageList[0].title, "accusamus beatae ad facilis cum similique qui sunt")
                    XCTAssertEqual(imageList[0].albumId, 1)
                    XCTAssertEqual(imageList[0].thumbnailUrl, "https://via.placeholder.com/150/92c952")
                    
                    // Image Two
                    XCTAssertEqual(imageList[1].id, 2)
                    XCTAssertEqual(imageList[1].url, "https://via.placeholder.com/600/771796")
                    XCTAssertEqual(imageList[1].title, "reprehenderit est deserunt velit ipsam")
                    XCTAssertEqual(imageList[1].albumId, 1)
                    XCTAssertEqual(imageList[1].thumbnailUrl, "https://via.placeholder.com/150/771796")
                    
                    // Image Three
                    XCTAssertEqual(imageList[2].id, 3)
                    XCTAssertEqual(imageList[2].url, "https://via.placeholder.com/600/24f355")
                    XCTAssertEqual(imageList[2].title, "officia porro iure quia iusto qui ipsa ut modi")
                    XCTAssertEqual(imageList[2].albumId, 1)
                    XCTAssertEqual(imageList[2].thumbnailUrl, "https://via.placeholder.com/150/24f355")
                } else {
                    XCTFail("We expected there to be three images returned.")
                }
                
                imageListExpectation.fulfill()
                
            case .failure:
                XCTFail()
            case .error:
                XCTFail()
            }
        }
        
        self.waitForExpectations(timeout: 5.0, handler: .none)
    }
}
