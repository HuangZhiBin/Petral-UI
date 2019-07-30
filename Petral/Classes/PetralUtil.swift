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
        return duplicateView as! UIView;
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
