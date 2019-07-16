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
        super.viewDidLoad();
        
        let label = UILabel.init();
        label.petralize()
            .frame(x: 100, y: 100, width: 200, height: 20)
            .font(size: 18, bold: true)
            .text("label")
            .textColor(UIColor.white)
            .lines(1)
            .align(.center)
            .backgroundColor(UIColor.gray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(label);
        label.petralRestraint
            .leftIn(offset: 50)
            .width(320)
            .height(120);
        
        let textField = UITextField.init();
        textField.petralize()
            .frame(x: 0, y: 100, width: 280, height: 50)
            .font(size: 18, bold: true)
            .text("textField")
            .placeholder("this is hint")
            .textColor(UIColor.white)
            .align(.center)
            .keyboardType(.numberPad)
            .backgroundColor(UIColor.gray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(textField);
        textField.petralRestraint
            .leftAs(label)
            .topTo(label, offset: 10)
        
        //                .width(30)
        //                .height(50)
        
        let button = UIButton.init();
        button.petralize()
            .frame(x: 0, y: 200, width: 120, height: 50)
            .font(size: 18, bold: true)
            .backgroundColor(UIColor.green, state: .normal)
            .backgroundColor(UIColor.blue, state: .highlighted)
            .title("XML实例", state: .normal)
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
            .xCenterAs(label, offset: 40);
        button.addTarget(self, action: #selector(self.xmlVC), for: .touchUpInside);
//            .leftAs(label, offset: 20)
        
        let button2 = UIButton.init();
        button2.petralize()
            .frame(x: 0, y: 280, width: 120, height: 50)
            .font(size: 18, bold: true)
            .backgroundColor(UIColor.green, state: .normal)
            .backgroundColor(UIColor.blue, state: .highlighted)
            .title("XML实例2", state: .normal)
            .title("UIButton2", state: .highlighted)
            .titleColor(UIColor.black, state: .normal)
            .titleColor(UIColor.white, state: .highlighted)
            .align(.center)
            .masksToBounds(true)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(button2);
        button2.petralRestraint
            .xCenterAs(label, offset: 40)
        //.centerAs(label);
        button2.addTarget(self, action: #selector(self.xmlVC2), for: .touchUpInside);
        
        let label2 = UILabel.init();
        label2.petralize()
            .frame(x: 20, y: 0, width: 120, height: 100)
            .backgroundColor(UIColor.blue)
            .text("label2");
        self.view.addSubview(label2);
        label2.petralRestraint
            .leftIn(offset: 30)
            .rightIn(offset: 30)
            .height(40)
            .topTo(textField, offset: 20);
        
        let label3 = UILabel.init();
        label3.petralize()
            .frame(x: 20, y: 0, width: 120, height: 100)
            .backgroundColor(UIColor.purple)
            .text("label3");
        self.view.addSubview(label3);
        label3.petralRestraint
            .widthAs(label2, offset: 2)
            .heightAs(label2, offset: 0)
            .topTo(label2, offset: 10)
            .leftAs(label2, offset: 0);
        //        label3.petralRestraint
        //            .locateIn(self.view, inset: UIEdgeInsets.init(top: 200, left: 100, bottom: 360, right: 140));
        
        let view = UIView.init();
        view.petralize()
            .frame(x: 0, y: 360, width: 300, height: 300)
            .backgroundColor(UIColor.lightGray)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        self.view.addSubview(view);
        view.petralRestraint
            .leftIn(offset: 20)
            .rightIn(offset: 20)
            //                .topIn(self.view, distance: 20)
            .bottomIn(offset: 20);
        
        let textView = UITextView.init();
        textView.petralize()
            .frame(x: 0, y: 0, width: 140, height: 50)
            .backgroundColor(UIColor.lightGray)
            .font(size: 18, bold: true)
            .text("textView")
            .textColor(UIColor.black)
            .align(.center)
            .borderColor(UIColor.red)
            .borderWidth(2)
            .borderRadius(12);
        view.addSubview(textView);
        textView.petralRestraint
            .centerIn()
            .width(200)
            .height(100)
        
        view.petralRestraint.reset();
        view.petralRestraint.topTo(label3, offset: 20).leftIn(offset: 50).rightIn(offset: 80).height(200);
        view.petralRestraint.updateDependeds();
    }
    
    @objc func xmlVC() {
        self.show(XmlViewController(), sender: nil);
    }
    
    @objc func xmlVC2() {
        self.show(MyTableViewController(), sender: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

