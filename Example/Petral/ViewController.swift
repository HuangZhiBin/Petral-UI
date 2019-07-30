//
//  ViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class ViewController: UIViewController {
    
    let SECTIONS = ["基础功能", "XML布局", "UITableView", "FlexView"];
    
    let CELLS = [
        ["属性连续调用+自动布局"],
        ["XML布局的例子", "动态变量注入"],
        ["基本样式", "丰富样式", "动态数据刷新"],
        ["横向Flex", "纵向Flex", "横向平铺Flex", "多层嵌套Flex", "动态数据刷新"]
    ];
    
    let VCS = [
        [LayoutViewController.classForCoder()],
        [XmlLayoutViewController.classForCoder(), InjectXmlLayoutViewController.classForCoder()],
        [SimpleListViewController.classForCoder(), SectionListViewController.classForCoder(), DataListViewController.classForCoder()],
        [RowFlexViewController.classForCoder(), ColumnFlexViewController.classForCoder(), WrapFlexViewController.classForCoder(), EmbedFlexViewController.classForCoder(), DataFlexViewController.classForCoder()]
    ];

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Petral-UI";
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "ViewController");
        
        let tableView : PetralTableView = loader.petralViewById(id: "tableview1") as! PetralTableView;
        tableView.tableCellDisplayAction = { [weak self]  (cell: UITableViewCell, indexPath: IndexPath) in
            let cellLabel : UILabel = loader.petralViewById(id: "cellLabel", inView: cell) as! UILabel;
            cellLabel.text = String(indexPath.row + 1) + ". " + (self?.CELLS[indexPath.section][indexPath.row])!;
            cell.selectedBackgroundView = UIView.init(frame: cell.frame);
            cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
        };
        tableView.tableSectionHeaderDisplayAction = { [weak self]  (headerView: UIView, section: Int) in
            let sectionHeaderLabel : UILabel = loader.petralViewById(id: "sectionHeaderLabel", inView: headerView) as! UILabel;
            sectionHeaderLabel.text = self?.SECTIONS[section];
        };
        tableView.tableCellRowCountAction = {  [weak self] (section: Int) in
            return (self?.CELLS[section].count)!;
        };
        tableView.tableSectionCountAction = { [weak self]  in
            return self!.SECTIONS.count;
        };
        tableView.tableCellClickAction = { [weak self] (indexPath: IndexPath) in
            print(indexPath.row);
            let typeClass : UIViewController.Type = (self?.VCS[indexPath.section][indexPath.row])! as! UIViewController.Type;
            self?.show(typeClass.init(), sender: nil);
        };
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
