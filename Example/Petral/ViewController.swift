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
        
        let label = UILabel.init();
        label.petralize()
            .frame(x: 100, y: 100, width: 200, height: 80)
            .font(size: 18, bold: true)
            .text("UILabel")
            .textColor(UIColor.black)
            .lines(1)
            .align(.center)
            .backgroundColor(UIColor.gray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        print(label.hash);
        self.view.addSubview(label);
        
        let textField = UITextField.init();
        textField.petralize()
            .frame(x: 0, y: 100, width: 80, height: 50)
            .font(size: 18, bold: true)
            .text("UITextField")
            .placeholder("this is hint")
            .textColor(UIColor.black)
            .align(.center)
            .keyboardType(.numberPad)
            .backgroundColor(UIColor.gray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(textField);
        textField.petralRestraint
            .rightTo(label, distance: 40)
            .topIn(self.view, distance: 10)
            .bottomTo(label, distance: 20)
        
        //                .width(30)
        //                .height(50)
        
        let button = UIButton.init();
        button.petralize()
            .frame(x: 0, y: 200, width: 120, height: 50)
            .font(size: 18, bold: true)
            .backgroundColor(UIColor.green, state: .normal)
            .backgroundColor(UIColor.blue, state: .highlighted)
            .title("UIButton", state: .normal)
            .title("UIButton2", state: .highlighted)
            .titleColor(UIColor.black, state: .normal)
            .titleColor(UIColor.white, state: .highlighted)
            .align(.center)
            .masksToBounds(true)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(button);
        button.petralRestraint
            .xCenterAs(label, offset: 40)
//            .leftAs(label, offset: 20)
        //.centerAs(label);
        
        let view = UIView.init();
        view.petralize()
            .frame(x: 0, y: 360, width: 300, height: 300)
            .backgroundColor(UIColor.lightGray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(view);
        view.petralRestraint
            .leftIn(self.view, distance: 20)
            .rightIn(self.view, distance: 20)
            //                .topIn(self.view, distance: 20)
            .bottomIn(self.view, distance: 20);
        
        let textView = UITextView.init();
        textView.petralize()
            .frame(x: 0, y: 0, width: 140, height: 50)
            .backgroundColor(UIColor.lightGray)
            .font(size: 18, bold: true)
            .text("UITextView")
            .textColor(UIColor.black)
            .align(.center)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        view.addSubview(textView);
        textView.petralRestraint
            .centerIn(view)
            .width(200)
            .height(100)
        
        let label2 = UILabel.init();
        label2.petralize()
            .frame(x: 20, y: 0, width: 120, height: 100)
            .backgroundColor(UIColor.blue)
            .text("his name");
        self.view.addSubview(label2);
        label2.petralRestraint
            .leftIn(self.view, distance: 30)
            .rightIn(self.view, distance: 30)
            .height(40)
            .topTo(button, distance: 20);
        
        
        label.petralRestraint
            .leftIn(self.view, distance: 50)
            .width(320)
            .height(120);
        label.petralRestraint.updateDependeds();
        
        let label3 = UILabel.init();
        label3.petralize()
            .frame(x: 20, y: 0, width: 120, height: 100)
            .backgroundColor(UIColor.purple)
            .text("My name");
        self.view.addSubview(label3);
        label3.petralRestraint
            .locateIn(self.view, inset: UIEdgeInsets.init(top: 200, left: 100, bottom: 360, right: 140));
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

