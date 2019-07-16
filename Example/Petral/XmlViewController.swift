//
//  XmlViewController.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class XmlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.petralLoadXmlViews(xmlPath: "XmlViewController");
        
        let imageView = self.view.petralViewById(id: "image1") as! UIImageView;
        imageView.image = UIImage.init(named: "setting2");
        
        let userInfoView = self.view.petralViewById(id: "userInfoView") as! UserInfoView;
        userInfoView.petralRestraint.leftIn(offset: 50).rightIn(offset: 150);
        userInfoView.petralRestraint.updateDependeds();
        
        let button1 = self.view.petralViewById(id: "button1") as! UIButton;
        button1.addTarget(self, action: #selector(self.back), for: .touchUpInside);
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
