//
//  UIScrollView+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

@objc protocol PetralScrollViewProtocol {
    
    func pt_contentSize(_ contentSize: CGSize) -> UIScrollView;
    
    func pt_contentOffset(_ contentOffset: CGPoint) -> UIScrollView;
    
    func pt_contentInset(_ contentInset: UIEdgeInsets) -> UIScrollView;
    
}

extension UIScrollView : PetralScrollViewProtocol {
    
    @discardableResult
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIScrollView {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func pt_backgroundColor(_ color: UIColor) -> UIScrollView {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    override public func pt_borderRadius(_ radius: CGFloat) -> UIScrollView {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UIScrollView {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    override public func pt_borderColor(_ borderColor: UIColor) -> UIScrollView {
        self.layer.borderColor = borderColor.cgColor;
        return self;
    }
    
    @discardableResult
    public func pt_contentSize(_ contentSize: CGSize) -> UIScrollView {
        self.contentSize = contentSize;
        return self;
    }
    
    @discardableResult
    public func pt_contentOffset(_ contentOffset: CGPoint) -> UIScrollView {
        self.contentOffset = contentOffset;
        return self;
    }
    
    @discardableResult
    public func pt_contentInset(_ contentInset: UIEdgeInsets) -> UIScrollView {
        self.contentInset = contentInset;
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
