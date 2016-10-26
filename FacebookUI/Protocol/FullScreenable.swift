//
//  FullScreenable.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/26.
//  Copyright © 2016年 takuya. All rights reserved.
//

import Foundation
import UIKit

protocol FullScreenableDelegate: class {
    func updateNavigationBarframe(mutablenavigationBarFrame: CGRect)
}

class FullScreenable: NSObject, Scrollable {
    var upThresholdY: CGFloat = 0.0
    var donwThresholdY: CGFloat = 0.0
    var previusDirectioin: Direction = .none
    var previousOffsetY: CGFloat = 0.0
    var scrollDelegate: UIScrollViewDelegate?
    var fromViewController: UIViewController!
    init(scrollDelegate: UIScrollViewDelegate, fromViewController: UIViewController) {
        self.scrollDelegate = scrollDelegate
        self.fromViewController = fromViewController
    }

    
    func scrollDirection(currenOffsetY: CGFloat, previousOffsetY: CGFloat) -> Direction {
        if currenOffsetY > previousOffsetY {
            return .up
        } else if currenOffsetY < previousOffsetY {
            return .down
        } else {
            return .none
        }
    }
    
    func updateBarButtonItems(alpha: CGFloat, fromViewController: UIViewController) {
        if let leftButtonItems = fromViewController.navigationController?.navigationItem.leftBarButtonItems {
            for (_, value) in (leftButtonItems.enumerated()) {
                value.customView?.alpha = alpha
            }
        }
        
        if let rightBarButtonItems = fromViewController.navigationController?.navigationItem.rightBarButtonItems {
            for (_, value) in (rightBarButtonItems.enumerated()) {
                value.customView?.alpha = alpha
            }
        }
        fromViewController.navigationItem.titleView?.alpha = alpha
        fromViewController.navigationController?.navigationBar.tintColor = fromViewController.navigationController?.navigationBar.tintColor.withAlphaComponent(alpha)
    }
}

extension FullScreenable: UIScrollViewDelegate, UITableViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollDelegate?.scrollViewDidScroll!(scrollView)
        guard fromViewController != nil else {
            return
        }
        guard let navigationBarFrame = fromViewController.navigationController?.navigationBar.frame else {return}
        var mutablenavigationBarFrame = navigationBarFrame
        let size = mutablenavigationBarFrame.size.height - 21
        let framePercentageHidden = ((20 - mutablenavigationBarFrame.origin.y) / (mutablenavigationBarFrame.size.height - 1))
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousOffsetY
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if scrollOffset <= -scrollView.contentInset.top {
            mutablenavigationBarFrame.origin.y = 20
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            mutablenavigationBarFrame.origin.y = -size
        } else {
            mutablenavigationBarFrame.origin.y = min(20, max(-20, mutablenavigationBarFrame.origin.y - scrollDiff))
        }
        fromViewController.navigationController?.navigationBar.frame = mutablenavigationBarFrame
        updateBarButtonItems(alpha: 1 - framePercentageHidden, fromViewController: self.fromViewController)
        previousOffsetY = scrollOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
