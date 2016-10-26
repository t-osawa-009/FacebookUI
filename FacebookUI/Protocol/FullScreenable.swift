//
//  FullScreenable.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/26.
//  Copyright © 2016年 takuya. All rights reserved.
//

import Foundation
import UIKit

class FullScreenable: NSObject, Scrollable {
    var upThresholdY: CGFloat = 0.0
    var donwThresholdY: CGFloat = 0.0
    var previusDirectioin: Direction = .none
    var previousOffsetY: CGFloat = 0.0
    var scrollDelegate: UIScrollViewDelegate?
    
    init(scrollDelegate: NSObjectProtocol) {
        self.scrollDelegate = scrollDelegate as? UIScrollViewDelegate
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
}

extension FullScreenable: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll!(scrollView)
        var mutablenavigationBarFrame = UIScreen.main.bounds
        let size = mutablenavigationBarFrame.size.height - 21
        let framePercentageHidden = ((20 - mutablenavigationBarFrame.origin.y) / (mutablenavigationBarFrame.size.height - 1));
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

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension FullScreenable: UICollectionViewDelegate {
    
}

extension FullScreenable: UITableViewDelegate {
    
}
