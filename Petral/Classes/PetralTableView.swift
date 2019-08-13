//
//  PetralTableView.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

let PETRAL_ELEMENT_HEADER = "header";
let PETRAL_ELEMENT_FOOTER = "footer";
let PETRAL_ELEMENT_CELL = "cell";
let PETRAL_ELEMENT_SECTION_HEADER = "section-header";
let PETRAL_ELEMENT_SECTION_FOOTER = "section-footer";

let PETRAL_ATTRIBUTE_ROWS = "p-rows";
let PETRAL_ATTRIBUTE_SECTIONS = "p-sections";

public typealias PetralTableViewCellDisplayAction = (_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void;
public typealias PetralTableViewSectionHeaderDisplayAction = (_ headerView: UIView, _ section : Int) -> Void;
public typealias PetralTableViewSectionFooterDisplayAction = (_ footerView: UIView, _ section : Int) -> Void;
public typealias PetralTableViewCellRowCountAction = (_ section: Int) -> Int;
public typealias PetralTableViewCellSectionCountAction = () -> Int;
public typealias PetralTableViewCellClickAction = (_ indexPath: IndexPath) -> Void;
public typealias PetralTableViewCellRowHeightAction = (_ indexPath: IndexPath) -> CGFloat;
public typealias PetralTableViewSectionHeaderHeightAction = (_ section: Int) -> CGFloat;
public typealias PetralTableViewSectionFooterHeightAction = (_ section: Int) -> CGFloat;

private var identifierMitTemplate: [String: UIView] = [:];

public class PetralTableView: UITableView {

    var CELL_IDENTIFIER = "";
    
    public var tableCellDisplayAction: PetralTableViewCellDisplayAction?;
    public var tableSectionHeaderDisplayAction: PetralTableViewSectionHeaderDisplayAction?;
    public var tableSectionFooterDisplayAction: PetralTableViewSectionFooterDisplayAction?;
    public var tableCellRowCountAction: PetralTableViewCellRowCountAction?;
    public var tableSectionCountAction: PetralTableViewCellSectionCountAction?;
    public var tableCellClickAction: PetralTableViewCellClickAction?;
    public var tableCellRowHeightAction: PetralTableViewCellRowHeightAction?;
    public var tableSectionHeightForHeaderAction: PetralTableViewSectionHeaderHeightAction?;
    public var tableSectionHeightForFooterAction: PetralTableViewSectionFooterHeightAction?;
    
    var cellHeight: CGFloat = 0;
    var sectionHeightHeader: CGFloat = CGFloat.leastNormalMagnitude;
    var sectionHeightFooter: CGFloat = CGFloat.leastNormalMagnitude;
    
    var cellView: UIView? {
        didSet{
            self.CELL_IDENTIFIER = "CELL_IDENTIFIER_" + String(self.hash);
            identifierMitTemplate[self.CELL_IDENTIFIER] = self.cellView;
            self.register(PetralTableViewCell.self, forCellReuseIdentifier: self.CELL_IDENTIFIER);
            self.delegate = self;
            self.dataSource = self;
        }
    }
    
    var sectionHeaderView: UIView?;
    
    var sectionFooterView: UIView?;
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style);
        
//        let tableView = self;
        
//        if(tableView.responds(to: #selector(setter: UITableView.separatorInset))) {
//            tableView.separatorInset = UIEdgeInsets.zero;
//        }
//        if(tableView.responds(to: #selector(setter: UITableView.layoutMargins))) {
//            tableView.layoutMargins = UIEdgeInsets.zero;
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setXmlParam(attributeName: String, attributeValue: String) {
        switch attributeName {
        case PETRAL_ATTRIBUTE_ROWS:
            self.tableCellRowCountAction = { (section: Int) in
                return PetralParser.parseInt(attributeValue);
            };
            break;
        case PETRAL_ATTRIBUTE_SECTIONS:
            self.tableSectionCountAction = {
                return PetralParser.parseInt(attributeValue);
            };
            break;
        default:
            break;
        }
    }
    
    deinit {
        print("tableview deinit");
        if identifierMitTemplate.keys.contains(self.CELL_IDENTIFIER) {
            identifierMitTemplate.removeValue(forKey: self.CELL_IDENTIFIER);
        }
    }
    
    
}

