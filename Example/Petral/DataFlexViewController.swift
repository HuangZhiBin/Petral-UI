//
//  DataFlexViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class DataFlexViewController: UIViewController {
    
    lazy var users: [UserModel]! = {
        return [
            UserModel.init(image: "head0", name: "熊熊"),
            UserModel.init(image: "head1", name: "天线德德B"),
            UserModel.init(image: "head2", name: "小红帽")
        ];
    }();
    
    var loader: PetralViewLoader!;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.loader = self.view.petralLoadXmlViews(xmlPath: "DataFlexViewController");
        let flexview = loader.petralViewById(id: "flexview") as! PetralFlexView;
        let scrollview = loader.petralViewById(id: "scrollview") as! UIScrollView;
        
        flexview.itemWidthAction = { (index: Int) in
            return ((CGFloat(index) * 0.1) + 1) * 200;
        };
        flexview.itemHeightAction = { (index: Int) in
            return ((CGFloat(index) * 0.05) + 1) * 80;
        };
        flexview.itemDisplayAction = {[weak self] (templateView: PetralFlexTemplateView, index : Int) in
            print(index);
            let cellImage : UIImageView = self?.loader.petralViewById(id: "cellImage", inView: templateView) as! UIImageView;
            cellImage.image = UIImage.init(named: (self?.users[index].image)!);
            
            let cellLabel : UILabel = self?.loader.petralViewById(id: "cellLabel", inView: templateView) as! UILabel;
            cellLabel.text = self?.users[index].name;
        };
        flexview.itemClickAction = { (template: PetralFlexTemplateView, index : Int) in
            print(index);
        }
        flexview.itemCountAction = { [weak self] in
            return (self?.users.count)!;
        }
        scrollview.contentSize = flexview.resize();
        // Do any additional setup after loading the view.
        
        let changeBtn : UIButton = self.loader.petralViewById(id: "changeBtn") as! UIButton;
        changeBtn.addTarget(self, action: #selector(self.changeData), for: .touchUpInside);
    }
    
    @objc func changeData() {
        self.users = [
            UserModel.init(image: "head0", name: "熊熊"),
            UserModel.init(image: "head1", name: "天线德德B"),
            UserModel.init(image: "head2", name: "小红帽"),
            UserModel.init(image: "head0", name: "熊熊2"),
            UserModel.init(image: "head1", name: "天线德德B2"),
            UserModel.init(image: "head2", name: "小红帽2"),
            UserModel.init(image: "head0", name: "熊熊3"),
            UserModel.init(image: "head1", name: "天线德德B3"),
            UserModel.init(image: "head2", name: "小红帽3")
        ];
        let flexview = self.loader.petralViewById(id: "flexview") as! PetralFlexView;
        let scrollview = loader.petralViewById(id: "scrollview") as! UIScrollView;
        flexview.reloadData();
        scrollview.contentSize = flexview.resize();
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
