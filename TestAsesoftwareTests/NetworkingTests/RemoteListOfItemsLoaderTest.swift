//
//  RemoteListLoader.swift
//  TestAsesoftwareTests
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import XCTest
import TestAsesoftware

class HTTPClientSpy: HTTPClient {
    var requestedURLs = [URL]()
    var completions = [(HTTPClientResult) -> Void]()
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        requestedURLs.append(url)
        completions.append(completion)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        completions[index](.success(data, response))
    }
}

final class RemoteListOfItemsLoaderTest: XCTestCase {
    
    func test_load_requestListOfItemsFromURL() {
        let url = URL(string: "https://valid-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsListOfItemsFromURL() {
        let url = URL(string: "https://valid-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorWhenClientFails() {
        let (sut, client) = makeSUT()
        
        var capturedResults = [RemoteListOfItemsLoader.Error]()
        sut.load() { capturedResults.append($0)
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedResults, [.connectivity])
    }
    
    func test_load_deliversErrorWhenHTTPResponseIsDiferentTo200() {
        let (sut, client) = makeSUT()
        var capturedResults = [RemoteListOfItemsLoader.Error]()
        sut.load { capturedResults.append($0) }
        
        let statusResponseWithError = [400, 404, 500, 503]
        
        statusResponseWithError.forEach { statusCode in
            client.complete(withStatusCode: statusCode)
            XCTAssertEqual(capturedResults, [.invalidData])
            capturedResults = []
        }
    }
    
    //MARK: - helpers
    
    func makeSUT(url: URL = URL(string: "https://anyvalid-url.com")!) -> (sut: RemoteListOfItemsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteListOfItemsLoader(url: url, client: client)
        return(sut, client)
    }
    
}
