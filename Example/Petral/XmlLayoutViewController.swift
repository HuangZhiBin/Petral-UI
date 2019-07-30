//
//  XmlLayoutViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class XmlLayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.petralLoadXmlViews(xmlPath: "XmlLayoutViewController");

        // Do any additional setup after loading the view.
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
