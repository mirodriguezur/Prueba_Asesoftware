//
//  ListOfItemsRouter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

class ListOfItemsRouter {
    static func createListOfItemsViewController() -> ListOfItemsViewController {
        let interactor = ListOfItemsInteractor()
        let presenter = ListOfItemsPresenter(interactor: interactor)
        let view = ListOfItemsViewController()
        view.presenter = presenter
        
        return view
    }
}
