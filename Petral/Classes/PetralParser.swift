//
//  PetralParser.swift
//  Petral_Example
//
//  Created by huangzhibin on 2019/7/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class PetralRestraintParam: NSObject {
    var id : String?;
    var value: CGFloat! = 0;
    var value2: CGFloat! = 0;//第二个参数,例如label1,2的2
    var type: PetralReferenceType!;//to/same
    var percentOffset: CGFloat! = 0;//percent的偏移减少量,例如padding，在减少padding的基础上计算百分比
    
    init(id : String?, value: CGFloat , value2: CGFloat? = nil, type: PetralReferenceType) {
        self.id = id;
        self.value = value;
        self.type = type;
        if (value2 != nil) {
            self.value2 = value2!;
        }
    }
}

class PetralParser: NSObject {
    
    /**
     允许输入的格式:
     120
     40%(只支持width/height)
     tableview1
     textview1;20
     label1,100
     100,200
     label1,100,200
     */
    static func parseRestraint(_ attributeValue: String) -> PetralRestraintParam? {
        let DOT : String.Element = ",";
        let DOTT : String.Element = ";";
        if attributeValue.contains(DOT){
            let args = attributeValue.split(separator: DOT);
            if args.count == 2 {
                let arg1 : String = String(args[0]);
                if self.isFloat(string: arg1) {
                    let value : CGFloat  = CGFloat(Double(args[0])!);
                    let value2 : CGFloat  = CGFloat(Double(args[1])!);
                    return PetralRestraintParam.init(id: nil, value: value, value2: value2, type: .inside);
                }
                else {
                    let id : String = String(args[0]);
                    let value : CGFloat  = CGFloat(Double(args[1])!);
                    return PetralRestraintParam.init(id: id, value: value, type: .same);
                }
            }
            else if args.count == 3 {
                let id : String = String(args[0]);
                let value : CGFloat  = CGFloat(Double(args[1])!);
                let value2 : CGFloat  = CGFloat(Double(args[2])!);
                return PetralRestraintParam.init(id: id, value: value, value2: value2, type: .same);
            }
        }
        else if attributeValue.contains(DOTT){
            let args = attributeValue.split(separator: DOTT);
            if args.count == 2 {
                let id : String = String(args[0]);
                let value : CGFloat  = CGFloat(Double(args[1])!);
                return PetralRestraintParam.init(id: id, value: value, type: .to);
            }
        }
        else {
            if self.isFloat(string: attributeValue) {
                return PetralRestraintParam.init(id: nil, value: CGFloat(Double(attributeValue)!), type: .inside);
            }
            else if attributeValue.hasSuffix("%") && self.isFloat(string: attributeValue.replacingOccurrences(of: "%", with: "")) {
                return PetralRestraintParam.init(id: nil, value: CGFloat(Double(attributeValue.replacingOccurrences(of: "%", with: ""))!)/100.0, type: .percent);
            }
            else {
                return PetralRestraintParam.init(id: attributeValue, value: 0, type: .same);
            }
        }
        return nil;
    }
    
    /**
     允许输入的格式:
     left
     right
     center
     justified
     natural
     */
    static func parseAlign(_ attributeValue: String) -> NSTextAlignment {
        switch attributeValue {
        case "left":
            return .left;
        case "center":
            return .center;
        case "right":
            return .right;
        case "justified":
            return .justified;
        case "natural":
            return .natural;
        default:
            return .left;
        }
    }
    
    /**
     允许输入的格式:
     12
     12+
     */
    static func parseFont(_ attributeValue: String) -> [CGFloat] {
        if attributeValue.hasSuffix("+") {
            let fontSize = CGFloat(Double(attributeValue.replacingOccurrences(of: "+", with: ""))!);
            return [fontSize, 1];
        }
        else {
            let fontSize = CGFloat(Double(attributeValue)!);
            return [fontSize, 0];
        }
    }
    
