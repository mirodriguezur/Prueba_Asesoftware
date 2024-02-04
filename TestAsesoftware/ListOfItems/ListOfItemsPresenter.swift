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
}

class ListOfItemsPresenter: ListOfItemsPresenterInput {
    weak var view: ListOfItemsViewControllerProtocol?
    private let interactor: ListOfItemsInteractorInput
    var listOfLocalItems: [ItemEntity] = []
    
    init(interactor: ListOfItemsInteractorInput) {
        self.interactor = interactor
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
}
