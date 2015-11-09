//
//  DetailsTableViewController.swift
//  iOS-Example
//
//  Created by Paweł Sporysz on 29.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var topColorView: UIView!
    @IBOutlet weak var colorName: UILabel!
    
    // MARK: - Properties
    
    var selectedRecord:Record?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        topColorView.backgroundColor = selectedRecord?.color
        colorName.text               = selectedRecord?.text
    }
    
    // MARK: - Utilities
    
    var colorNameAbsoluteFrame:CGRect {
        return colorName.frame.offsetBy(dx: 0, dy: topColorView.frame.height - tableView.contentOffset.y)
    }
}
