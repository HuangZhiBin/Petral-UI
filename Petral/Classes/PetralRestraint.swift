//
//  PetralRestraint.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit

enum PetralReferenceType{
    case inside
    case same
    case to
    case none
}

public class PetralRestraint: NSObject {
    weak var attachedView : UIView!;
    var restraints : [PetralRestraintItem]! = [];
    var dependings: [Int]! = [];//relative view's hash ids
    
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
    
    /*
    private func remove(type: PetralRestraintType){
        for item in self.restraints{
            if(item.type == type){
                self.restraints.remove(at: self.restraints.index(of: item)!);
            }
        }
    }*/
    
    private func set(type: PetralRestraintType, referenceView: UIView?, distance: CGFloat, referenceType: PetralReferenceType){
        if referenceView != nil{
            if(referenceView?.tag == 0){
                print("referenceView tag == 0");
                referenceView?.tag = (referenceView?.hash)!;
            }
            else{
                print("referenceView tag == \(referenceView?.tag ?? 0)");
            }
        }
        
        for item in self.restraints{
            if(item.type == type){
                //移除被依赖view的petralRelatives的元素，表示self.attachmentView已不再依赖这个view了
                let originReferenceView =  (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                originReferenceView.petralRestraint.dependings.remove(at: (originReferenceView.petralRestraint.dependings.index(of:self.attachedView.tag))!);
                self.restraints.remove(at: self.restraints.index(of: item)!);
            }
        }
        
        //增加被依赖view的petralRelatives的元素，表示self.attachmentView依赖这个view
        referenceView?.petralRestraint.dependings.append(self.attachedView.tag);
        self.restraints.append(PetralRestraintItem.init(type: type, referenceViewTag: referenceView != nil ? (referenceView?.tag)! : 0, distance: distance, referenceType: referenceType));
        
        self.handleConflicts();
    }
    
    private func handleConflicts(){
        var types : [PetralRestraintType] = [];
        if(self.restraints.count < 2){
            return;
        }
        for item in self.restraints{
            types.append(item.type);
        }
        let CONFLICTS : [[PetralRestraintType]] = [
            [PetralRestraintType.left, PetralRestraintType.right, PetralRestraintType.width],
            [PetralRestraintType.top, PetralRestraintType.bottom, PetralRestraintType.height],
            [PetralRestraintType.xCenter, PetralRestraintType.left],
            [PetralRestraintType.xCenter, PetralRestraintType.right],
            [PetralRestraintType.yCenter, PetralRestraintType.top],
            [PetralRestraintType.yCenter, PetralRestraintType.bottom],
        ];
        for conflicts in CONFLICTS{
            var conflictedCount = 0;
            for conflict in conflicts{
                if(types.contains(conflict)){
                    conflictedCount = conflictedCount + 1;
                }
            }
            if(conflictedCount == conflicts.count){
                fatalError("[Petral] UI Restraints conflicted! Due to rule :\(conflicts).");
            }
            
        }
    }
    
    private func existType(type: PetralRestraintType, referenceType: PetralReferenceType) -> Bool{
        for item in self.restraints{
            if(item.type == type && item.referenceType == referenceType){
                return true;
            }
        }
        return false;
    }
    
    private func filterType(type: PetralRestraintType) -> PetralRestraintItem{
        let arr = self.restraints.filter { (item: PetralRestraintItem) -> Bool in
            return item.type == type;
        }
        return arr[0];
    }
}

enum PetralRestraintType{
    case left
    case right
    case bottom
    case top
    case xCenter
    case yCenter
    case width
    case height
}

class PetralRestraintItem: NSObject {
    var type : PetralRestraintType!;
    var referenceViewTag : Int!;
    var distance: CGFloat!;
    var referenceType: PetralReferenceType!;
    
    init(type: PetralRestraintType, referenceViewTag: Int, distance: CGFloat, referenceType: PetralReferenceType) {
        super.init();
        self.type = type;
        self.referenceViewTag = referenceViewTag;
        self.distance = distance;
        self.referenceType = referenceType;
    }
}

extension PetralRestraint{
    
