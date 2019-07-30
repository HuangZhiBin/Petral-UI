//
//  UserProfileView.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class UserProfileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        //xml出现的自定义view需要指定petralXmlResource
        self.petralXmlResource = "UserProfileView";
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
