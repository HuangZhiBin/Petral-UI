//
//  UIImageView+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    public func pt_image(_ image: UIImage) -> UIImageView {
        self.image = image;
        return self;
    }
    
    @discardableResult
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func pt_backgroundColor(_ color: UIColor) -> UIImageView {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    override public func pt_borderRadius(_ radius: CGFloat) -> UIImageView {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UIImageView {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    override public func pt_borderColor(_ borderColor: UIColor) -> UIImageView {
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
