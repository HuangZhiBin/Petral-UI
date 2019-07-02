//
//  PetralAttribute.swift
//  Petral
//
//  Created by BinHuang on 2019/6/26.
//

import UIKit

public class PetralAttribute: NSObject {
    
    public weak var attachedView : UIView!;
    
    init(_ attachedView: UIView) {
        super.init();
        self.attachedView = attachedView;
        if(self.attachedView.tag == 0){
            print("tag == 0");
            self.attachedView.tag = self.attachedView.hash;
        }
        else{
            print("tag == \(self.attachedView.tag)");
        }
    }
    
    @discardableResult
    public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttribute {
        self.attachedView.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> PetralAttribute {
        self.attachedView.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    public func borderRadius(_ radius: CGFloat) -> PetralAttribute {
        self.attachedView.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> PetralAttribute {
        self.attachedView.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    public func borderColor(_ borderColor: UIColor) -> PetralAttribute {
        self.attachedView.layer.borderColor = borderColor.cgColor;
        return self;
    }
    
    @discardableResult
    public func shadowColor(_ shadowColor: UIColor) -> PetralAttribute {
        self.attachedView.layer.shadowColor = shadowColor.cgColor;
        return self;
    }
    
    @discardableResult
    public func shadowOpacity(_ shadowOpacity: Float) -> PetralAttribute {
        self.attachedView.layer.shadowOpacity = shadowOpacity;
        return self;
    }
    
    @discardableResult
    public func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttribute {
        self.attachedView.layer.shadowRadius = shadowRadius;
        return self;
    }
    
    @discardableResult
    public func shadowOffset(_ shadowOffset: CGSize) -> PetralAttribute {
        self.attachedView.layer.shadowOffset = shadowOffset;
        return self;
    }
    
    @discardableResult
    public func masksToBounds(_ masksToBounds: Bool) -> PetralAttribute {
        self.attachedView.layer.masksToBounds = masksToBounds;
        return self;
    }
    
}

// MARK: -

extension UIButton {
    @objc public override func petralize() -> PetralAttributeUIButton {
        return self.petralAttribute as! PetralAttributeUIButton;
    }
}

public class PetralAttributeUIButton: PetralAttribute {
    
    @discardableResult
    public func font(size: CGFloat, bold: Bool) -> PetralAttributeUIButton {
        (self.attachedView as! UIButton).titleLabel?.font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func titleColor(_ titleColor: UIColor, state: UIControlState) -> PetralAttributeUIButton {
        (self.attachedView as! UIButton).setTitleColor(titleColor, for: state);
        return self;
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor, state: UIControlState) -> PetralAttributeUIButton {
        (self.attachedView as! UIButton).setBackgroundImage(self.createImageWithColor(color: color), for: state);
        return self;
    }
    
    @discardableResult
    public func backgroundImage(_ image: UIImage, state: UIControlState) -> PetralAttributeUIButton {
        (self.attachedView as! UIButton).setBackgroundImage(image, for: state);
        return self;
    }
    
    @discardableResult
    public func title(_ title: String, state: UIControlState) -> PetralAttributeUIButton {
        (self.attachedView as! UIButton).setTitle(title, for: state)
        return self;
    }
    
    @discardableResult
    public func align(_ align: NSTextAlignment) -> PetralAttributeUIButton{
        (self.attachedView as! UIButton).titleLabel?.textAlignment = align;
        return self;
    }
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUIButton {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUIButton {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUIButton {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUIButton {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUIButton {
        super.borderColor(borderColor);
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
}

// MARK: -

extension UIImageView {
    @objc public override func petralize() -> PetralAttributeUIImageView {
        return self.petralAttribute as! PetralAttributeUIImageView;
    }
}

public class PetralAttributeUIImageView: PetralAttribute{
    
    @discardableResult
    public func image(_ image: UIImage) -> PetralAttributeUIImageView {
        (self.attachedView as! UIImageView).image = image;
        return self;
    }
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUIImageView {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUIImageView {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUIImageView {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUIImageView {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUIImageView {
        super.borderColor(borderColor);
        return self;
    }
}

// MARK: -

extension UILabel {
    @objc public override func petralize() -> PetralAttributeUILabel {
        return self.petralAttribute as! PetralAttributeUILabel;
    }
}

public class PetralAttributeUILabel: PetralAttribute{
    
    @discardableResult
    public func font(size: CGFloat, bold: Bool) -> PetralAttributeUILabel {
        (self.attachedView as! UILabel).font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> PetralAttributeUILabel {
        (self.attachedView as! UILabel).textColor = color;
        return self;
    }
    
    @discardableResult
    public func text(_ text: String) -> PetralAttributeUILabel {
        (self.attachedView as! UILabel).text = text;
        return self;
    }
    
    @discardableResult
    public func lines(_ lines: Int) -> PetralAttributeUILabel{
        (self.attachedView as! UILabel).numberOfLines = lines;
        return self;
    }
    
    @discardableResult
    public func align(_ align: NSTextAlignment) -> PetralAttributeUILabel{
        (self.attachedView as! UILabel).textAlignment = align;
        return self;
    }
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUILabel {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUILabel {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUILabel {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUILabel {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUILabel {
        super.borderColor(borderColor);
        return self;
    }

}

// MARK: -

extension UIScrollView {
    @objc public override func petralize() -> PetralAttributeUIScrollView {
        return self.petralAttribute as! PetralAttributeUIScrollView;
    }
}

public class PetralAttributeUIScrollView: PetralAttribute{
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUIScrollView {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUIScrollView {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUIScrollView {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUIScrollView {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUIScrollView {
        super.borderColor(borderColor);
        return self;
    }
    
    @discardableResult
    public func contentSize(_ contentSize: CGSize) -> PetralAttributeUIScrollView {
        (self.attachedView as! UIScrollView).contentSize = contentSize;
        return self;
    }
    
    @discardableResult
    public func contentOffset(_ contentOffset: CGPoint) -> PetralAttributeUIScrollView {
        (self.attachedView as! UIScrollView).contentOffset = contentOffset;
        return self;
    }
    
    @discardableResult
    public func contentInset(_ contentInset: UIEdgeInsets) -> PetralAttributeUIScrollView {
        (self.attachedView as! UIScrollView).contentInset = contentInset;
        return self;
    }
    
}

// MARK: -

extension UITableView {
    @objc public override func petralize() -> PetralAttributeUITableView {
        return self.petralAttribute as! PetralAttributeUITableView;
    }
}

public class PetralAttributeUITableView: PetralAttributeUIScrollView {
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUITableView {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUITableView {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUITableView {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUITableView {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUITableView {
        super.borderColor(borderColor);
        return self;
    }
    
}

// MARK: -

extension UITextField {
    @objc public override func petralize() -> PetralAttributeUITextField {
        return self.petralAttribute as! PetralAttributeUITextField;
    }
}

public class PetralAttributeUITextField: PetralAttribute{
    
    @discardableResult
    public func font(size: CGFloat, bold: Bool) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).textColor = color;
        return self;
    }
    
    @discardableResult
    public func text(_ text: String) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).text = text;
        return self;
    }
    
    @discardableResult
    public func placeholder(_ placeholder: String) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).placeholder = placeholder;
        return self;
    }
    
    @discardableResult
    public func align(_ align: NSTextAlignment) -> PetralAttributeUITextField{
        (self.attachedView as! UITextField).textAlignment = align;
        return self;
    }
    
    @discardableResult
    public func isSecureText(_ isSecureTextEntry: Bool) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).isSecureTextEntry = isSecureTextEntry;
        return self;
    }
    
    @discardableResult
    public func keyboardType(_ keyboardType: UIKeyboardType) -> PetralAttributeUITextField {
        (self.attachedView as! UITextField).keyboardType = keyboardType;
        return self;
    }
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUITextField {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUITextField {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUITextField {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUITextField {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUITextField {
        super.borderColor(borderColor);
        return self;
    }
    
}

// MARK: -

extension UITextView {
    @objc public override func petralize() -> PetralAttributeUITextView {
        return self.petralAttribute as! PetralAttributeUITextView;
    }
}

public class PetralAttributeUITextView: PetralAttributeUIScrollView {
    
    @discardableResult
    public override func contentInset(_ contentInset: UIEdgeInsets) -> PetralAttributeUITextView {
        (self.attachedView as! UITextView).contentInset = contentInset;
        return self;
    }
    
    @discardableResult
    public func font(size: CGFloat, bold: Bool) -> PetralAttributeUITextView {
        (self.attachedView as! UITextView).font = bold == true ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size);
        return self;
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> PetralAttributeUITextView {
        (self.attachedView as! UITextView).textColor = color;
        return self;
    }
    
    @discardableResult
    public func text(_ text: String) -> PetralAttributeUITextView {
        (self.attachedView as! UITextView).text = text;
        return self;
    }
    
    @discardableResult
    public func align(_ align: NSTextAlignment) -> PetralAttributeUITextView{
        (self.attachedView as! UITextView).textAlignment = align;
        return self;
    }
    
    @discardableResult
    public func isEditable(_ isEditable: Bool) -> PetralAttributeUITextView {
        (self.attachedView as! UITextView).isEditable = isEditable;
        return self;
    }
    
    @discardableResult
    override public func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PetralAttributeUITextView {
        super.frame(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    override public func backgroundColor(_ color: UIColor) -> PetralAttributeUITextView {
        super.backgroundColor(color);
        return self;
    }
    
    @discardableResult
    override public func borderRadius(_ radius: CGFloat) -> PetralAttributeUITextView {
        super.borderRadius(radius);
        return self;
    }
    
    @discardableResult
    override public func borderWidth(_ borderWidth: CGFloat) -> PetralAttributeUITextView {
        super.borderWidth(borderWidth);
        return self;
    }
    
    @discardableResult
    override public func borderColor(_ borderColor: UIColor) -> PetralAttributeUITextView {
        super.borderColor(borderColor);
        return self;
    }
    
}
