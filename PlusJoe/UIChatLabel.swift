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
    
    var topInset:       CGFloat = 3
    var rightInset:     CGFloat = 10
    var bottomInset:    CGFloat = 3
    var leftInset:      CGFloat = 10
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()

        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
