//
//  InjectXmlLayoutViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class InjectXmlLayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.petralLoadXmlViews(xmlPath: "InjectXmlLayoutViewController", properties: ["text":"这是外层的text","name":"天线德德B","image":"head1"]);

        // Do any additional setup after loading the view.
    }
    
    @objc func resetUI() {
        print("resetUI---->>>>>>>\(self.classForCoder)");
//        for subview in self.view.subviews {
//            subview.removeFromSuperview();
//        }
        
        self.view.petralLoadXmlViews(xmlPath: "InjectXmlLayoutViewController", properties: ["text":"这是外层的text","name":"天线德德B","image":"head1"]);
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
