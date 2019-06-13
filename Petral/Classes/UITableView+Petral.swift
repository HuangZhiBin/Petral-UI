//
//  UITableView+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UITableView {
    
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UITableView {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    override public func pt_backgroundColor(_ color: UIColor) -> UITableView {
        self.backgroundColor = color;
        return self;
    }
    
    override public func pt_borderRadius(_ radius: CGFloat) -> UITableView {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UITableView {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    override public func pt_borderColor(_ borderColor: UIColor) -> UITableView {
        self.layer.borderColor = borderColor.cgColor;
        return self;
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
