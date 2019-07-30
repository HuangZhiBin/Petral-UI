//
//  XmlViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class XmlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let properties = [
            "showManyView": String(true),
            "time" : "10",
            "time2" : "3",
            "showRed" : String(true),
            "element": "风风雨雨我都不畏惧但求共醉"
        ];
        let loader = self.view.petralLoadXmlViews(xmlPath: "XmlViewController", properties: properties);
        
        let imageView = loader.petralViewById(id: "image1") as! UIImageView;
        imageView.image = UIImage.init(named: "setting2");
        
        let userInfoView = loader.petralViewById(id: "userInfoView") as! UserInfoView;
        userInfoView.petralRestraint.leftIn(offset: 50).rightIn(offset: 150);
        userInfoView.petralRestraint.updateDependeds();
        
        let button1 = loader.petralViewById(id: "button1") as! UIButton;
        button1.addTarget(self, action: #selector(self.back), for: .touchUpInside);
        
        /*
        let flexView1 = loader.petralViewById(id: "flexView1") as! PetralFlexView;
        flexView1.itemDisplayAction = { [weak self] (templateView: PetralFlexTemplateView, index : Int) in
            print(index);
            
            let flexView2 = loader.petralViewById(id: "flexView2", inView: templateView) as! PetralFlexView;
            
            flexView2.itemDisplayAction = { [weak self] (templateView2: PetralFlexTemplateView, index2 : Int) in
                let cellImage = loader.petralViewById(id: "cellImage", inView: templateView2) as? UIImageView;
                cellImage?.image = UIImage.init(named: "setting2");
                
                let cellLabel = loader.petralViewById(id: "cellLabel", inView: templateView2) as? UILabel;
                cellLabel?.text = "Item" + String(index2 + 1);
                
                let flexView3 = loader.petralViewById(id: "flexView3", inView: templateView2) as! PetralFlexView;
                
                flexView3.itemDisplayAction = { [weak self] (templateView3: PetralFlexTemplateView, index3 : Int) in
                    let subImage = loader.petralViewById(id: "subImage", inView: templateView3) as? UIImageView;
                    subImage?.image = UIImage.init(named: "setting2");
                    
                    let subLabel = loader.petralViewById(id: "subLabel", inView: templateView3) as? UILabel;
                    subLabel?.text = String(index + 1) + "-" + String(index2 + 1) + "-" + String(index3 + 1);
                }
            };
        }
        */
        let flexview = loader.petralViewById(id: "flexview") as! PetralFlexView;
        flexview.itemWidthAction = { (index: Int) in
            return CGFloat(index + 1) * 10;
        };
        flexview.itemHeightAction = { (index: Int) in
            return CGFloat(index + 1) * 12;
        };
        flexview.itemDisplayAction = { (templateView: PetralFlexTemplateView, index : Int) in
            print(index);
            let cellImage = loader.petralViewById(id: "cellIcon", inView: templateView) as? UIImageView;
            cellImage?.image = UIImage.init(named: "setting2");
            
            let cellLabel = loader.petralViewById(id: "cellInfo", inView: templateView) as? UILabel;
            cellLabel?.text = "Item" + String(index + 1);
        };
        flexview.itemClickAction = { (template: PetralFlexTemplateView, index : Int) in
            print(index);
        }
        
        //self.view.petralLoadXmlViews(xmlPath: "ListViewController");
        
        let testView = loader.petralViewById(id: "testView");
        testView?.frame.size.width = 300;
        testView?.frame.size.height = 100;
        testView?.petralRestraint.updateDependeds();
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil);
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
