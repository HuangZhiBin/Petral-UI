//
//  RowFlexViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Petral

class EmbedFlexViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let loader = self.view.petralLoadXmlViews(xmlPath: "EmbedFlexViewController");
        let flexview = loader.petralViewById(id: "flexview") as! PetralFlexView;
        let scrollview = loader.petralViewById(id: "scrollview") as! UIScrollView;
        flexview.itemDisplayAction = {(templateView: PetralFlexTemplateView, index : Int) in
            print(index);
            
            let rowLabel : UILabel = loader.petralViewById(id: "rowLabel", inView: templateView) as! UILabel;
            rowLabel.text = "row " + String(index + 1);
            
            let flexview2 : PetralFlexView = loader.petralViewById(id: "flexview2", inView: templateView) as! PetralFlexView;
            flexview2.itemDisplayAction = {(templateView2: PetralFlexTemplateView, index2 : Int) in
                print(index);
                let cellImage : UIImageView = loader.petralViewById(id: "cellImage", inView: templateView2) as! UIImageView;
                cellImage.image = UIImage.init(named: "head" + String(index % 3));
                
                let cellLabel : UILabel = loader.petralViewById(id: "cellLabel", inView: templateView2) as! UILabel;
                cellLabel.text = "item " + String(index + 1) + "-" + String(index2 + 1);
            };
            flexview2.itemClickAction = { (template2: PetralFlexTemplateView, index2 : Int) in
                print("item " + String(index + 1) + "-" + String(index2 + 1));
            }
        };
        flexview.itemClickAction = { (template: PetralFlexTemplateView, index : Int) in
            print("row" + String(index));
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
