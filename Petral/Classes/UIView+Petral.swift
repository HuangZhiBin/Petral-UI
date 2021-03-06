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
var PETRAL_XML_RESOURCE = 3;
var PETRAL_XML_LOADER = 4;
var PETRAL_XML_VIEW_ID = 5;

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
    
    var petralAttribute: PetralAttribute {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_ATTRIBUTE) as? PetralAttribute
            if result == nil {
                //print("==1==");
                var attribute : PetralAttribute;
                if(self.isKind(of: UIButton.self)){
                    attribute = PetralAttributeUIButton.init(self);
                }
                else if(self.isKind(of: UIImageView.self)){
                    attribute = PetralAttributeUIImageView.init(self);
                }
                else if(self.isKind(of: UILabel.self)){
                    attribute = PetralAttributeUILabel.init(self);
                }
                else if(self.isKind(of: UITextField.self)){
                    attribute = PetralAttributeUITextField.init(self);
                }
                else if(self.isKind(of: UITextView.self)){
                    attribute = PetralAttributeUITextView.init(self);
                }
                //subclass should come first than superclass,e.g. UITableView->UIScrollView
                else if(self.isKind(of: UITableView.self)){
                    attribute = PetralAttributeUITableView.init(self);
                }
                else if(self.isKind(of: UIScrollView.self)){
                    attribute = PetralAttributeUIScrollView.init(self);
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
    
    var petralXmlViewId: String? {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_XML_VIEW_ID) as? String;
            return result
        }
        set{
            objc_setAssociatedObject(self, &PETRAL_XML_VIEW_ID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var petralXmlResource: String? {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_XML_RESOURCE) as? String;
            return result
        }
        set{
            objc_setAssociatedObject(self, &PETRAL_XML_RESOURCE, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    var petralXmlLoader: PetralLoader? {
        get{
            let result = objc_getAssociatedObject(self, &PETRAL_XML_LOADER) as? PetralLoader;
            return result
        }
        set{
            objc_setAssociatedObject(self, &PETRAL_XML_LOADER, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    @discardableResult
    @objc public func petralLoadXmlViews(xmlPath: String, properties: [String: String]? = nil) -> PetralViewLoader {
        for subview in self.subviews{
            subview.removeFromSuperview();
        }
        self.petralXmlResource = xmlPath;
        self.petralXmlLoader = PetralLoader.init(xmlFileName: self.petralXmlResource!, properties: properties);
        self.petralXmlLoader!.injectViews(toView: self);
        return PetralViewLoader.init(petralXmlLoader: self.petralXmlLoader);
    }
    
//    @objc public func petralViewById(id: String) -> UIView? {
//        return self.petralXmlLoader?.findViewById(id: id);
//    }
//
//    @objc public func petralViewById(id: String, template: UIView) -> UIView? {
//        return self.petralXmlLoader?.findViewById(id: id, template: template);
//    }
    
    @objc public func petralize() -> PetralAttribute {
        return self.petralAttribute;
    }

}

public class PetralViewLoader: NSObject {
    
    weak var petralXmlLoader: PetralLoader?;
    
    init(petralXmlLoader: PetralLoader?) {
        super.init();
        self.petralXmlLoader = petralXmlLoader;
    }
    
    public func petralViewById(id: String) -> UIView? {
        return self.petralXmlLoader?.findViewById(id: id);
    }
    
    public func petralViewById(id: String, inView: UIView) -> UIView? {
        return self.petralXmlLoader?.findViewById(id: id, template: inView);
    }

}


