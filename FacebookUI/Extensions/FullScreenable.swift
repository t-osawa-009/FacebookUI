//
//  FullScreenable.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/13.
//  Copyright © 2016年 takuya. All rights reserved.
//

import Foundation
import UIKit

protocol FullScreenable: UICollectionViewDelegate {}

protocol FullScreenableControllerDelegate {
    func fromeViewController() -> UIViewController
    func updateBarButtonItems(alpha: CGFloat)
}

final class FullScreenableController: NSObject, FullScreenable {
    fileprivate var previousScrollViewYOffset: CGFloat = 0.0
    var delegate: FullScreenableControllerDelegate?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBarFrame = delegate?.fromeViewController().navigationController?.navigationBar.frame else {return}
        var mutablenavigationBarFrame = navigationBarFrame
        let size = mutablenavigationBarFrame.size.height - 21
        let framePercentageHidden = ((20 - mutablenavigationBarFrame.origin.y) / (mutablenavigationBarFrame.size.height - 1));
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousScrollViewYOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if scrollOffset <= -scrollView.contentInset.top {
            mutablenavigationBarFrame.origin.y = 20
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            mutablenavigationBarFrame.origin.y = -size
        } else {
            mutablenavigationBarFrame.origin.y = min(20, max(-20, mutablenavigationBarFrame.origin.y - scrollDiff))
        }
        self.previousScrollViewYOffset = scrollOffset
        delegate?.updateBarButtonItems(alpha: 1 - framePercentageHidden)
    }
}
