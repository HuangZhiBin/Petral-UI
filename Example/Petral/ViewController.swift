//
//  ViewController.swift
//  Petral
//
//  Created by bin on 2019/6/9.
//  Copyright © 2019年 BinHuang. All rights reserved.
//

import UIKit
import Petral

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Petral
        
        let label = UILabel.init()
            .pt_frame(x: 100, y: 100, width: 200, height: 80)
            .pt_font(size: 18, bold: true)
            .pt_text("UILabel")
            .pt_textColor(UIColor.black)
            .pt_lines(1)
            .pt_align(.center)
            .pt_backgroundColor(UIColor.gray)
            .pt_borderColor(UIColor.red)
            .pt_borderWidth(2)
            .pt_borderRadius(12);
        print(label.hash);
        self.view.addSubview(label);
        
        let textField = UITextField.init()
            .pt_frame(x: 0, y: 100, width: 80, height: 50)
            .pt_font(size: 18, bold: true)
            .pt_text("UITextField")
            .pt_placeholder("this is hint")
            .pt_textColor(UIColor.black)
            .pt_align(.center)
            .pt_keyboardType(.numberPad)
            .pt_backgroundColor(UIColor.gray)
            .pt_borderColor(UIColor.red)
            .pt_borderWidth(2)
            .pt_borderRadius(12);
        self.view.addSubview(textField);
        textField.petralRestraint
            .pt_rightTo(label, distance: 40)
            .pt_topIn(self.view, distance: 10)
            .pt_bottomTo(label, distance: 20)
        
        //                .pt_width(30)
        //                .pt_height(50)
        
        let button = UIButton.init()
            .pt_frame(x: 0, y: 200, width: 120, height: 50)
            .pt_font(size: 18, bold: true)
            .pt_backgroundColor(UIColor.green, state: .normal)
            .pt_backgroundColor(UIColor.blue, state: .highlighted)
            .pt_title("UIButton", state: .normal)
            .pt_title("UIButton2", state: .highlighted)
            .pt_titleColor(UIColor.black, state: .normal)
            .pt_titleColor(UIColor.white, state: .highlighted)
            .pt_align(.center)
            .pt_borderColor(UIColor.red)
            .pt_borderWidth(2)
            .pt_borderRadius(12);
        self.view.addSubview(button);
        button.petralRestraint
            .pt_rightAs(label)
            .pt_topTo(label, distance: 20)
        //.pt_centerAs(label);
        
        let view = UIView.init()
            .pt_frame(x: 0, y: 360, width: 300, height: 300)
            .pt_backgroundColor(UIColor.lightGray)
            .pt_borderColor(UIColor.red)
            .pt_borderWidth(2)
            .pt_borderRadius(12);
        self.view.addSubview(view);
        view.petralRestraint
            .pt_leftIn(self.view, distance: 20)
            .pt_rightIn(self.view, distance: 20)
            //                .pt_topIn(self.view, distance: 20)
            .pt_bottomIn(self.view, distance: 20);
        
        let textView = UITextView.init()
            .pt_frame(x: 0, y: 0, width: 140, height: 50)
            .pt_backgroundColor(UIColor.lightGray)
            .pt_font(size: 18, bold: true)
            .pt_text("UITextView")
            .pt_textColor(UIColor.black)
            .pt_align(.center)
            .pt_borderColor(UIColor.red)
            .pt_borderWidth(2)
            .pt_borderRadius(12);
        view.addSubview(textView);
        textView.petralRestraint
            .pt_centerIn(view)
            .pt_width(200)
            .pt_height(100)
        
        let label2 = UILabel.init()
            .pt_frame(x: 20, y: 0, width: 120, height: 100)
            .pt_backgroundColor(UIColor.blue)
            .pt_text("his name");
        self.view.addSubview(label2);
        label2.petralRestraint
            .pt_leftIn(self.view, distance: 30)
            .pt_rightIn(self.view, distance: 30)
            .pt_height(40)
            .pt_topTo(button, distance: 20);
        
        
        label.petralRestraint
            .pt_leftIn(self.view, distance: 50)
            .pt_width(320)
            .pt_height(120);
        label.petralRestraint.pt_updateDependeds();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

