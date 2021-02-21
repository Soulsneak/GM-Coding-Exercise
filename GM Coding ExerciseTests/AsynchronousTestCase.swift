//
//  GM_Coding_ExerciseTests.swift
//  GM Coding ExerciseTests
//
//  Created by Derek on 2/21/21.
//

import XCTest
@testable import GM_Coding_Exercise
final class AsynchronousTestCase: XCTestCase {
    let timeout:TimeInterval = 2
    var expectation:XCTestExpectation!
    
    override func setUp() {
      expectation = expectation(description: "Sever responds in unreasonable time")
      
    }
    //Testing Server Response
    func test_noServerResponse(){
        let urlString = URL(string: "www.itunesapitesting.com/artist")!
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            defer { self.expectation.fulfill() }
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    //Testing to Decode an artist
    func test_decodeArtist(){
        let urlString = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=Slipknot")!
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            defer{ self.expectation.fulfill() }
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(MediaResponse.self, from: data)
                )
            }catch{ }
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    //Testing 400 Error
    func test_400(){
        let urlString = URL(string: "https://itunes.apple.com/search?=music&entity=sohh&term=Chicago")!
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            defer{ self.expectation.fulfill() }
            XCTAssertNil(error)
            
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 400)
                
                let _ = try JSONDecoder().decode(MediaResponse.self, from: XCTUnwrap(data))
                
                }catch{
                switch error{
                case DecodingError.keyNotFound(let key, _):
                    XCTAssertEqual(key.stringValue, "results")
                default:
                  XCTFail("\(error)")
                }
            }
        }.resume()
        waitForExpectations(timeout: timeout)
    }
    
    //Making fake data task manager to make sure data from json is not nil
    func test_client() throws{
        struct FakeDataTaskMaker:DataTaskMaker{
            static let dummyURL = URL(string: "dummy")!
            init() throws{
                let testBundle = Bundle(for: AsynchronousTestCase.self)
                let url = try XCTUnwrap(
                    testBundle.url(forResource: "TestArtist", withExtension: "json")
                )
                data = try Data(contentsOf: url)
            }
            let data:Data
            func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                completionHandler(
                  data,
                  HTTPURLResponse(url: Self.dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil),
                  nil
                )
                final class FakeDataTask:URLSessionDataTask{
                  override init(){}
                }
                return FakeDataTask()
            }
        }
        NetworkManager.shared.fetchArtist(artistName: "Slipknot"){ artist in
        defer { self.expectation.fulfill() }
        XCTAssertNotNil(artist)
       }
        waitForExpectations(timeout: timeout)
    }
}
