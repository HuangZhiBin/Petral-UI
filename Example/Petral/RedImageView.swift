//
//  RedImageView.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class RedImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.red;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
