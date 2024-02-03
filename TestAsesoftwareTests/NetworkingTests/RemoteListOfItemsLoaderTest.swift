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
    
    var sut: RemoteListOfItemsLoader!
    var client: HTTPClientSpy!
    var url: URL!

    override func setUp() {
        super.setUp()
        url = makeAnyURL()
        client = HTTPClientSpy()
        sut = RemoteListOfItemsLoader(url: url, client: client)
    }

    override func tearDown() {
        client = nil
        sut = nil
       super.tearDown()
    }
    
    func test_load_requestListOfItemsFromURL() {
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsListOfItemsFromURL() {
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorWhenClientFails() {
        var capturedResults = [RemoteListOfItemsLoader.Result]()
        sut.load() { capturedResults.append($0)
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedResults, [.failure(.connectivity)])
    }
    
    func test_load_deliversErrorWhenHTTPResponseIsDiferentTo200() {
        var capturedResults = [RemoteListOfItemsLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        let statusResponseWithError = [400, 404, 500, 503]
        statusResponseWithError.forEach { statusCode in
            client.complete(withStatusCode: statusCode)
            XCTAssertEqual(capturedResults, [.failure(.invalidData)])
            capturedResults = []
        }
    }
    
    func test_load_deliversErrorWhenResponseWithInvalidJSON(){
        var capturedResults = [RemoteListOfItemsLoader.Result]()
        sut.load { capturedResults.append($0)}
        
        let invalidJSON = Data(bytes: "invalid json", count: 0)
        client.complete(withStatusCode: 200, data: invalidJSON)
        
        XCTAssertEqual(capturedResults, [.failure(.invalidData)])
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let item1 = makeItem()
        let item1JSON = makeJSON(item: item1)
        
        let item2 = makeItem(albumId: 2, id: 2)
        let item2JSON = makeJSON(item: item2)
        
        let itemsJSON = [item1JSON, item2JSON]
        
        var capturedResults = [RemoteListOfItemsLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
        client.complete(withStatusCode: 200, data: json)
        
        XCTAssertEqual(capturedResults, [.success([item1, item2])])
    }
    
    func test_load_afterTheSutHasBeenDeinitializedItShouldReturnNoResult() {
        var capturedResults = [RemoteListOfItemsLoader.Result]()
        sut?.load { capturedResults.append($0)
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data(_: "[{}]".utf8))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK: - helpers
    
    func makeSUT(url: URL = URL(string: "https://anyvalid-url.com")!) -> (sut: RemoteListOfItemsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteListOfItemsLoader(url: url, client: client)
        return(sut, client)
    }
    
    func makeAnyURL() -> URL {
        URL(string: "https://anyurl.com")!
    }
    
    private func makeItem(albumId: Int = 1, id: Int = 1, title: String = "any title", url: URL = URL(string: "https://anyurl.com")!, thumbnailUrl: URL = URL(string:"https://anythumbnailurl.com")!) -> Item {
        Item(albumId: id, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
    
    private func makeJSON(item: Item) -> [String: Any] {
        [
            "albumId": item.albumId,
            "id": item.id,
            "title": item.title,
            "url": item.url.absoluteString,
            "thumbnailUrl": item.thumbnailUrl.absoluteString
        ]
    }
    
}
