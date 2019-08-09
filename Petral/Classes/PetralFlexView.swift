//
//  PetralFlexView.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum PetralFlexDirectionType{
    case row
    case column
    case wrap
}

let PETRAL_FLEX_VIEW_NAME = "flexview";

let PETRAL_ATTRIBUTE_ITEM_COUNT = "p-item-count";
let PETRAL_ATTRIBUTE_DIRECTION = "p-direction";
let PETRAL_ATTRIBUTE_PADDING = "p-padding";
let PETRAL_ATTRIBUTE_ITEM_SPACE_X = "p-item-space-x";
let PETRAL_ATTRIBUTE_ITEM_SPACE_Y = "p-item-space-y";

let PETRAL_ATTRIBUTE_TEMPLATE = "template";

public typealias PetralFlexViewItemCountAction = () -> Int;
public typealias PetralFlexViewItemWidthAction = (_ index: Int) -> CGFloat;
public typealias PetralFlexViewItemHeightAction = (_ index: Int) -> CGFloat;
public typealias PetralFlexViewItemDisplayAction = (_ templateView : PetralFlexTemplateView, _ index: Int) -> Void;
public typealias PetralFlexViewItemClickAction = (_ templateView : PetralFlexTemplateView, _ index: Int) -> Void;

class PetralTapGestureRecognizer : UITapGestureRecognizer{
    var itemIndex: Int = -1;
    init(target: Any?, action: Selector?, itemIndex: Int) {
        super.init(target: target, action: action);
        self.itemIndex = itemIndex;
    }
}

public class PetralFlexView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    var elementCount : Int = 0;

    var direction: PetralFlexDirectionType! = .row;
    var padding: UIEdgeInsets! = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0);
    var itemSpaceX: CGFloat = 0;
    var itemSpaceY: CGFloat = 0;
    
