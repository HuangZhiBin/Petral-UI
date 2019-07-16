//
//  PetralLoader.swift
//  Petral
//
//  Created by huangzhibin on 2019/7/11.
//

import UIKit

class PetralLoader: NSObject {
    
    let CONTAINER_TAG = "views";
    var allowParse = false;
    //当前元素名
    var superViewIdentifiers : [String]! = [];
    
    var currentElement = "";
    
    var viewIdentifierTagDict : [String: Int]! = [:];
    
    var xmlParser: XMLParser!;
    
    var xmlItems: [PetralXmlItem] = [];
    
    var randomInt : (() -> Int?)!;
    
    weak var targetView: UIView!;
    
    var xmlFileName: String!;
    
    var viewIdTagDict : [String: Int]! = [:];
    
    init(xmlFileName: String) {
        super.init();
        
        self.randomInt = self.createRandomMan(start: 10000, end: 99999);
        
        self.xmlFileName = xmlFileName;
        
        //获取xml文件路径
        let file = Bundle.main.path(forResource: self.xmlFileName, ofType: "xml")
        //初始化parser
        let parser = XMLParser(contentsOf: URL.init(fileURLWithPath: file!))!;
        self.xmlParser = parser;
        //设置delegate
        parser.delegate = self;
    }
    
    func injectViews(toView: UIView) {
        self.targetView = toView;
        if self.targetView.tag == 0 {
            self.targetView.tag = self.targetView.hash;
        }
        self.superViewIdentifiers.append(String(self.targetView.tag));
        
        //开始解析
        self.xmlParser.parse();
        self.finishParse();
        //self.targetView.petralRestraint.updateDependeds();
    }
    
    func findViewById(id: String) -> UIView? {
        if self.viewIdTagDict.keys.contains(id) {
            return self.targetView.viewWithTag(self.viewIdTagDict[id]!);
        }
        return nil;
    }
    
