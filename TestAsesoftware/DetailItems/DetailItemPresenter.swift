//
//  DetailItemPresenter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation

protocol DetailItemPresenterInput {
    func onViewAppear()
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
    
}