//    var templateView: PetralFlexTemplateView!;
    var templateView: PetralFlexTemplateView!{
        didSet{
            self.reloadData();
        }
    }
    
    public var itemCountAction: PetralFlexViewItemCountAction? {
        didSet{
            self.reloadData();
        }
    }
    
    public var itemWidthAction: PetralFlexViewItemWidthAction? {
        didSet{
            self.refreshRectForItems();
        }
    }
    
    public var itemHeightAction: PetralFlexViewItemHeightAction? {
        didSet{
            self.refreshRectForItems();
        }
    }
    
    public var itemDisplayAction: PetralFlexViewItemDisplayAction? {
        didSet{
            for (index,item) in self.items.enumerated() {
                self.itemDisplayAction!(item, index);
            }
        }
    }
    
    public var itemClickAction: PetralFlexViewItemClickAction? {
        didSet{
            for (index,item) in self.items.enumerated() {
                item.removeGestureRecognizer(PetralTapGestureRecognizer.init(target: self, action: #selector(self.clickActionForIndex(recognizer:)),itemIndex: index));
                item.addGestureRecognizer(PetralTapGestureRecognizer.init(target: self, action: #selector(self.clickActionForIndex(recognizer:)),itemIndex: index));
            }
        }
    }
    
    var items: [PetralFlexTemplateView] {
        get{
            var templates: [PetralFlexTemplateView] = [];
            if self.subviews.count > 0 {
                for templateView in self.subviews {
                    templates.append(templateView as! PetralFlexTemplateView);
                }
            }
            return templates;
        }
    }
    
    @discardableResult
    public func resize() -> CGSize {
        if self.items.count > 0 {
            let lastItem = self.items.last;
            self.frame.size.width = (lastItem?.frame.size.width)! + (lastItem?.frame.origin.x)! + self.padding.right;
            self.frame.size.height = (lastItem?.frame.size.height)! + (lastItem?.frame.origin.y)! + self.padding.bottom;
        }
        return self.frame.size;
    }
    
    public func reloadData() {
        if self.itemCountAction != nil {
            self.elementCount = self.itemCountAction!();
        }
        
        self.reinitItems();
        self.refreshRectForItems();
        
        for (index,item) in self.items.enumerated() {
            if self.itemDisplayAction != nil {
                self.itemDisplayAction!(item, index);
            }
            
            if self.itemClickAction != nil {
                item.removeGestureRecognizer(PetralTapGestureRecognizer.init(target: self, action: #selector(self.clickActionForIndex(recognizer:)),itemIndex: index));
                item.addGestureRecognizer(PetralTapGestureRecognizer.init(target: self, action: #selector(self.clickActionForIndex(recognizer:)),itemIndex: index));
            }
        }
    }
    
    func reinitItems(){
        for item in self.items {
            item.removeFromSuperview();
        }
        
        if self.elementCount > 0 {
            for _ in 0 ... self.elementCount - 1 {
                let copyView : PetralFlexTemplateView = PetralUtil.duplicateView(view: self.templateView) as! PetralFlexTemplateView;
                PetralUtil.duplicateRestraints(sourceView: templateView, toView: copyView);
                self.saveSubTemplates(templateView: self.templateView, copiedView: copyView);
                self.addSubview(copyView);
                copyView.flexView = self;
            }
            self.refreshRectForItems();
        }
    }
    
    func saveSubTemplates(templateView: PetralFlexTemplateView, copiedView: PetralFlexTemplateView) {
        for (index,subview) in templateView.subviews.enumerated() {
            if subview.isKind(of: PetralFlexView.classForCoder()){
                let copiedFlexView : PetralFlexView = copiedView.subviews[index] as! PetralFlexView;
                copiedFlexView.elementCount = (subview as? PetralFlexView)!.elementCount;
                copiedFlexView.direction = (subview as? PetralFlexView)?.direction;
                copiedFlexView.padding = (subview as? PetralFlexView)?.padding;
                copiedFlexView.itemSpaceX = (subview as? PetralFlexView)!.itemSpaceX;
                copiedFlexView.itemSpaceY = (subview as? PetralFlexView)!.itemSpaceY;
                copiedFlexView.templateView = (subview as? PetralFlexView)?.templateView;
            }
        }
    }
    
    @objc func clickActionForIndex(recognizer: PetralTapGestureRecognizer) {
        self.itemClickAction!(recognizer.view as! PetralFlexTemplateView, recognizer.itemIndex);
    }
    
    func refreshRectForItems() {
        for (index,view) in self.items.enumerated() {
            var needUpdate = false;
            if self.itemWidthAction != nil {
                needUpdate = true;
                view.frame.size.width = self.itemWidthAction!(index);
            }
            if self.itemHeightAction != nil {
                needUpdate = true;
                view.frame.size.height = self.itemHeightAction!(index);
            }
            if needUpdate {
                view.petralRestraint.updateDependeds();
            }
            
            if index == 0 {
                view.frame.origin.x = self.padding.left;
                view.frame.origin.y = self.padding.top;
                continue;
            }
            let prevView = self.items[index - 1];
            if self.direction == .row {
                view.frame.origin.x = prevView.frame.origin.x + prevView.frame.size.width + self.itemSpaceX;
                view.frame.origin.y = prevView.frame.origin.y;
            }
            else if self.direction == .column {
                view.frame.origin.x = prevView.frame.origin.x;
                view.frame.origin.y = prevView.frame.origin.y + prevView.frame.size.height + self.itemSpaceY;
            }
            else if self.direction == .wrap {
                let realContainerWidth = self.frame.size.width - padding.left - padding.right;
                var x = prevView.frame.origin.x + prevView.frame.size.width + self.itemSpaceX;
                
                if x + view.frame.size.width > realContainerWidth {
                    x = self.padding.left;
                    let y = prevView.frame.origin.y + prevView.frame.size.height + self.itemSpaceY;
                    view.frame.origin = CGPoint.init(x: x, y: y);
                }
                else {
                    view.frame.origin = CGPoint.init(x: x, y: prevView.frame.origin.y);
                }
            }
        }
    }
    
    func viewForIndex(index: Int) -> PetralFlexTemplateView {
        return self.subviews[index] as! PetralFlexTemplateView;
    }
    
    /*
    func positionForItem(view: PetralFlexTemplateView, index: Int) -> CGPoint {
        if self.direction == .row {
            return CGPoint.init(x: (view.frame.size.width + self.itemSpaceX) * CGFloat(index), y: 0);
        }
        else if self.direction == .column {
            return CGPoint.init(x: 0, y: (view.frame.size.height + self.itemSpaceY) * CGFloat(index));
        }
        else if self.direction == .wrap {
            let realContainerWidth = self.containerView.frame.size.width;
            let itemsCountEachLine : Int = Int((realContainerWidth + self.itemSpaceX) / (view.frame.size.width + self.itemSpaceX));
            if itemsCountEachLine == 0 {
                return CGPoint.init(x: 0, y: 0);
            }
            let lineIndex : Int = index / itemsCountEachLine;
            let columnIndex : Int = index % itemsCountEachLine;
            return CGPoint.init(x: (view.frame.size.width + self.itemSpaceX) * CGFloat(columnIndex), y: (view.frame.size.height + self.itemSpaceY) * CGFloat(lineIndex));
        }
        return CGPoint.zero;
    }
    */
    
    func setXmlParam(attributeName: String, attributeValue: String) {
        switch attributeName {
        case PETRAL_ATTRIBUTE_ITEM_COUNT:
            self.elementCount = PetralParser.parseInt(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_PADDING:
            self.padding = PetralParser.parseInset(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_DIRECTION:
            self.direction = PetralParser.parseDirection(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_ITEM_SPACE_X:
            self.itemSpaceX = PetralParser.parseFloat(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_ITEM_SPACE_Y:
            self.itemSpaceY = PetralParser.parseFloat(attributeValue);
            break;
        default:
            break;
        }
    }
    
}

public class PetralFlexTemplateView: UIView {
    
    weak var flexView: PetralFlexView!;
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
//        self.clipsToBounds = true;等价功能
//        self.layer.masksToBounds = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
}
