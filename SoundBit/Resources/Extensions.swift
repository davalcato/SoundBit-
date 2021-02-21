//
//  Extensions.swift
//  SoundBit
//
//  Created by Daval Cato on 2/21/21.
//

import Foundation
import UIKit

// Add a couple of computed properties
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
    
}















