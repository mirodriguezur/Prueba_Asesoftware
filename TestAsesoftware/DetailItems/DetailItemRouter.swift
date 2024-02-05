//
//  DetailItemRouter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation

class DetailItemRouter {
    static func createItemDetailViewController(with item: ItemEntity) -> DetailItemViewController {
        let interactor = DetailItemInteractor()
        let presenter = DetailItemPresenter(item: item, interactor: interactor)
        let view = DetailItemViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
