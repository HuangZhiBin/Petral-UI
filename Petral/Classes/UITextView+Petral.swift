//
//  UITextView+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UITextView {
    
    @discardableResult
    override public func pt_contentInset(_ contentInset: UIEdgeInsets) -> UITextView {
        self.contentInset = contentInset;
        return self;
    }
    
    @discardableResult
    public func pt_font(size: CGFloat, bold: Bool) -> UITextView {
        self.font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func pt_textColor(_ color: UIColor) -> UITextView {
        self.textColor = color;
        return self;
    }
    
    @discardableResult
    public func pt_text(_ text: String) -> UITextView {
        self.text = text;
        return self;
    }
    
    @discardableResult
    public func pt_align(_ align: NSTextAlignment) -> UITextView{
        self.textAlignment = align;
        return self;
    }
    
    @discardableResult
    public func pt_isEditable(_ isEditable: Bool) -> UITextView {
        self.isEditable = isEditable;
        return self;
    }
    
    @discardableResult
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UITextView {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func pt_backgroundColor(_ color: UIColor) -> UITextView {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    override public func pt_borderRadius(_ radius: CGFloat) -> UITextView {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UITextView {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    override public func pt_borderColor(_ borderColor: UIColor) -> UITextView {
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
