//
//  UIView+Petral.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

typealias PetralExcuteBlock = () -> Void;
func PETRAL(_ block: PetralExcuteBlock){
    block();
}



@objc protocol PetralViewProtocol {
    
    func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView;
    
    func pt_backgroundColor(_ color: UIColor) -> UIView;
    
    func pt_borderRadius(_ radius: CGFloat) -> UIView;
    
    func pt_borderWidth(_ borderWidth: CGFloat) -> UIView;
    
    func pt_borderColor(_ borderColor: UIColor) -> UIView;
    
    func pt_shadowColor(_ shadowColor: UIColor) -> UIView;
    
    func pt_shadowOpacity(_ shadowOpacity: Float) -> UIView;
    
    func pt_shadowRadius(_ shadowRadius: CGFloat) -> UIView;
    
    func pt_shadowOffset(_ shadowOffset: CGSize) -> UIView;

}

var PETRAL_PROPERTY = 1;

extension UIView : PetralViewProtocol{
    
    public var petralRestraint: PetralRestraint {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_PROPERTY) as? PetralRestraint
            if result == nil {
                //print("==1==");
                let restraint = PetralRestraint.init(self);
                self.petralRestraint = restraint;
                return restraint;
            }
            else{
                //print("==2==");
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PETRAL_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    @discardableResult
    public func pt_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        self.frame = CGRect.init(x: x, y: y, width: width, height: height);
        return self;
    }
    
    @discardableResult
    public func pt_backgroundColor(_ color: UIColor) -> UIView {
        self.backgroundColor = color;
        return self;
    }
    
    @discardableResult
    public func pt_borderRadius(_ radius: CGFloat) -> UIView {
        self.layer.cornerRadius = radius;
        return self;
    }
    
    @discardableResult
    public func pt_borderWidth(_ borderWidth: CGFloat) -> UIView {
        self.layer.borderWidth = borderWidth;
        return self;
    }
    
    @discardableResult
    public func pt_borderColor(_ borderColor: UIColor) -> UIView {
        self.layer.borderColor = borderColor.cgColor;
        return self;
    }
    
    @discardableResult
    public func pt_shadowColor(_ shadowColor: UIColor) -> UIView {
        self.layer.shadowColor = shadowColor.cgColor;
        return self;
    }
    
    @discardableResult
    public func pt_shadowOpacity(_ shadowOpacity: Float) -> UIView {
        self.layer.shadowOpacity = shadowOpacity;
        return self;
    }
    
    @discardableResult
    public func pt_shadowRadius(_ shadowRadius: CGFloat) -> UIView {
        self.layer.shadowRadius = shadowRadius;
        return self;
    }
    
    @discardableResult
    public func pt_shadowOffset(_ shadowOffset: CGSize) -> UIView {
        self.layer.shadowOffset = shadowOffset;
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
