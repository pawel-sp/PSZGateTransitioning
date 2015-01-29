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
        return GateAnimator(target: self)
        }()
    
    var destinationViewController:DetailsTableViewController?
    var lastSelectedCell:TableViewCell?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        navigationController?.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController = segue.destinationViewController as? DetailsTableViewController {
            detailsViewController.selectedRecord = data[tableView.indexPathForSelectedRow()?.row ?? 0]
            destinationViewController            = detailsViewController
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell                   = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        cell.bottomTitleLabel.text = data[indexPath.row].text
        cell.backgroundColor       = data[indexPath.row].color
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastSelectedCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!) as? TableViewCell
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            gateAnimator.reversedDirection = operation == .Pop
            switch operation {
            case .Push: fallthrough
            case .Pop:  return gateAnimator
            default:    return nil
            }
    }
    
    // MARK: - Utilities
    
    var masterLabel:UILabel? {
        return lastSelectedCell?.bottomTitleLabel
    }
    
    var absoluteMasterLabelFrame:CGRect? {
        if lastSelectedCell != nil {
            return lastSelectedCell?.bottomTitleLabel.frame.rectByOffsetting(
                dx: 0,
                dy: lastSelectedCell!.frame.rectByOffsetting(dx: 0, dy: -tableView.contentOffset.y).origin.y
            )
        }
        return nil
    }
    
    // MARK: - GateAnimatorDelegate

    func snapShotViewsFrameForGateAnimator(gateAnimator: GateAnimator) -> SnapshotViews {
        return tableView.snapShotViews
    }
    
    func gateAnimator(gateAnimator:GateAnimator, animatedSubviewStartFrameForOperation operation:UINavigationControllerOperation) -> CGRect? {
        switch operation {
        case .Push: return absoluteMasterLabelFrame
        case .Pop:  return destinationViewController?.colorNameAbsoluteFrame
        default:    return nil
        }
    }
    
    func gateAnimator(gateAnimator: GateAnimator, animatedSubviewDestinationFrameForOperation operation: UINavigationControllerOperation) -> CGRect? {
        switch operation {
        case .Push: return destinationViewController?.colorNameAbsoluteFrame
        case .Pop:  return absoluteMasterLabelFrame
        default:    return nil
        }
    }
    
    func gateAnimator(gateAnimator: GateAnimator, animatedSubviewForOperation operation: UINavigationControllerOperation) -> UIView? {
        switch operation {
        case .Push: return masterLabel
        case .Pop:  return destinationViewController?.colorName
        default:    return nil
        }
    }
    
    func gateAnimator(gateAnimator: GateAnimator, animationWillStartForOperation operation: UINavigationControllerOperation) {
        switch operation {
        case .Push: masterLabel?.alpha                         = 0
                    destinationViewController?.colorName.alpha = 0
        case .Pop:  destinationViewController?.colorName.alpha = 0
        default:    break
        }
    }
    
    func gateAnimator(gateAnimator:GateAnimator, animationDidFinishForOperation operation:UINavigationControllerOperation) {
        switch operation {
        case .Push: destinationViewController?.colorName.alpha = 1
        case .Pop:  masterLabel?.alpha                         = 1
        default:    break
        }
    }
    
    func gateAnimator(gateAnimator: GateAnimator, transitionDurationForOperation operation: UINavigationControllerOperation) -> NSTimeInterval {
        switch operation {
        case .Push: return 1.5
        case .Pop:  return 1.0
        default:    return 1.0
        }
    }
}
