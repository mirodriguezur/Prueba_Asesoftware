//
//  DetailItemPresenter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation

protocol DetailItemPresenterInput {
    func onViewAppear()
    func handleDeleteButtonTapped()
}

class DetailItemPresenter: DetailItemPresenterInput {
    weak var view: DetailItemViewProtocol?
    var item: ItemEntity
    private let interactor: DetailItemInteractor
    
    init(item: ItemEntity, interactor: DetailItemInteractor) {
        self.item = item
        self.interactor = interactor
    }
    
    func onViewAppear() {
        view?.update(with: item)
    }
    
    func handleDeleteButtonTapped() {
        interactor.requestDeleteItem(itemId: item.id) { [weak self] wasSuccesful in
            guard let self = self else { return }
            guard wasSuccesful else {
                self.view?.showErrorAlert()
                return
            }
            self.view?.showSucessAlert()
        }
    }
}
