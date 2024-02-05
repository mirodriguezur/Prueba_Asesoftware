//
//  ListOfItemsRouter.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation
import UIKit

class ListOfItemsRouter {
    
    var viewController: ListOfItemsViewController?
    
    static func createListOfItemsViewController() -> ListOfItemsViewController {
        let interactor = ListOfItemsInteractor()
        let router = ListOfItemsRouter()
        let presenter = ListOfItemsPresenter(interactor: interactor, router: router)
        let view = ListOfItemsViewController(presenter: presenter)
        
        router.viewController = view
        presenter.view = view
        return view
    }
    
    func navigateToDetailItem(with item: ItemEntity) {
        let detailViewController = DetailItemRouter.createItemDetailViewController(with: item)
        self.viewController?.present(detailViewController, animated: true, completion: nil)
    }
}
