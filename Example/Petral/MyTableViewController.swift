//
//  MyTableViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class MyTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "MyTableViewController");

        // Do any additional setup after loading the view.
        let tableView : MyTableView = loader.petralViewById(id: "tableView") as! MyTableView;
//        tableView.petralRestraint.leftIn().rightIn().topIn().height(200);
        
        tableView.items = [
            MyTableModel.init(image: "setting", name: "name1", desc: "desc1"),
            MyTableModel.init(image: "setting2", name: "name2", desc: "desc2"),
            MyTableModel.init(image: "setting", name: "name3", desc: "desc3"),
            MyTableModel.init(image: "setting2", name: "name4", desc: "desc4"),
            MyTableModel.init(image: "setting2", name: "name5", desc: "desc5"),
            MyTableModel.init(image: "setting", name: "name6", desc: "desc6")
        ];
        
        let button = loader.petralViewById(id: "button") as! UIButton;
        button.addTarget(self, action: #selector(self.back), for: .touchUpInside);
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil);
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
