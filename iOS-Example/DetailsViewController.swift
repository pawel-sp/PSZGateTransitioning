//
//  DetailsViewController.swift
//  iOS-Example
//
//  Created by Paweł Sporysz on 27.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Data
    
    var selectedRecord:Record?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        view.backgroundColor = selectedRecord?.color
        textLabel.text       = selectedRecord?.text
    }
    
}
