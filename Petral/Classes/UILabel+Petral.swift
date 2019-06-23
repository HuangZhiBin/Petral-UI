//
//  UILabel+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UILabel {
    
    @discardableResult
    public func pt_font(size: CGFloat, bold: Bool) -> UILabel {
        self.font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func pt_textColor(_ color: UIColor) -> UILabel {
        self.textColor = color;
        return self;
    }
    
    @discardableResult
    public func pt_text(_ text: String) -> UILabel {
        self.text = text;
        return self;
    }
    
    @discardableResult
    public func pt_lines(_ lines: Int) -> UILabel{
        self.numberOfLines = lines;
        return self;
    }
    
    @discardableResult
    public func pt_align(_ align: NSTextAlignment) -> UILabel{
        self.textAlignment = align;
        return self;
    }
    
    @discardableResult
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func pt_backgroundColor(_ color: UIColor) -> UILabel {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    override public func pt_borderRadius(_ radius: CGFloat) -> UILabel {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UILabel {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    override public func pt_borderColor(_ borderColor: UIColor) -> UILabel {
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
