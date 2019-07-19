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

let PETRAL_ATTRIBUTE_TIMES = "p-times";
let PETRAL_ATTRIBUTE_ITEM_SIZE = "p-item-size";
let PETRAL_ATTRIBUTE_DIRECTION = "p-direction";
let PETRAL_ATTRIBUTE_PADDING = "p-padding";
let PETRAL_ATTRIBUTE_ITEM_SPACE_X = "p-item-space-x";
let PETRAL_ATTRIBUTE_ITEM_SPACE_Y = "p-item-space-y";

let PETRAL_ATTRIBUTE_TEMPLATE = "template";

public typealias PetralFlexViewItemClickAction = (PetralFlexTemplateView, Int) -> Void;

class PetralTapGestureRecognizer : UITapGestureRecognizer{
    var itemIndex: Int = -1;
    init(target: Any?, action: Selector?, itemIndex: Int) {
        super.init(target: target, action: action);
        self.itemIndex = itemIndex;
    }
}

public class PetralFlexView: UIView {
    
    var elementCount : Int = 1;

    var itemSize: CGSize! = CGSize.zero;
    var direction: PetralFlexDirectionType! = .row;
    var padding: UIEdgeInsets! = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0);
    var itemSpaceX: CGFloat = 0;
    var itemSpaceY: CGFloat = 0;
    
    public var clickItemAction: PetralFlexViewItemClickAction? {
        didSet{
            for (index,item) in self.items.enumerated() {
                item.addGestureRecognizer(PetralTapGestureRecognizer.init(target: self, action: #selector(self.clickActionForIndex(recognizer:)),itemIndex: index));
            }
        }
    }
    
    public var items: [PetralFlexTemplateView] {
        get{
            var templates: [PetralFlexTemplateView] = [];
            for templateView in self.subviews[0].subviews {
                templates.append(templateView as! PetralFlexTemplateView);
            }
            return templates;
        }
    }
    
    lazy var containerView: UIView! = {
        let containerView = UIView.init();
        containerView.clipsToBounds = true;
        return containerView;
    }();
    
    @objc func clickActionForIndex(recognizer: PetralTapGestureRecognizer) {
        self.clickItemAction!(recognizer.view as! PetralFlexTemplateView, recognizer.itemIndex);
    }
    
    func viewForIndex(index: Int) -> PetralFlexTemplateView {
        return self.containerView.subviews[index] as! PetralFlexTemplateView;
    }
    
    func addItemView(view: PetralFlexTemplateView) {
        self.containerView.addSubview(view);
        view.flexView = self;
        let position = self.positionForItem(index: self.containerView.subviews.count - 1);
        view.frame = CGRect.init(x: position.x, y: position.y, width: self.itemSize.width, height: self.itemSize.height);
    }
    
    func positionForItem(index: Int) -> CGPoint {
        if self.containerView.superview == nil {
            self.addSubview(self.containerView);
            let realContainerWidth = self.frame.size.width - padding.left - padding.right;
            let realContainerHeight = self.frame.size.height - padding.top - padding.bottom; self.containerView.petralRestraint.topIn(offset: self.padding.top).leftIn(offset: self.padding.left).width(realContainerWidth).height(realContainerHeight);
        }
        if self.direction == .row {
            return CGPoint.init(x: (self.itemSize.width + self.itemSpaceX) * CGFloat(index), y: 0);
        }
        else if self.direction == .column {
            return CGPoint.init(x: 0, y: (self.itemSize.height + self.itemSpaceY) * CGFloat(index));
        }
        else if self.direction == .wrap {
            let realContainerWidth = self.containerView.frame.size.width;
            let itemsCountEachLine : Int = Int((realContainerWidth + self.itemSpaceX) / (self.itemSize.width + self.itemSpaceX));
            if itemsCountEachLine == 0 {
                return CGPoint.init(x: 0, y: 0);
            }
            let lineIndex : Int = index / itemsCountEachLine;
            let columnIndex : Int = index % itemsCountEachLine;
            return CGPoint.init(x: (self.itemSize.width + self.itemSpaceX) * CGFloat(columnIndex), y: (self.itemSize.height + self.itemSpaceY) * CGFloat(lineIndex));
        }
        return CGPoint.zero;
    }
    
    func setXmlParam(attributeName: String, attributeValue: String) {
        switch attributeName {
        case PETRAL_ATTRIBUTE_TIMES:
            self.elementCount = PetralParser.parseInt(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_PADDING:
            self.padding = PetralParser.parseInset(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_DIRECTION:
            self.direction = PetralParser.parseDirection(attributeValue);
            break;
        case PETRAL_ATTRIBUTE_ITEM_SIZE:
            self.itemSize = PetralParser.parseSize(attributeValue);
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

}
