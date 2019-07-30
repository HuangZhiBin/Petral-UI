//
//  WrapFlexViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class WrapFlexViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "WrapFlexViewController");
        let flexview = loader.petralViewById(id: "flexview") as! PetralFlexView;
        let scrollview = loader.petralViewById(id: "scrollview") as! UIScrollView;
        flexview.itemDisplayAction = { (templateView: PetralFlexTemplateView, index : Int) in
            print(index);
            let cellImage : UIImageView = loader.petralViewById(id: "cellImage", inView: templateView) as! UIImageView;
            cellImage.image = UIImage.init(named: "head" + String(index % 3));
            
            let cellLabel : UILabel = loader.petralViewById(id: "cellLabel", inView: templateView) as! UILabel;
            cellLabel.text = "User " + String(index + 1);
        };
        flexview.itemClickAction = { (template: PetralFlexTemplateView, index : Int) in
            print(index);
        }
        scrollview.contentSize = flexview.resize();
        // Do any additional setup after loading the view.
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
