//
//  ListOfItemsPresenter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

protocol ListOfItemsPresenterInput {
    var listOfLocalItems: [ItemEntity] { get }
    func onViewAppear()
    func handleCellSelected(with item: ItemEntity)
    func updateTable(completion: @escaping () -> Void)
}

class ListOfItemsPresenter: ListOfItemsPresenterInput {
    private var router: ListOfItemsRouter
    weak var view: ListOfItemsViewControllerProtocol?
    private let interactor: ListOfItemsInteractorInput
    var listOfLocalItems: [ItemEntity] = []
    
    init(interactor: ListOfItemsInteractorInput, router: ListOfItemsRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onViewAppear() {
        interactor.checkListOfItemsFromCache { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .empty:
                self.interactor.getListOfItems { result in
                    switch result {
                    case let .success(items):
                        self.listOfLocalItems = items
                        self.interactor.requestSaveItemsOnCache(item: items) { error in
                            guard error == nil else {
                                self.view?.showSaveCacheAlert()
                                return
                            }
                        }
                        self.view?.update()
                        break
                    case let .failure(error):
                        self.view?.showRequestAlert()
                    }
                }
            case let .found(item: items):
                self.listOfLocalItems = items
                self.view?.update()
            case .failures:
                self.view?.showCheckCacheAlert()
            }
        }
    }
    
    func updateTable(completion: @escaping () -> Void) {
        interactor.getListOfItems { result in
            switch result {
            case let .success(items):
                self.listOfLocalItems = items
                self.interactor.requestSaveItemsOnCache(item: items) { error in
                    guard error == nil else {
                        self.view?.showSaveCacheAlert()
                        return completion()
                    }
                }
                self.view?.update()
                completion()
            case let .failure(error):
                self.view?.showRequestAlert()
                completion()
            }
        }
    }
    
    func handleCellSelected(with item: ItemEntity) {
        router.navigateToDetailItem(with: item)
    }
}
