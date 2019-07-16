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
            //print("tag == 0");
            self.attachedView.tag = self.attachedView.hash;
        }
        else{
            //print("tag == \(self.attachedView.tag)");
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
    public func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttribute {
        self.attachedView.layer.shadowOpacity = Float(shadowOpacity);
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
    
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttribute {
        self.attachedView.clipsToBounds = clipsToBounds;
        return self;
    }
    
    func setXmlAttribute(attributeName: String, attributeValue: String) {
        let attributeVal = attributeValue.trimmingCharacters(in: .whitespaces);
        
        switch attributeName {
        case "frame":
            var frameArgs = PetralParser.parseFrame(attributeVal);
            self.frame(x: frameArgs[0], y: frameArgs[1], width: frameArgs[2], height: frameArgs[3]);
            break;
        case "backgroundColor":
            self.backgroundColor(PetralParser.parseColor(attributeVal));
            break;
        case "borderColor":
            self.borderColor(PetralParser.parseColor(attributeVal));
            break;
        case "borderWidth":
            self.borderWidth(PetralParser.parseFloat(attributeVal));
            break;
        case "borderRadius":
            self.borderRadius(PetralParser.parseFloat(attributeVal));
            break;
        case "shadowColor":
            self.shadowColor(PetralParser.parseColor(attributeVal));
            break;
        case "shadowOpacity":
            self.shadowOpacity(PetralParser.parseFloat(attributeVal));
            break;
        case "shadowRadius":
            self.shadowRadius(PetralParser.parseFloat(attributeVal));
            break;
        case "shadowOffset":
            self.shadowOffset(PetralParser.parseSize(attributeVal));
            break;
        case "masksToBounds":
            self.masksToBounds(PetralParser.parseBool(attributeVal));
            break;
        case "clipsToBounds":
            self.clipsToBounds(PetralParser.parseBool(attributeVal));
            break;
        default:
            break;
        }
    }
    
}

// MARK: -



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
    public func align(_ align: NSTextAlignment) -> PetralAttributeUIButton {
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUIButton {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUIButton {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUIButton {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUIButton {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUIButton {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUIButton {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "font":
            let fontValue = PetralParser.parseFont(attributeVal);
            self.font(size: fontValue[0], bold: (fontValue[1] == 1));
            break;
        case "titleColor":
            self.titleColor(PetralParser.parseColor(attributeVal), state: .normal);
            break;
        case "backgroundColor":
            self.backgroundColor(PetralParser.parseColor(attributeVal), state: .normal);
            break;
        case "backgroundColorHighlighted":
            self.backgroundColor(PetralParser.parseColor(attributeVal), state: .highlighted);
            break;
        case "backgroundImage":
            self.backgroundImage(UIImage.init(named: attributeVal)!, state: .normal);
            break;
        case "backgroundImageHighlighted":
            self.backgroundImage(UIImage.init(named: attributeVal)!, state: .highlighted);
            break;
        case "title":
            self.title(attributeVal, state: .normal);
            break;
        case "align":
            self.align(PetralParser.parseAlign(attributeVal));
            break;
        default:
            break;
        }
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

extension UIButton {
    
    @objc public override func petralize() -> PetralAttributeUIButton {
        return self.petralAttribute as! PetralAttributeUIButton;
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUIImageView {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUIImageView {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUIImageView {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUIImageView {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUIImageView {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUIImageView {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "image":
            self.image(UIImage.init(named: attributeVal)!)
            break;
        default:
            break;
        }
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUILabel {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUILabel {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUILabel {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUILabel {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUILabel {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUILabel {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "font":
            let fontValue = PetralParser.parseFont(attributeVal);
            self.font(size: fontValue[0], bold: (fontValue[1] == 1));
            break;
        case "textColor":
            self.textColor(PetralParser.parseColor(attributeVal));
            break;
        case "text":
            self.text(attributeVal);
            break;
        case "align":
            self.align(PetralParser.parseAlign(attributeVal));
            break;
        case "lines":
            self.lines(PetralParser.parseInt(attributeVal));
            break;
        default:
            break;
        }
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
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUIScrollView {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUIScrollView {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUIScrollView {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUIScrollView {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUIScrollView {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUIScrollView {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "contentSize":
            self.contentSize(PetralParser.parseSize(attributeVal));
            break;
        case "contentOffset":
            self.contentOffset(PetralParser.parsePoint(attributeVal));
            break;
        case "contentInset":
            self.contentInset(PetralParser.parseInset(attributeVal));
            break;
        default:
            break;
        }
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
    override public func contentSize(_ contentSize: CGSize) -> PetralAttributeUIScrollView {
        super.contentSize(contentSize);
        return self;
    }
    
    @discardableResult
    override public func contentOffset(_ contentOffset: CGPoint) -> PetralAttributeUIScrollView {
        super.contentOffset(contentOffset);
        return self;
    }
    
    @discardableResult
    override public func contentInset(_ contentInset: UIEdgeInsets) -> PetralAttributeUIScrollView {
        super.contentInset(contentInset);
        return self;
    }
    
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUITableView {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUITableView {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUITableView {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUITableView {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUITableView {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUITableView {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUITextField {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUITextField {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUITextField {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUITextField {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUITextField {
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUITextField {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "font":
            let fontArgs = PetralParser.parseFont(attributeVal);
            self.font(size: fontArgs[0], bold: (fontArgs[1] == 1));
            break;
        case "textColor":
            self.textColor(PetralParser.parseColor(attributeVal));
            break;
        case "text":
            self.text(attributeVal);
            break;
        case "placeholder":
            self.placeholder(attributeVal);
            break;
        case "align":
            self.align(PetralParser.parseAlign(attributeVal));
            break;
        case "isSecureText":
            self.isSecureText(PetralParser.parseBool(attributeVal));
            break;
        default:
            break;
        }
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
    
    @discardableResult
    public override func shadowColor(_ shadowColor: UIColor) -> PetralAttributeUITextView {
        super.shadowColor(shadowColor);
        return self;
    }
    
    @discardableResult
    public override func shadowOpacity(_ shadowOpacity: CGFloat) -> PetralAttributeUITextView {
        super.shadowOpacity(shadowOpacity);
        return self;
    }
    
    @discardableResult
    public override func shadowRadius(_ shadowRadius: CGFloat) -> PetralAttributeUITextView {
        super.shadowRadius(shadowRadius);
        return self;
    }
    
    @discardableResult
    public override func shadowOffset(_ shadowOffset: CGSize) -> PetralAttributeUITextView {
        super.shadowOffset(shadowOffset);
        return self;
    }
    
    @discardableResult
    public override func masksToBounds(_ masksToBounds: Bool) -> PetralAttributeUITextView{
        super.masksToBounds(masksToBounds);
        return self;
    }
    
    @discardableResult
    public override func clipsToBounds(_ clipsToBounds: Bool) -> PetralAttributeUITextView {
        super.clipsToBounds(clipsToBounds);
        return self;
    }
    
    override func setXmlAttribute(attributeName: String, attributeValue: String) {
        super.setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
        var attributeVal = attributeValue;
        if ["text", "placeholder"].contains(attributeName) == false {
            attributeVal = attributeVal.trimmingCharacters(in: .whitespaces);
        }
        switch attributeName {
        case "font":
            let fontArgs = PetralParser.parseFont(attributeVal);
            self.font(size: fontArgs[0], bold: (fontArgs[1] == 1));
            break;
        case "textColor":
            self.textColor(PetralParser.parseColor(attributeVal));
            break;
        case "text":
            self.text(attributeVal);
            break;
        case "align":
            self.align(PetralParser.parseAlign(attributeVal));
            break;
        case "isEditable":
            self.isEditable(PetralParser.parseBool(attributeVal));
            break;
        default:
            break;
        }
    }
}
