//
//  UITextField+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

extension UITextField {
    
    public func pt_font(size: CGFloat, bold: Bool) -> UITextField {
        self.font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    public func pt_textColor(_ color: UIColor) -> UITextField {
        self.textColor = color;
        return self;
    }
    
    public func pt_text(_ text: String) -> UITextField {
        self.text = text;
        return self;
    }
    
    public func pt_placeholder(_ placeholder: String) -> UITextField {
        self.placeholder = placeholder;
        return self;
    }
    
    public func pt_align(_ align: NSTextAlignment) -> UITextField{
        self.textAlignment = align;
        return self;
    }
    
    public func pt_isSecureText(_ isSecureTextEntry: Bool) -> UITextField {
        self.isSecureTextEntry = isSecureTextEntry;
        return self;
    }
    
    public func pt_keyboardType(_ keyboardType: UIKeyboardType) -> UITextField {
        self.keyboardType = keyboardType;
        return self;
    }
    
    override public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UITextField {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    override public func pt_backgroundColor(_ color: UIColor) -> UITextField {
        self.backgroundColor = color;
        return self;
    }
    
    override public func pt_borderRadius(_ radius: CGFloat) -> UITextField {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    override public func pt_borderWidth(_ borderWidth: CGFloat) -> UITextField {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    override public func pt_borderColor(_ borderColor: UIColor) -> UITextField {
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
