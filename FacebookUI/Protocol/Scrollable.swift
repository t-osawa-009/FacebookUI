//
//  Scrollable.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/26.
//  Copyright © 2016年 takuya. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case none
    case up
    case down
}

protocol Scrollable: class {
    var upThresholdY: CGFloat {get set}
    var donwThresholdY: CGFloat {get set}
    var previusDirectioin: Direction {get set}
    var previousOffsetY: CGFloat {get set}
    var scrollDelegate: UIScrollViewDelegate? {get set}
    func scrollDirection(currenOffsetY: CGFloat, previousOffsetY: CGFloat) -> Direction
}
