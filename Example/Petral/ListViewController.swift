//
//  ListViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "ListViewController");
        
        let tableView : PetralTableView = loader.petralViewById(id: "tableview1") as! PetralTableView;
        
        let headerLabel : UILabel = loader.petralViewById(id: "headerLabel", inView: tableView.tableHeaderView!) as! UILabel;
        headerLabel.text = "Sorry";
        
        let footerLabel : UILabel = loader.petralViewById(id: "footerLabel", inView: tableView.tableFooterView!) as! UILabel;
        footerLabel.text = "Babe";
        
        tableView.tableCellDisplayAction = {  (cell: UITableViewCell, indexPath: IndexPath) in
            let cellLabel : UILabel = loader.petralViewById(id: "cellLabel", inView: cell) as! UILabel;
            let cellSubLabel : UILabel = loader.petralViewById(id: "cellSubLabel", inView: cell) as! UILabel;
            cellLabel.text = "section " + String(indexPath.section);
            cellSubLabel.text = "row " + String(indexPath.row);
            
            cell.selectedBackgroundView = UIView.init(frame: cell.frame);
            cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
        };
        tableView.tableSectionHeaderDisplayAction = { (headerView: UIView, section: Int) in
            let sectionHeaderLabel : UILabel = loader.petralViewById(id: "sectionHeaderLabel", inView: headerView) as! UILabel;
            sectionHeaderLabel.text = "section header " + String(section);
        };
        tableView.tableSectionFooterDisplayAction = { (footerView: UIView, section: Int) in
            let sectionFooterLabel : UILabel = loader.petralViewById(id: "sectionFooterLabel", inView: footerView) as! UILabel;
            sectionFooterLabel.text = "section footer " + String(section);
        };
        tableView.tableCellClickAction = { (indexPath: IndexPath) in
            print(indexPath.row);
        };
//        tableView.cellRowCountAction = { (section: Int) in
//            if section == 0 {
//                return 2;
//            }
//            return 3;
//        };
//        tableView.sectionCountAction = {
//            return 2;
//        };
        tableView.tableSectionHeightForHeaderAction = { (section: Int) in
            return 60;
        }
        tableView.tableSectionHeightForFooterAction = { (section: Int) in
            return 40;
        }
        tableView.tableCellRowHeightAction = { (indexPath: IndexPath) in
            if indexPath.section == 0 {
                return 80;
            }
            return 120;
        };
        
    }
    
    deinit {
        print("deinit");
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
