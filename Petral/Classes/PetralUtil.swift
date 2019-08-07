//
//  PetralUtil.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class PetralUtil: NSObject {
    
    static func duplicateView(view: UIView) -> UIView {
        let data = NSKeyedArchiver.archivedData(withRootObject: view);
        let duplicateView = NSKeyedUnarchiver.unarchiveObject(with: data);
        self.copyLayer(sourceView: view, toView: (duplicateView as! UIView));
        
        //复制layer配置
        let subviews = self.getSubViews(view: (duplicateView as! UIView));
        let sourceSubviews = self.getSubViews(view: view);
        for (index,subview) in subviews.enumerated() {
            self.copyLayer(sourceView: sourceSubviews[index], toView: subview);
        }
        
        return duplicateView as! UIView;
    }
    
    static func copyLayer(sourceView: UIView, toView: UIView){
        toView.layer.masksToBounds = sourceView.layer.masksToBounds;
        toView.layer.cornerRadius = sourceView.layer.cornerRadius;
        toView.layer.borderColor = sourceView.layer.borderColor;
        toView.layer.borderWidth = sourceView.layer.borderWidth;
        toView.layer.shadowColor = sourceView.layer.shadowColor;
        toView.layer.shadowOffset = sourceView.layer.shadowOffset;
        toView.layer.shadowRadius = sourceView.layer.shadowRadius;
        toView.layer.shadowOpacity = sourceView.layer.shadowOpacity;
    }
    
    static func duplicateRestraints(sourceView: UIView, toView: UIView) {
        let subViews = getSubViews(view: sourceView);
        toView.petralRestraint.restraints = [];
        toView.petralRestraint.attachedView = toView;
        toView.petralRestraint.dependings = sourceView.petralRestraint.dependings;
        for subView in subViews {
            if subView.tag > 0 {
                let sameView : UIView = toView.viewWithTag(subView.tag)!;
                sameView.petralRestraint.restraints = subView.petralRestraint.restraints;
                sameView.petralRestraint.dependings = subView.petralRestraint.dependings;
                sameView.petralRestraint.attachedView = sameView;
            }
        }
    }
    
    static func getSubViews(view: UIView) -> [UIView] {
        var subViews : [UIView] = [];
        for subView in view.subviews {
            subViews.append(subView);
            if subView.subviews.count > 0 {
                let subSubViews = getSubViews(view: subView);
                for subSubView in subSubViews {
                    subViews.append(subSubView);
                }
            }
        }
        return subViews;
    }

}
