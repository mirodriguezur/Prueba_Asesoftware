//
//  RemoteListLoader.swift
//  TestAsesoftwareTests
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import XCTest
import TestAsesoftware

class HTTPClientSpy: HTTPClient {
    var requestedURL = [URL]()
    
    func get(from url: URL) {
        requestedURL.append(url)
    }
}

final class RemoteListOfItemsLoaderTest: XCTestCase {
    
    func test_load_requestListOfItemsFromURL() {
        let url = URL(string: "https://valid-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loader()
        
        XCTAssertEqual(client.requestedURL, [url])
    }
    
    func test_loadTwice_requestsListOfItemsFromURL() {
        let url = URL(string: "https://valid-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loader()
        sut.loader()
        
        XCTAssertEqual(client.requestedURL, [url, url])
    }
    
    //MARK: - helpers
    
    func makeSUT(url: URL) -> (sut: RemoteListOfItemsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteListOfItemsLoader(url: url, client: client)
        return(sut, client)
    }
    
}
