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

enum PetralRestraintPriority{
    case low
    case medium //default level
    case high
}

public enum PetralRestraintType{
    case left
    case right
    case bottom
    case top
    case xCenter
    case yCenter
    case width
    case height
}

public class PetralRestraint: NSObject {
    private weak var attachedView : UIView!;
    private var restraints : [PetralRestraintItem]! = [];
    private var dependings: [Int]! = [];//relative view's hash ids
    
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
        for conflictRule in CONFLICTS{
            var conflictedCount = 0;
            for conflict in conflictRule{
                if(types.contains(conflict)){
                    conflictedCount = conflictedCount + 1;
                }
            }
            if(conflictedCount == conflictRule.count){
                fatalError("[Petral] UI Restraints conflicted! Due to rule :\(conflictRule).");
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
    
    public func reset(){
        self.restraints = [];
    }
    
    public func remove(type: PetralRestraintType){
        for item in self.restraints{
            if(item.type == type){
                self.restraints.remove(at: self.restraints.index(of: item)!);
                break;
            }
        }
    }
}



class PetralRestraintItem: NSObject {
    var type : PetralRestraintType!;
    var referenceViewTag : Int!;
    var distance: CGFloat!;
    var referenceType: PetralReferenceType!;
    var priority: PetralRestraintPriority! = .medium;
    
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
    
    
    
    public func updateDependeds(){
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
                    view.petralRestraint.leftIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.leftAs(referenceView, offset: restraint.distance);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.leftTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .right:
                if restraint.referenceType == .inside{
                    view.petralRestraint.rightIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.rightAs(referenceView, offset: restraint.distance);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.rightTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .bottom:
                if restraint.referenceType == .inside{
                    view.petralRestraint.bottomIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.bottomAs(referenceView, offset: restraint.distance);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.bottomTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .top:
                if restraint.referenceType == .inside{
                    view.petralRestraint.topIn(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.topAs(referenceView, offset: restraint.distance);
                }
                else if restraint.referenceType == .to{
                    view.petralRestraint.topTo(referenceView, distance: restraint.distance);
                }
                else if restraint.referenceType == .none{
                    //do nothing
                }
                break;
            case .xCenter:
                if restraint.referenceType == .inside{
                    view.petralRestraint.xCenterIn(referenceView);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.xCenterAs(referenceView, offset: restraint.distance);
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
                    view.petralRestraint.yCenterIn(referenceView);
                }
                else if restraint.referenceType == .same{
                    view.petralRestraint.yCenterAs(referenceView, offset: restraint.distance);
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
                    view.petralRestraint.width(restraint.distance);
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
                    view.petralRestraint.height(restraint.distance);
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
    public func xCenterAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: offset!, referenceType: .same);
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width/2 - self.attachedView.frame.size.width/2 + (offset ?? 0), y: self.attachedView.frame.origin.y, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: xCenterTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func yCenterAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: (offset ?? 0), referenceType: .same);
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y + view.frame.size.height/2 - self.attachedView.frame.size.height/2 + (offset ?? 0), width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: yCenterTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func centerAs(_ view: UIView, xOffset: CGFloat? = nil, yOffset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: (xOffset ?? 0), referenceType: .same);
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: (yOffset ?? 0), referenceType: .same);
            
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width/2 - self.attachedView.frame.size.width/2 + (xOffset ?? 0), y: view.frame.origin.y + view.frame.size.height/2 - self.attachedView.frame.size.height/2 + (yOffset ?? 0), width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: centerTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func xCenterIn(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: (offset ?? 0), referenceType: .inside);
            self.attachedView.frame = CGRect.init(x: (view.frame.size.width - self.attachedView.frame.size.width) / 2 + (offset ?? 0), y: self.attachedView.frame.origin.y, width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: xCenterIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func yCenterIn(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: (offset ?? 0), referenceType: .inside);
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: (view.frame.size.height - self.attachedView.frame.size.height) / 2 + (offset ?? 0), width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: yCenterIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func centerIn(_ view: UIView, xOffset: CGFloat? = nil, yOffset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .xCenter, referenceView: view, distance: (xOffset ?? 0), referenceType: .inside);
            self.attachedView.petralRestraint.set(type: .yCenter, referenceView: view, distance: (yOffset ?? 0), referenceType: .inside);
            
            self.attachedView.frame = CGRect.init(x: (view.frame.size.width - self.attachedView.frame.size.width) / 2 + (xOffset ?? 0), y: (view.frame.size.height - self.attachedView.frame.size.height) / 2 + (yOffset ?? 0), width: self.attachedView.frame.size.width, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: centerIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func locateIn(_ view: UIView, inset: UIEdgeInsets) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.topIn(view, distance: inset.top);
            self.bottomIn(view, distance: inset.bottom);
            self.leftIn(view, distance: inset.left);
            self.rightIn(view, distance: inset.right);
        }
        else{
            fatalError("[Petral-UI] Error: bottomIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func leftTo(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .left, referenceView: view, distance: (distance ?? 0), referenceType: .to);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .right, referenceType: .to)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x - item.distance - view.frame.origin.x - view.frame.size.width - (distance ?? 0);
            }
            else if(self.existType(type: .right, referenceType: .same)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - view.frame.origin.x - view.frame.size.width - (distance ?? 0);
            }
            else if(self.existType(type: .right, referenceType: .inside)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview)!;
                viewWidth = referenceView.frame.size.width - view.frame.origin.x - view.frame.size.width - (distance ?? 0) - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x + view.frame.size.width + (distance ?? 0), y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: leftTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func rightTo(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .right, referenceView: view, distance: (distance ?? 0), referenceType: .to);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .left, referenceType: .to)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = view.frame.origin.x - (distance ?? 0) - referenceView.frame.origin.x - referenceView.frame.size.width - item.distance;
            }
            else if(self.existType(type: .left, referenceType: .same)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = view.frame.origin.x - (distance ?? 0) - referenceView.frame.origin.x;
            }
            else if(self.existType(type: .left, referenceType: .inside)){
                let item = self.filterType(type: .left);
                viewWidth = view.frame.origin.x - (distance ?? 0) - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: view.frame.origin.x - viewWidth - (distance ?? 0), y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: rightTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func bottomTo(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .bottom, referenceView: view, distance: (distance ?? 0), referenceType: .to);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = view.frame.origin.y - referenceView.frame.size.height - referenceView.frame.origin.y - (distance ?? 0) - item.distance;
            }
            else if(self.existType(type: .top, referenceType: .same)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = view.frame.origin.y - referenceView.frame.origin.y - (distance ?? 0);
            }
            else if(self.existType(type: .top, referenceType: .inside)){
                let item = self.filterType(type: .top);
                viewHeight = view.frame.origin.y - (distance ?? 0) - item.distance;
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y - (distance ?? 0) - viewHeight, width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: bottomTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func topTo(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.attachedView.petralRestraint.set(type: .top, referenceView: view, distance: (distance ?? 0), referenceType: .to);
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .bottom, referenceType: .to)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y - view.frame.size.height - view.frame.origin.y - (distance ?? 0) - item.distance;
            }
            else if(self.existType(type: .bottom, referenceType: .same)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.size.height + referenceView.frame.origin.y - view.frame.size.height - view.frame.origin.y - (distance ?? 0);
            }
            else if(self.existType(type: .bottom, referenceType: .inside)){
                let item = self.filterType(type: .bottom);
                
                viewHeight = self.attachedView.superview!.frame.size.height - view.frame.size.height - view.frame.origin.y - (distance ?? 0) - item.distance;
            }
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.origin.y + view.frame.size.height + (distance ?? 0), width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: topTo() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func leftAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.leftTo(view, distance: -view.frame.size.width + (offset ?? 0));
            self.set(type: .left, referenceView: view, distance: (offset ?? 0), referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: leftAs() fail, because this view and the reference view should have the same superview");
        }
        
        return self;
    }
    
    @discardableResult
    public func rightAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.rightTo(view, distance: -view.frame.size.width - (offset ?? 0));
            self.set(type: .right, referenceView: view, distance: (offset ?? 0), referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: rightAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    @discardableResult
    public func topAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.topTo(view, distance: -view.frame.size.height + (offset ?? 0));
            self.set(type: .top, referenceView: view, distance: (offset ?? 0), referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: topAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    @discardableResult
    public func bottomAs(_ view: UIView, offset: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view.superview){
            self.bottomTo(view, distance: -view.frame.size.height - (offset ?? 0));
            self.set(type: .bottom, referenceView: view, distance: (offset ?? 0), referenceType: .same);
        }
        else{
            fatalError("[Petral-UI] Error: bottomAs() fail, because this view and the reference view should have the same superview");
        }
        return self;
    }
    
    //MARK: -
    
    @discardableResult
    public func leftIn(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .left, referenceView: view, distance: (distance ?? 0), referenceType: .inside);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .right, referenceType: .to)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x - item.distance - (distance ?? 0);
            }
            else if(self.existType(type: .right, referenceType: .same)){
                let item = self.filterType(type: .right);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - (distance ?? 0);
            }
            else if(self.existType(type: .right, referenceType: .inside)){
                let item = self.filterType(type: .right);
                viewWidth = self.attachedView.superview!.frame.size.width - item.distance - (distance ?? 0);
            }
            
            self.attachedView.frame = CGRect.init(x: (distance ?? 0), y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: leftIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func rightIn(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .right, referenceView: view, distance: (distance ?? 0), referenceType: .inside);
            
            var viewWidth = self.attachedView.frame.size.width;
            if(self.existType(type: .left, referenceType: .to)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = self.attachedView.superview!.frame.size.width - referenceView.frame.origin.x - referenceView.frame.size.width - item.distance - (distance ?? 0);
            }
            else if(self.existType(type: .left, referenceType: .same)){
                let item = self.filterType(type: .left);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewWidth = referenceView.frame.origin.x + referenceView.frame.size.width - (distance ?? 0);
            }
            else if(self.existType(type: .left, referenceType: .inside)){
                let item = self.filterType(type: .left);
                viewWidth = self.attachedView.superview!.frame.size.width - item.distance - (distance ?? 0);
            }
            
            self.attachedView.frame = CGRect.init(x: view.frame.size.width - viewWidth - (distance ?? 0), y: self.attachedView.frame.origin.y, width: viewWidth, height: self.attachedView.frame.size.height);
        }
        else{
            fatalError("[Petral-UI] Error: rightIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func topIn(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .top, referenceView: view, distance: (distance ?? 0), referenceType: .inside);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .bottom, referenceType: .to)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y - item.distance - (distance ?? 0);
            }
            else if(self.existType(type: .bottom, referenceType: .same)){
                let item = self.filterType(type: .bottom);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = referenceView.frame.origin.y + referenceView.frame.size.height - (distance ?? 0);
            }
            else if(self.existType(type: .bottom, referenceType: .inside)){
                let item = self.filterType(type: .bottom);
                viewHeight = self.attachedView.superview!.frame.size.height - item.distance - (distance ?? 0);
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: (distance ?? 0), width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: topIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    @discardableResult
    public func bottomIn(_ view: UIView, distance: CGFloat? = nil) -> PetralRestraint{
        if(self.attachedView.superview == view){
            self.attachedView.petralRestraint.set(type: .bottom, referenceView: view, distance: (distance ?? 0), referenceType: .inside);
            
            var viewHeight = self.attachedView.frame.size.height;
            if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = self.attachedView.superview!.frame.size.height - referenceView.frame.size.height - referenceView.frame.origin.y - item.distance - (distance ?? 0);
            }
            else if(self.existType(type: .top, referenceType: .to)){
                let item = self.filterType(type: .top);
                let referenceView : UIView = (self.attachedView.superview?.viewWithTag(item.referenceViewTag))!;
                
                viewHeight = self.attachedView.superview!.frame.size.height - referenceView.frame.origin.y - (distance ?? 0);
            }
            else if(self.existType(type: .top, referenceType: .inside)){
                let item = self.filterType(type: .top);
                viewHeight = self.attachedView.superview!.frame.size.height - item.distance - (distance ?? 0);
            }
            
            self.attachedView.frame = CGRect.init(x: self.attachedView.frame.origin.x, y: view.frame.size.height - viewHeight - (distance ?? 0), width: self.attachedView.frame.size.width, height: viewHeight);
        }
        else{
            fatalError("[Petral-UI] Error: bottomIn() fail, because this view's superview should be the reference view");
        }
        
        return self;
    }
    
    
    
    
    //MARK: - 
    
    @discardableResult
    public func width(_ width: CGFloat) -> PetralRestraint{
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
    public func height(_ height: CGFloat) -> PetralRestraint{
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
