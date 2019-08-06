//
//  PetralConfig.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/8/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class PetralConfig: NSObject {
    
    public static let shared = PetralConfig();
    
    public var reloadUrl: String?;
    
    override init() {
        super.init();
    }

}
