//
//  TableViewController.swift
//  iOS-Example
//
//  Created by Paweł Sporysz on 27.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import UIKit
import PSZGateTransitioning

typealias Record = (color:UIColor, text:String)

class TableViewController: UITableViewController, UINavigationControllerDelegate, GateAnimatorDelegate {

    // MARK: - Properties
    
    let data:[Record] = [
        (UIColor.whiteColor(),  "WHITE"),
        (UIColor.redColor(),    "RED"),
        (UIColor.greenColor(),  "GREEN"),
        (UIColor.blueColor(),   "BLUE"),
        (UIColor.yellowColor(), "YELLOW"),
        (UIColor.orangeColor(), "ORANGE"),
        (UIColor.brownColor(),  "BROWN"),
        (UIColor.purpleColor(), "PURPLE")
    ]
    
    lazy var gateAnimator:GateAnimator = {
        return GateAnimator()
        }()
    
    var destinationViewController:UIViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        gateAnimator.delegate          = self
        navigationController?.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController = segue.destinationViewController as? DetailsViewController {
            detailsViewController.selectedRecord = data[tableView.indexPathForSelectedRow()?.row ?? 0]
            destinationViewController            = detailsViewController
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        cell.bottomTitleLabel.text = data[indexPath.row].text
        cell.backgroundColor = data[indexPath.row].color
        return cell
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(
        navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
            gateAnimator.reversedDirection = operation == .Pop
            switch operation {
            case .Push: fallthrough
            case .Pop:  return gateAnimator
            default:    return nil
            }
    }
    
    // MARK: - GateAnimatorDelegate
    
    func animatedCellSubViewForGateAnimator(gateAnimator: GateAnimator) -> UIView? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            if let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath) as? TableViewCell {
                return selectedCell.bottomTitleLabel
            }
        }
        return nil
    }
    
    func animatedCellSubViewDestinationFrame(gateAnimator: GateAnimator) -> CGRect {
        let statusBarHeight           = UIApplication.sharedApplication().statusBarFrame.height
        let navigationBarHeight       = navigationController?.navigationBar.frame.height ?? 0
        return (destinationViewController as? DetailsViewController)?.textLabel.frame.rectByOffsetting(dx: 0, dy: navigationBarHeight + statusBarHeight + 4) ?? CGRectZero
    }
}
