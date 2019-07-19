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
        self.view.petralLoadXmlViews(xmlPath: "XmlViewController", properties: properties);
        
        let imageView = self.view.petralViewById(id: "image1") as! UIImageView;
        imageView.image = UIImage.init(named: "setting2");
        
        let userInfoView = self.view.petralViewById(id: "userInfoView") as! UserInfoView;
        userInfoView.petralRestraint.leftIn(offset: 50).rightIn(offset: 150);
        userInfoView.petralRestraint.updateDependeds();
        
        let button1 = self.view.petralViewById(id: "button1") as! UIButton;
        button1.addTarget(self, action: #selector(self.back), for: .touchUpInside);
        
        let flexView1 = self.view.petralViewById(id: "flexView1") as! PetralFlexView;
        for (index,templateView) in flexView1.items.enumerated() {
            print(index);
            
            let flexView2 = self.view.petralViewById(id: "flexView2", template: templateView) as! PetralFlexView;
            for (index2,templateView2) in flexView2.items.enumerated() {
                let cellImage = self.view.petralViewById(id: "cellImage", template: templateView2) as? UIImageView;
                cellImage?.image = UIImage.init(named: "setting2");
                
                let cellLabel = self.view.petralViewById(id: "cellLabel", template: templateView2) as? UILabel;
                cellLabel?.text = "Item" + String(index2 + 1);
                
                let flexView3 = self.view.petralViewById(id: "flexView3", template: templateView2) as! PetralFlexView;
                for (index3,templateView3) in flexView3.items.enumerated() {
                    
                    let subImage = self.view.petralViewById(id: "subImage", template: templateView3) as? UIImageView;
                    subImage?.image = UIImage.init(named: "setting2");
                    
                    let subLabel = self.view.petralViewById(id: "subLabel", template: templateView3) as? UILabel;
                    subLabel?.text = String(index + 1) + "-" + String(index2 + 1) + "-" + String(index3 + 1);
                }
            }
        }
        
        let manyview = self.view.petralViewById(id: "manyview") as! PetralFlexView;
        for (index,templateView) in manyview.items.enumerated() {
            print(index);
            let cellImage = self.view.petralViewById(id: "cellIcon", template: templateView) as? UIImageView;
            cellImage?.image = UIImage.init(named: "setting2");
            
            let cellLabel = self.view.petralViewById(id: "cellInfo", template: templateView) as? UILabel;
            cellLabel?.text = "Item" + String(index + 1);
        }
        manyview.clickItemAction = { (template: PetralFlexTemplateView, index : Int) in
            print(index);
        }
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
