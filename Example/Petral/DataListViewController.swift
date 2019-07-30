//
//  DataListViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class DataListViewController: UIViewController {
    
    lazy var groups: [GroupModel]! = {
        return [
            GroupModel.init(groupName: "可爱的", users:
                [
                    UserModel.init(image: "head0", name: "熊熊"),
                    UserModel.init(image: "head1", name: "天线德德B")
                ]
            ),
            GroupModel.init(groupName: "很美的", users:
                [
                    UserModel.init(image: "head2", name: "小红帽")
                ]
            )
        ];
    }();
    
    var loader: PetralViewLoader!;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.loader = self.view.petralLoadXmlViews(xmlPath: "DataListViewController");
        
        let tableView : PetralTableView = self.loader.petralViewById(id: "tableview1") as! PetralTableView;
        tableView.tableSectionCountAction = { [weak self]  in
            return self!.groups.count;
        };
        tableView.tableCellRowCountAction = {  [weak self] (section: Int) in
            return (self?.groups[section].users.count)!;
        };
        tableView.tableCellDisplayAction = {  [weak self] (cell: UITableViewCell, indexPath: IndexPath) in
            let cellImage : UIImageView = self?.loader.petralViewById(id: "cellImage", inView: cell) as! UIImageView;
            cellImage.image = UIImage.init(named: (self?.groups[indexPath.section].users[indexPath.row].image)!);
            
            let cellLabel : UILabel = self?.loader.petralViewById(id: "cellLabel", inView: cell) as! UILabel;
            cellLabel.text = self?.groups[indexPath.section].users[indexPath.row].name;
            
            cell.selectedBackgroundView = UIView.init(frame: cell.frame);
            cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
        };
        tableView.tableSectionHeaderDisplayAction = { [weak self] (headerView: UIView, section: Int) in
            let sectionHeaderLabel : UILabel = self?.loader.petralViewById(id: "sectionHeaderLabel", inView: headerView) as! UILabel;
            sectionHeaderLabel.text = self?.groups[section].groupName;
        };
        tableView.tableCellClickAction = { (indexPath: IndexPath) in
            print(indexPath.row);
        };
        
        let changeBtn : UIButton = loader.petralViewById(id: "changeBtn") as! UIButton;
        changeBtn.addTarget(self, action: #selector(self.changeData), for: .touchUpInside);
    }
    
    @objc func changeData() {
        self.groups = [
            GroupModel.init(groupName: "很酷的", users:
                [
                    UserModel.init(image: "head0", name: "熊熊"),
                ]
            ),
            GroupModel.init(groupName: "可爱的", users:
                [
                    UserModel.init(image: "head1", name: "天线德德B"),
                    UserModel.init(image: "head2", name: "小红帽")
                ]
            ),
            GroupModel.init(groupName: "很美的", users:
                [
                    UserModel.init(image: "head0", name: "熊熊"),
                    UserModel.init(image: "head1", name: "天线德德B"),
                    UserModel.init(image: "head2", name: "小红帽")
                ]
            )
        ];
        let tableView : PetralTableView = self.loader.petralViewById(id: "tableview1") as! PetralTableView;
        tableView.reloadData();
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

class GroupModel: NSObject{
    var groupName : String!;
    var users : [UserModel] = [];
    
    init(groupName : String, users : [UserModel]) {
        self.groupName = groupName;
        self.users = users;
    }
}

class UserModel: NSObject{
    var image : String!;
    var name : String!;
    
    init(image : String, name : String) {
        self.image = image;
        self.name = name;
    }
}
