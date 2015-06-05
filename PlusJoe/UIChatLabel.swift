//
//  UIBorderedLabel.swift
//  PlusJoe
//
//  Created by D on 6/4/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class UIChatLabel: UILabel {
    
    var topInset:       CGFloat = 2
    var rightInset:     CGFloat = 2
    var bottomInset:    CGFloat = 2
    var leftInset:      CGFloat = 2
    
    override func drawTextInRect(rect: CGRect) {
        var insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
