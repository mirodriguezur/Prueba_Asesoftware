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
        interactor.getListOfItems { result in
            switch result {
            case let .success(items):
                self.listOfLocalItems = items
                self.view?.update()
                break
            default:
                break
            }
        }
    }
    
    func handleCellSelected(with item: ItemEntity) {
        router.navigateToDetailItem(with: item)
    }
}
