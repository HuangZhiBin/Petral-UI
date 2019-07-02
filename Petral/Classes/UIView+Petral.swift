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

var PETRAL_RESTRAINT = 1;
var PETRAL_ATTRIBUTE = 2;

extension UIView {
    
    public var petralRestraint: PetralRestraint {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_RESTRAINT) as? PetralRestraint
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
            objc_setAssociatedObject(self, &PETRAL_RESTRAINT, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    //public func setPetralAttribute<T : PetralAttribute>() -> T{
    public var petralAttribute: PetralAttribute {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_ATTRIBUTE) as? PetralAttribute
            if result == nil {
                //print("==1==");
                var attribute : PetralAttribute;
                if(NSStringFromClass(self.classForCoder) == "UIButton"){
                    attribute = PetralAttributeUIButton.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UIImageView"){
                    attribute = PetralAttributeUIImageView.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UILabel"){
                    attribute = PetralAttributeUILabel.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UITextField"){
                    attribute = PetralAttributeUITextField.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UITextView"){
                    attribute = PetralAttributeUITextView.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UIScrollView"){
                    attribute = PetralAttributeUIScrollView.init(self);
                }
                else if(NSStringFromClass(self.classForCoder) == "UITableView"){
                    attribute = PetralAttributeUITableView.init(self);
                }
                else{
                    attribute = PetralAttribute.init(self);
                }
                self.petralAttribute = attribute;
                return attribute;
            }
            else{
                //print("==2==");
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PETRAL_ATTRIBUTE, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    @objc public func petralize() -> PetralAttribute {
        return self.petralAttribute;
    }

}


