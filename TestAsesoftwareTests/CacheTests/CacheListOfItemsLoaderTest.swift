//
//  CacheListOfItemsLoaderTest.swift
//  TestAsesoftwareTests
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import XCTest
import TestAsesoftware

class ItemStoreSpy: ItemStoreProtocol {
    
    
    var respondRetrieve = false
    var retrievalCompletions = [RetrievalCompletion]()
    private var insertionCompletions = [(Error?) -> Void]()
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        respondRetrieve = true
        retrievalCompletions.append(completion)
    }
    
    func insert(_ item: [Item], completion: @escaping (Error?) -> Void) {
        insertionCompletions.append(completion)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalSuccess(with item: [Item], at index: Int = 0) {
        retrievalCompletions[index](.found(item: item))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
}

final class CacheListOfItemsLoaderTest: XCTestCase {
    
    func test_load_requestCacheRetrievel() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertTrue(store.respondRetrieve)
    }
    
    func test_load_recoverEmptyIfThereAreNoSavedItems() {
        let (sut, store) = makeSUT()
        
        sut.load() { result in
            XCTAssertEqual(result, .success([]))
        }
        store.completeRetrievalWithEmptyCache()
    }
    
    func test_load_returnsErrorIfFailedToRetrieveitems() {
        let (sut, store) = makeSUT()
        
        sut.load() { result in
            XCTAssertEqual(result, .failure(.unablePerformRetrieval))
        }
        store.completeRetrieval(with: NSError())
    }
    
    func test_load_returnsItemSaved() {
        let (sut, store) = makeSUT()
        
        let item = Item(albumId: 1, id: 1, title: "", url:URL(string: "https://anyurl.com")!, thumbnailUrl: URL(string:"https://anyurl.com")!)
        
        sut.load() { result in
            XCTAssertEqual(result, .success([item]))
        }
        store.completeRetrievalSuccess(with: [item])
    }
    
    func test_save_returnErrorWhenUnableSaveData() {
        let (sut, store) = makeSUT()
        
        let item = Item(albumId: 1, id: 1, title: "", url:URL(string: "https://anyurl.com")!, thumbnailUrl: URL(string:"https://anyurl.com")!)
        
        sut.save([item]) { error in
            XCTAssertEqual(error, .unableSaveData)
        }
        store.completeInsertion(with: NSError())
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: CacheListOfItemsLoader, store: ItemStoreSpy) {
        let store = ItemStoreSpy()
        let sut = CacheListOfItemsLoader(store: store)
        return (sut, store)
    }

}
