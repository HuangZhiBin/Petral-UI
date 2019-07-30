//
//  SimpleListViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class SimpleListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "SimpleListViewController");
        
        let tableView : PetralTableView = loader.petralViewById(id: "tableview1") as! PetralTableView;
        
        tableView.tableCellDisplayAction = { (cell: UITableViewCell, indexPath: IndexPath) in
            let cellImage : UIImageView = loader.petralViewById(id: "cellImage", inView: cell) as! UIImageView;
            cellImage.image = UIImage.init(named: "head" + String(indexPath.row % 3));
            
            let cellLabel : UILabel = loader.petralViewById(id: "cellLabel", inView: cell) as! UILabel;
            cellLabel.text = "section " + String(indexPath.section);
            
            let cellSubLabel : UILabel = loader.petralViewById(id: "cellSubLabel", inView: cell) as! UILabel;
            cellSubLabel.text = "row " + String(indexPath.row);
            
            cell.selectedBackgroundView = UIView.init(frame: cell.frame);
            cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
        };
        tableView.tableCellClickAction = { (indexPath: IndexPath) in
            print(indexPath.row);
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