    /**
     允许输入的格式:
     10,20,30,40
     10,20
     10
     */
    static func parseInset(_ attributeValue: String) -> UIEdgeInsets {
        if attributeValue.split(separator: ",").count == 4 {
            let top = CGFloat(Double(attributeValue.split(separator: ",")[0])!);
            let left = CGFloat(Double(attributeValue.split(separator: ",")[1])!);
            let bottom = CGFloat(Double(attributeValue.split(separator: ",")[2])!);
            let right = CGFloat(Double(attributeValue.split(separator: ",")[3])!);
            
            return UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right);
        }
        else if attributeValue.split(separator: ",").count == 2 {
            let topAndBottom = CGFloat(Double(attributeValue.split(separator: ",")[0])!);
            let leftAndRight = CGFloat(Double(attributeValue.split(separator: ",")[1])!);
            
            return UIEdgeInsets.init(top: topAndBottom, left: leftAndRight, bottom: topAndBottom, right: leftAndRight);
        }
        else if attributeValue.split(separator: ",").count == 1 {
            let all = CGFloat(Double(attributeValue)!);
            
            return UIEdgeInsets.init(top: all, left: all, bottom: all, right: all);
        }
        return UIEdgeInsets.zero;
    }
    
    /**
     允许输入的格式:
     10,20
     */
    static func parseSize(_ attributeValue: String) -> CGSize {
        let width = attributeValue.split(separator: ",")[0];
        let height = attributeValue.split(separator: ",")[1];
        return CGSize.init(width: CGFloat(Double(width)!), height: CGFloat(Double(height)!));
    }
    
    /**
     允许输入的格式:
     10,20
     */
    static func parsePoint(_ attributeValue: String) -> CGPoint {
        let x = attributeValue.split(separator: ",")[0];
        let y = attributeValue.split(separator: ",")[1];
        return CGPoint.init(x: CGFloat(Double(x)!), y: CGFloat(Double(y)!));
    }
    
    /**
     允许输入的格式:
     0.213154
     */
    static func parseFloat(_ attributeValue: String) -> CGFloat {
        return CGFloat(Double(attributeValue)!);
    }
    
    /**
     允许输入的格式:
     1234
     */
    static func parseInt(_ attributeValue: String) -> Int {
        return Int(attributeValue)!;
    }
    
    /**
     允许输入的格式:
     true
     false
     */
    static func parseBool(_ attributeValue: String) -> Bool {
        if attributeValue == "true" {
            return true;
        }
        else if attributeValue == "false" {
            return false;
        }
        return false;
    }
    
    /**
     允许输入的格式:
     0(CGRect.zero)
     100,200(width,height)
     10,20,100,200(x,y,width,height)
     */
    static func parseFrame(_ attributeValue: String) -> [CGFloat] {
        var frameAgrs: [CGFloat] = [];
        if attributeValue == "0" {
            frameAgrs = [0, 0, 0, 0];
        }
        else if attributeValue.split(separator: ",").count == 4 {
            let values = attributeValue.split(separator: ",");
            let x: CGFloat = CGFloat(Double(values[0])!);
            let y: CGFloat = CGFloat(Double(values[1])!);
            let width: CGFloat = CGFloat(Double(values[2])!);
            let height: CGFloat = CGFloat(Double(values[3])!);
            frameAgrs = [x, y, width, height];
        }
        else if attributeValue.split(separator: ",").count == 2 {
            let values = attributeValue.split(separator: ",");
            let width: CGFloat = CGFloat(Double(values[0])!);
            let height: CGFloat = CGFloat(Double(values[1])!);
            frameAgrs = [0, 0, width, height];
        }
        else{
            frameAgrs = [0, 0, 0, 0];
        }
        return frameAgrs;
    }
    
    /**
     允许输入的格式:
     #d7d7d7
     216721
     rgba(10,20,30,0.5)
     rgb(100,200,231)
     black,darkGray,lightGray,white,gray,red,green,blue,cyan,yellow,magenta,orange,purple,brown,clear
     */
    static func parseColor(_ attributeValue: String) -> UIColor {
        var color: UIColor?;
        
        let colors = ["black","darkGray","lightGray","white","gray","red","green","blue","cyan","yellow","magenta","orange","purple","brown","clear"];
        if colors.contains(attributeValue) {
            switch attributeValue {
            case "black":
                color = UIColor.black;
                break;
            case "darkGray":
                color = UIColor.darkGray;
                break;
            case "lightGray":
                color = UIColor.lightGray;
                break;
            case "white":
                color = UIColor.white;
                break;
            case "gray":
                color = UIColor.gray;
                break;
            case "red":
                color = UIColor.red;
                break;
            case "green":
                color = UIColor.green;
                break;
            case "blue":
                color = UIColor.blue;
                break;
            case "cyan":
                color = UIColor.cyan;
                break;
            case "yellow":
                color = UIColor.yellow;
                break;
            case "magenta":
                color = UIColor.magenta;
                break;
            case "orange":
                color = UIColor.orange;
                break;
            case "purple":
                color = UIColor.purple;
                break;
            case "brown":
                color = UIColor.brown;
                break;
            case "clear":
                color = UIColor.clear;
                break;
            default:
                break;
            }
        }
        else if attributeValue.hasPrefix("#") && attributeValue.count == 7 {
            let realColor : String = attributeValue.replacingOccurrences(of: "#", with: "");
            let red : String = String(realColor.prefix(2));
            let green : String  = String(realColor.prefix(4).suffix(2));
            let blue : String  = String(realColor.prefix(6).suffix(2));
            
            var r : UInt32 = 0;
            Scanner.init(string: red).scanHexInt32(&r);
            
            var g : UInt32 = 0;
            Scanner.init(string: green).scanHexInt32(&g);
            
            var b : UInt32 = 0;
            Scanner.init(string: blue).scanHexInt32(&b);
            
            color = UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1);
        }
        else if attributeValue.count == 6 {
            let realColor : String = attributeValue;
            let red : String = String(realColor.prefix(2));
            let green : String  = String(realColor.prefix(4).suffix(2));
            let blue : String  = String(realColor.prefix(6).suffix(2));
            
            var r : UInt32 = 0;
            Scanner.init(string: red).scanHexInt32(&r);
            
            var g : UInt32 = 0;
            Scanner.init(string: green).scanHexInt32(&g);
            
            var b : UInt32 = 0;
            Scanner.init(string: blue).scanHexInt32(&b);
            
            color = UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1);
        }
        else if attributeValue.hasPrefix("rgb(") && attributeValue.hasSuffix(")") && attributeValue.replacingOccurrences(of: "rgb(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ",").count == 3 {
            let values = attributeValue.replacingOccurrences(of: "rgb(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ",");
            let r: Int = Int(Double(values[0])!);
            let g: Int = Int(Double(values[1])!);
            let b: Int = Int(Double(values[2])!);
            
            color = UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1);
        }
        else if attributeValue.hasPrefix("rgba(") && attributeValue.hasSuffix(")") && attributeValue.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ",").count == 4 {
            let values = attributeValue.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ",");
            let r: Int = Int(Double(values[0])!);
            let g: Int = Int(Double(values[1])!);
            let b: Int = Int(Double(values[2])!);
            let alpha: CGFloat = CGFloat(Double(values[3])!);
            
            color = UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: alpha);
        }
        
        return color!;
    }
    
    /**
     允许输入的格式:
     row
     column
     wrap
     */
    static func parseDirection(_ attributeValue: String) -> PetralFlexDirectionType {
        if attributeValue == "row" {
            return .row;
        }
        else if attributeValue == "column" {
            return .column;
        }
        else if attributeValue == "wrap" {
            return .wrap;
        }
        return .row;
    }
    
    private static func isFloat(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string);
        var val: Float = 0;
        return scan.scanFloat(&val) && scan.isAtEnd;
    }

}