    func finishParse() {
        for item in self.xmlItems {
            var elementName: String = item.elementName;
            let attributeDict: [String: String] = item.attributeDict;
            let currentViewIdentifier: String = item.currentViewIdentifier;
            let superViewIdentifier: String = item.superViewIdentifier;
            
            var addedView: UIView?;
            var isSelfDefinedClass = false;
            
            let systemClassDict = [
                "view": "UIView",
                "button": "UIButton",
                "imageview": "UIImageView",
                "label": "UILabel",
                "scrollview": "UIScrollView",
                "tableview": "UITableView",
                "textfield": "UITextField",
                "textview": "UITextView",
                "collectionview": "UICollectionView",
                "datepicker": "UIDatePicker",
                "pickerview": "UIPickerView",
                "progressview": "UIProgressView",
                "searchbar": "UISearchBar",
                "segmentedcontrol": "UISegmentedControl",
                "slider": "UISlider",
                "stepper": "UIStepper",
                "switch": "UISwitch",
                "webview": "UIWebView"
            ];
            if systemClassDict.keys.contains(elementName) {
                elementName = systemClassDict[elementName]!;
            }
            let SPACE_NAME = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
            let vcClass: AnyClass? = NSClassFromString(SPACE_NAME + "." + elementName);
            if vcClass != nil {
                //自定义类
                isSelfDefinedClass = true;
                let typeClass : UIView.Type = vcClass as! UIView.Type;
                addedView = typeClass.init();
                //frame: CGRect.init(x: 0, y: 0, width: 200, height: 200)
            }
            else{
                //系统类
                let vcClass: AnyClass? = NSClassFromString(elementName);
                if vcClass == nil {
                    fatalError("Can not find class for " + elementName);
                }
                if elementName == NSStringFromClass(UICollectionView.classForCoder()){
                    
                    let typeClass : UICollectionView.Type = vcClass as! UICollectionView.Type;
                    addedView = typeClass.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init());
                    
                }
                else{
                    let typeClass : UIView.Type = vcClass as! UIView.Type;
                    addedView = typeClass.init();
                }
                
            }
            
            if addedView != nil {
                
                addedView!.tag = addedView!.hash;
                if attributeDict.keys.contains("id"){
                    self.viewIdTagDict[attributeDict["id"]!] = addedView?.tag;
                }
                self.viewIdentifierTagDict[currentViewIdentifier] = addedView!.tag;
                
                // 1.add attributes
                for attributeName in attributeDict.keys {
                    if PetralRestraint.isRestraintAttribute(attributeName: attributeName) {
                        continue;
                    }
                    let attributeValue : String = attributeDict[attributeName]!;
                    addedView!.petralize().setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
                }
                
                // 2.add view
                let superViewTag : Int? = self.viewIdentifierTagDict[superViewIdentifier];
                if superViewTag == nil {
                    self.targetView.addSubview(addedView!);
                }
                else{
                    self.targetView.viewWithTag(superViewTag!)?.addSubview(addedView!);
                }
                
                // 3.add restraints
                for attributeName in attributeDict.keys {
                    if PetralRestraint.isRestraintAttribute(attributeName: attributeName) == false {
                        continue;
                    }
                    let attributeValue : String = attributeDict[attributeName]!.trimmingCharacters(in: .whitespaces);
                    
                    let params : PetralRestraintParam? = PetralParser.parseRestraint(attributeValue);
                    if params != nil {
                        var toView: UIView?;
                        if params!.id != nil {
                            toView = self.targetView.viewWithTag(self.viewIdTagDict[params!.id!]!);
                        }
                        else{
                            toView = addedView?.superview;
                        }
                        addedView!.petralRestraint.setXmlRestraint(attributeName: attributeName, restraintParam: params!, toView: toView!);
                    }
                }
                
                if isSelfDefinedClass{
                    if addedView!.petralXmlResource != nil {
                        addedView!.petralRestraint.updateDependeds();
                    }
                }
            }
        }
    }
    
    //随机数生成器函数
    func createRandomMan(start: Int, end: Int) ->() ->Int? {
        //根据参数初始化可选值数组
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
        
        func randomMan() -> Int! {
            if !nums.isEmpty {
                //随机返回一个数，同时从数组里删除
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.remove(at: index)
            }else {
                //所有值都随机完则返回nil
                return nil
            }
        }
        
        return randomMan
    }

}

extension PetralLoader : XMLParserDelegate {
    
    // 遇到一个开始标签时调用
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if(CONTAINER_TAG == elementName){
            self.allowParse = true;
            return;
        }
        guard self.allowParse else {
            return;
        }
        print("=>" + elementName);
        
        print(attributeDict)
        currentElement = elementName;
        
        //
        let currentIdentifier : String = String(self.randomInt()!);
        print("currentIdentifier="+String(currentIdentifier));
        xmlItems.append(PetralXmlItem.init(elementName: elementName, attributeDict: attributeDict, currentViewIdentifier: currentIdentifier, superViewIdentifier: self.superViewIdentifiers.last!));
        self.superViewIdentifiers.append(currentIdentifier);
    }
    
    // 遇到字符串时调用
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        //接下来每遇到一个字符，将该字符追加到相应的 property 中
        print(data);
    }
    
    // 遇到结束标签时调用
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        //标签User结束时将该用户对象，存入数组容器。
        if(CONTAINER_TAG == elementName){
            self.allowParse = false;
            return;
        }
        guard self.allowParse else {
            return;
        }
        
        print("<=" + elementName);
//        print(self.currentSuperViewTags);
        
        self.superViewIdentifiers.removeLast();
        
    }
}

class PetralXmlItem: NSObject{
    
    var elementName: String!;
    var attributeDict: [String: String]! = [:];
    var currentViewIdentifier: String!;
    var superViewIdentifier: String!;
    
    init(elementName: String, attributeDict: [String: String], currentViewIdentifier: String, superViewIdentifier: String) {
        self.elementName = elementName;
        self.attributeDict = attributeDict;
        self.currentViewIdentifier = currentViewIdentifier;
        self.superViewIdentifier = superViewIdentifier;
    }
    
}