    //MARK: -
    
    public func pt_updateDependeds(){
        let dependedArray = Array(Set(self.dependings));
        for dependedViewTag in dependedArray {
            print("dependedViewTag=>\(dependedViewTag)");
            
            let dependedView = self.attachedView.superview?.viewWithTag(dependedViewTag);
            self.updateRestraintFor(view: dependedView!, theReferenceView: self.attachedView);
        }
    }
    
    private func updateRestraintFor(view: UIView, theReferenceView: UIView){
        for restraint in view.petralRestraint.restraints{
            if(restraint.referenceViewTag != theReferenceView.tag){
                continue;
            }
            let referenceView : UIView = (view.superview?.viewWithTag(restraint.referenceViewTag))!;
            switch restraint.type!{
            case .left:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_leftIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_leftAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.pt_leftTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .right:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_rightIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_rightAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.pt_rightTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .bottom:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_bottomIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_bottomAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.pt_bottomTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .top:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_topIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_topAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.pt_topTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .xCenter:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_xCenterIn(referenceView);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_xCenterAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    //do nothing
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .yCenter:
                if restraint.referenceType == .inside{
                    view.petralRestraint.pt_yCenterIn(referenceView);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.pt_yCenterAs(referenceView);
                }
                else if restraint.referenceType == .to{
                    //do nothing
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .width:
                if restraint.referenceType == .inside{
                    //do nothing
                }
                else if restraint.referenceType == .same{
                    //do nothing
                }
                else if restraint.referenceType == .to{
                    //do nothing
                }
                else if restraint.referenceType == .none{
                    view.petralRestraint.pt_width(restraint.distance);
                }
                break;
            case .height:
                if restraint.referenceType == .inside{
                    //do nothing
                }
                else if restraint.referenceType == .same{
                    //do nothing
                }
                else if restraint.referenceType == .to{
                    //do nothing
                }
                else if restraint.referenceType == .none{
                    view.petralRestraint.pt_height(restraint.distance);
                }
                break;
            }
            
            if(view.petralRestraint.dependings.count > 0){
                let dependedArray = Array(Set(view.petralRestraint.dependings));
                for dependedViewTag in dependedArray {
                    print("dependedViewTag=>\(dependedViewTag)");
                    
                    let dependedView = view.superview?.viewWithTag(dependedViewTag);
                    self.updateRestraintFor(view: dependedView!, theReferenceView: view);
                }
            }
        }
    }
    
    //MARK: -
    
    @discardableResult
    public func pt_xCenterAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: 0, referenceType: .same);
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width/2 - self.attachedView.frame.size.width/2, y: self.attachedView.frame.origin.y, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_xCenterTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_yCenterAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: 0, referenceType: .same);
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y + view.frame.size.height/2 - self.attachedView.frame.size.height/2, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_yCenterTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_centerAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: 0, referenceType: .same);
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: 0, referenceType: .same);
            
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width/2 - self.attachedView.frame.size.width/2, y: view.frame.origin.y + view.frame.size.height/2 - self.attachedView.frame.size.height/2, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_centerTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func pt_xCenterIn(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: 0, referenceType: .inside);
            self.attachedView.frame = CGRect.init(x: (view.frame.size.width - self.attachedView.frame.size.width) / 2, y: self.attachedView.frame.origin.y, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_xCenterIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_yCenterIn(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: 0, referenceType: .inside);
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: (view.frame.size.height - self.attachedView.frame.size.height) / 2, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_yCenterIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_centerIn(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: 0, referenceType: .inside);
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: 0, referenceType: .inside);
            
            self.attachedView.frame = CGRect.init(x: (view.frame.size.width - self.attachedView.frame.size.width) / 2, y: (view.frame.size.height - self.attachedView.frame.size.height) / 2, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_centerIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func pt_leftTo(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .left, referenceView: view, distance: distance, referenceType: .to);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .right, referenceType: .to)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x - item.distance - view.frame.origin.x - view.frame.size.width - distance;
            }
            else if(self.existType(type: .right, referenceType: .same)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - view.frame.origin.x - view.frame.size.width - distance;
            }
            else if(self.existType(type: .right, referenceType: .inside)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview)!;
                viewWidth = referenceView.frame.size.width - view.frame.origin.x - view.frame.size.width - distance - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width + distance, y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_leftTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_rightTo(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .right, referenceView: view, distance: distance, referenceType: .to);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .left, referenceType: .to)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = view.frame.origin.x - distance - referenceView.frame.origin.x - referenceView.frame.size.width - item.distance;
            }
            else if(self.existType(type: .left, referenceType: .same)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = view.frame.origin.x - distance - referenceView.frame.origin.x;
            }
            else if(self.existType(type: .left, referenceType: .inside)){
                let item = self.filterType(type: .left);
                viewWidth = view.frame.origin.x - distance - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x - viewWidth - distance, y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_rightTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_bottomTo(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .bottom, referenceView: view, distance: distance, referenceType: .to);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = view.frame.origin.y - referenceView.frame.size.height - referenceView.frame.origin.y - distance - item.distance;
            }
            else if(self.existType(type: .top, referenceType: .same)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = view.frame.origin.y - referenceView.frame.origin.y - distance;
            }
            else if(self.existType(type: .top, referenceType: .inside)){
                let item = self.filterType(type: .top);
                viewHeight = view.frame.origin.y - distance - item.distance;
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y - distance - viewHeight, width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: pt_bottomTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_topTo(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .top, referenceView: view, distance: distance, referenceType: .to);
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .bottom, referenceType: .to)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y - view.frame.size.height - view.frame.origin.y - distance - item.distance;
            }
            else if(self.existType(type: .bottom, referenceType: .same)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.size.height + referenceView.frame.origin.y - view.frame.size.height - view.frame.origin.y - distance;
            }
            else if(self.existType(type: .bottom, referenceType: .inside)){
                let item = self.filterType(type: .bottom);
                
                viewHeight = self.attachedView.superview!.frame.size.height - view.frame.size.height - view.frame.origin.y - distance - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y + view.frame.size.height + distance, width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: pt_topTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func pt_leftAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.pt_leftTo(view, distance: -view.frame.size.width);
            self.set(type: .left, referenceView: view, distance: 0, referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: pt_leftAs() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_rightAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.pt_rightTo(view, distance: -view.frame.size.width);
            self.set(type: .right, referenceView: view, distance: 0, referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: pt_rightAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    @discardableResult
    public func pt_topAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.pt_topTo(view, distance: -view.frame.size.height);
            self.set(type: .top, referenceView: view, distance: 0, referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: pt_topAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    @discardableResult
    public func pt_bottomAs(_ view: UIView) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.pt_bottomTo(view, distance: -view.frame.size.height);
            self.set(type: .bottom, referenceView: view, distance: 0, referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: pt_bottomAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func pt_leftIn(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .left, referenceView: view, distance: distance, referenceType: .inside);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .right, referenceType: .to)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x - item.distance - distance;
            }
            else if(self.existType(type: .right, referenceType: .same)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - distance;
            }
            else if(self.existType(type: .right, referenceType: .inside)){
                let item = self.filterType(type: .right);
                viewWidth = self.attachedView.superview!.frame.size.width - item.distance - distance;
            }
            
            self.attachedView.frame = CGRect.init(x: distance, y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_leftIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_rightIn(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .right, referenceView: view, distance: distance, referenceType: .inside);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .left, referenceType: .to)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = self.attachedView.superview!.frame.size.width - referenceView.frame.origin.x - referenceView.frame.size.width - item.distance - distance;
            }
            else if(self.existType(type: .left, referenceType: .same)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - distance;
            }
            else if(self.existType(type: .left, referenceType: .inside)){
                let item = self.filterType(type: .left);
                viewWidth = self.attachedView.superview!.frame.size.width - item.distance - distance;
            }
            
            self.attachedView.frame = CGRect.init(x: view.frame.size.width - viewWidth - distance, y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: pt_rightIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_topIn(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .top, referenceView: view, distance: distance, referenceType: .inside);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .bottom, referenceType: .to)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y - item.distance - distance;
            }
            else if(self.existType(type: .bottom, referenceType: .same)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y + referenceView.frame.size.height - distance;
            }
            else if(self.existType(type: .bottom, referenceType: .inside)){
                let item = self.filterType(type: .bottom);
                viewHeight = self.attachedView.superview!.frame.size.height - item.distance - distance;
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: distance, width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: pt_topIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func pt_bottomIn(_ view: UIView, distance: CGFloat) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .bottom, referenceView: view, distance: distance, referenceType: .inside);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = self.attachedView.superview!.frame.size.height - referenceView.frame.size.height - referenceView.frame.origin.y - item.distance - distance;
            }
            else if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = self.attachedView.superview!.frame.size.height - referenceView.frame.origin.y - distance;
            }
            else if(self.existType(type: .top, referenceType: .inside)){
                let item = self.filterType(type: .top);
                viewHeight = self.attachedView.superview!.frame.size.height - item.distance - distance;
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.size.height - viewHeight - distance, width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: pt_bottomIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    //MARK: - 
    
    @discardableResult
    public func pt_width(_ width: CGFloat) -> PetralRestraint{
        self.attachedView.petralRestraint.set(type: .width, referenceView: nil, distance: width, referenceType: .none);
        var viewLeft = self.attachedView.frame.origin.x;
        if(self.existType(type: .left, referenceType: .inside)){
            let item = self.filterType(type: .left);
            viewLeft = item.distance;
        }
        else if(self.existType(type: .left, referenceType: .to)){
            let item = self.filterType(type: .left);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewLeft = referenceView.frame.origin.x + referenceView.frame.size.width +  item.distance;
        }
        else if(self.existType(type: .right, referenceType: .inside)){
            let item = self.filterType(type: .right);
            viewLeft = self.attachedView.superview!.frame.size.width - width - item.distance;
        }
        else if(self.existType(type: .right, referenceType: .to)){
            let item = self.filterType(type: .right);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewLeft = referenceView.frame.origin.x - item.distance - width;
        }
        else if(self.existType(type: .xCenter, referenceType: .inside)){
            viewLeft = (self.attachedView.superview!.frame.size.width - width) / 2;
        }
        else if(self.existType(type: .xCenter, referenceType: .same)){
            let item = self.filterType(type: .xCenter);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewLeft = referenceView.frame.origin.x + referenceView.frame.size.width / 2 - width / 2;
        }
        self.attachedView.frame = CGRect.init(x: viewLeft, y: self.attachedView.frame.origin.y, width: width, height: self.attachedView.frame.size.height);
        
        return self;
    }
    
    @discardableResult
    public func pt_height(_ height: CGFloat) -> PetralRestraint{
        self.attachedView.petralRestraint.set(type: .height, referenceView: nil, distance: height, referenceType: .none);
        var viewTop = self.attachedView.frame.origin.y;
        if(self.existType(type: .top, referenceType: .inside)){
            let item = self.filterType(type: .top);
            viewTop = item.distance;
        }
        else if(self.existType(type: .top, referenceType: .to)){
            let item = self.filterType(type: .top);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewTop = referenceView.frame.size.height + referenceView.frame.origin.y + item.distance;
        }
        else if(self.existType(type: .bottom, referenceType: .inside)){
            let item = self.filterType(type: .bottom);
            viewTop = self.attachedView.superview!.frame.size.height - height - item.distance;
        }
        else if(self.existType(type: .bottom, referenceType: .to)){
            let item = self.filterType(type: .bottom);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewTop = referenceView.frame.origin.y - item.distance - height;
        }
        else if(self.existType(type: .yCenter, referenceType: .inside)){
            viewTop = (self.attachedView.superview!.frame.size.height - height) / 2;
        }
        else if(self.existType(type: .yCenter, referenceType: .same)){
            let item = self.filterType(type: .bottom);
            let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
            viewTop = referenceView.frame.origin.y + referenceView.frame.size.height / 2 - height / 2;
        }
        self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: viewTop, width: self.attachedView.frame.size.width, height: height);
        
        return self;
    }
}
