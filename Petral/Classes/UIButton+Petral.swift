//
//  UIButton+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UIButton {
    
    @discardableResult
    public func pt_font(size: CGFloat, bold: Bool) -> UIButton {
        self.titleLabel?.font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func pt_titleColor(_ titleColor: UIColor, state: UIControl.State) -> UIButton {
        self.setTitleColor(titleColor, for: state);
        return self;
    }
    
    @discardableResult
    public func pt_backgroundColor(_ color: UIColor, state: UIControl.State) -> UIButton {
        self.setBackgroundImage(self.createImageWithColor(color: color), for: state);
        return self;
    }
    
    @discardableResult
    public func pt_backgroundImage(_ image: UIImage, state: UIControl.State) -> UIButton {
        self.setBackgroundImage(image, for: state);
        return self;
    }
    
    @discardableResult
    public func pt_title(_ title: String, state: UIControl.State) -> UIButton {
        self.setTitle(title, for: state)
        return self;
    }
    
    @discardableResult
    public func pt_align(_ align: NSTextAlignment) -> UIButton{
        self.titleLabel?.textAlignment = align;
        return self;
    }
    
    @discardableResult
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIButton {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func pt_backgroundColor(_ color: UIColor) -> UIButton {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    override public func pt_borderRadius(_ radius: CGFloat) -> UIButton {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UIButton {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    override public func pt_borderColor(_ borderColor: UIColor) -> UIButton {
        self.layer.borderColor = borderColor.cgColor;
        return self;
    }
    
    private func createImageWithColor(color: UIColor) -> UIImage
    {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
