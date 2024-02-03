//
//  ListOfItemsViewController.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 3/02/24.
//

import Foundation
import UIKit

class ListOfItemsViewController: UIViewController {
    
    var presenter: ListOfItemsPresenterInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewAppear()
    }
}