extension PetralTableView : UITableViewDelegate,UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableSectionCountAction != nil {
            return self.tableSectionCountAction!();
        }
        return 1;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableCellRowCountAction != nil {
            return self.tableCellRowCountAction!(section);
        }
        return 0;
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.sectionHeaderView == nil {
            return nil;
        }
        let headerView = PetralUtil.duplicateView(view: self.sectionHeaderView!);
        PetralUtil.duplicateRestraints(sourceView: self.sectionHeaderView!, toView: headerView);
        
        if self.tableSectionHeightForHeaderAction != nil {
            headerView.frame.size.height = self.tableSectionHeightForHeaderAction!(section);
            headerView.petralRestraint.updateDependeds();
        }
        
        if self.tableSectionHeaderDisplayAction != nil {
            self.tableSectionHeaderDisplayAction!(headerView, section);
        }
        
        return headerView;
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.sectionFooterView == nil {
            return nil;
        }
        
        let footerView = PetralUtil.duplicateView(view: self.sectionFooterView!);
        PetralUtil.duplicateRestraints(sourceView: self.sectionFooterView!, toView: footerView);
        
        if self.tableSectionHeightForFooterAction != nil {
            footerView.frame.size.height = self.tableSectionHeightForFooterAction!(section);
            footerView.petralRestraint.updateDependeds();
        }
        
        if self.tableSectionFooterDisplayAction != nil {
            self.tableSectionFooterDisplayAction!(footerView, section);
        }
        
        return footerView;
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableSectionHeightForHeaderAction != nil {
            return self.tableSectionHeightForHeaderAction!(section);
        }
        
        return self.sectionHeightHeader;
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableSectionHeightForFooterAction != nil {
            return self.tableSectionHeightForFooterAction!(section);
        }
        return self.sectionHeightFooter;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableCellRowHeightAction != nil {
            return self.tableCellRowHeightAction!(indexPath);
        }
        return self.cellHeight;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! PetralTableViewCell;
        cell.contentView.petralRestraint.updateDependeds();
        if self.tableCellDisplayAction != nil {
            self.tableCellDisplayAction!(cell, indexPath);
        }
        return cell;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        
        if self.tableCellClickAction != nil {
            self.tableCellClickAction!(indexPath);
        }
    }
    
    
}

class PetralTableViewCell: UITableViewCell {
    
    //    static let CELL_WIDTH : CGFloat = UIScreen.main.bounds.width;
    //    static let CELL_HEIGHT : CGFloat = 0;
    
    var viewIdTagDict : [String: Int]! = [:];
    var cellInnerView: UIView!;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        print("cell init -->" + self.reuseIdentifier!);
        
        let template : UIView = identifierMitTemplate[self.reuseIdentifier!]!;
        
        self.cellInnerView = PetralUtil.duplicateView(view: template);
        PetralUtil.duplicateRestraints(sourceView: template, toView: self.cellInnerView);
        
        let copyViewSubs = PetralUtil.getSubViews(view: self.cellInnerView);
        for (index,subview) in PetralUtil.getSubViews(view: template).enumerated() {
            if subview.isKind(of: PetralFlexView.classForCoder()) {
                self.saveSubTemplates(templateView: (subview as! PetralFlexView), copiedView: copyViewSubs[index] as! PetralFlexView);
            }
        }
        
        self.contentView.addSubview(self.cellInnerView);
        
        self.cellInnerView.petralRestraint.reset();
        self.cellInnerView.petralRestraint.leftIn().rightIn().topIn().bottomIn();
    }
    
    func saveSubTemplates(templateView: PetralFlexView, copiedView: PetralFlexView) {
        copiedView.elementCount = templateView.elementCount;
        copiedView.direction = templateView.direction;
        copiedView.padding = templateView.padding;
        copiedView.itemSpaceX = templateView.itemSpaceX;
        copiedView.itemSpaceY = templateView.itemSpaceY;
        copiedView.templateView = templateView.templateView;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}

class PetralTableHeaderView: UIView {
    
}

class PetralTableFooterView: UIView {
    
}

class PetralTableSectionHeaderView: UIView {
    
}

class PetralTableSectionFooterView: UIView {
    
}

class PetralTableCellView: UIView {
    
}

