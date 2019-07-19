//
//  PetralLoader.swift
//  Petral
//
//  Created by huangzhibin on 2019/7/11.
//

import UIKit

let PETRAL_ATTRIBUTE_SHOW = "p-show";

let PETRAL_ATTRIBUTE_ID = "id";
let PETRAL_ATTRIBUTE_DATA = "data";

class PetralLoader: NSObject {
    
    let CONTAINER_TAG = "views";
    var isParsing = false;
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
    
    var skipParseCursor = 0;//skipParseCursor==0表示继续parse，大于0表示需要跳过parse
    
    var needDuplicateTemplateViewTags : [Int] = [];
    
    var xmlProperties : [String: String] = [:];
    
    init(xmlFileName: String, properties: [String: String]? = nil) {
        super.init();
        
        self.randomInt = self.createRandomMan(start: 10000, end: 99999);
        
        self.xmlFileName = xmlFileName;
        
        if properties != nil {
            for key in properties!.keys {
                self.xmlProperties["{" + key + "}"] = properties![key]!;
            }
        }
        
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
    
    func findViewById(id: String, template: UIView) -> UIView? {
        if self.viewIdTagDict.keys.contains(id) {
            let tag = self.viewIdTagDict[id]!;
            return template.viewWithTag(tag);
        }
        return nil;
    }
    
    func finishParse() {
        for item in self.xmlItems {
            var elementName: String = item.elementName;
            let attributeDict: [String: String] = item.attributeDict;
            let currentViewIdentifier: String = item.currentViewIdentifier;
            let superViewIdentifier: String = item.superViewIdentifier;
            
            let shortNameClassDict = [
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
                "webview": "UIWebView",
                
                "manyview": "PetralFlexView",
                PETRAL_ATTRIBUTE_TEMPLATE: NSStringFromClass(PetralFlexTemplateView.classForCoder())
            ];
            if shortNameClassDict.keys.contains(elementName) {
                elementName = shortNameClassDict[elementName]!;
            }
            
            self.creatView(elementName: elementName, attributeDict: attributeDict, currentViewIdentifier: currentViewIdentifier, superViewIdentifier: superViewIdentifier);
        }
        
        //reversed() 解决子manyview不复制的问题.reversed()
        for needDuplicateTemplateViewTag in self.needDuplicateTemplateViewTags.reversed() {
            let templateView: PetralFlexTemplateView = self.targetView.viewWithTag(needDuplicateTemplateViewTag) as! PetralFlexTemplateView;
            let flexView: PetralFlexView = templateView.flexView;
            
            if flexView.elementCount >= 2 {
                for _ in 0 ... flexView.elementCount - 2 {
                    let copyView : PetralFlexTemplateView = self.duplicateView(view: templateView) as! PetralFlexTemplateView;
                    flexView.addItemView(view: copyView);
                    print("sdfsddf")
                }
            }
        }
    }
    
    func creatView(elementName : String, attributeDict: [String: String], currentViewIdentifier: String, superViewIdentifier: String) {
        
        
        var addedView : UIView?;
        if elementName == "PetralFlexView"{
            addedView = PetralFlexView.init();
        }
        else if elementName == "PetralFlexTemplateView"{
            addedView = PetralFlexTemplateView.init();
        }
        else if elementName == NSStringFromClass(UICollectionView.classForCoder()){
            addedView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init());
        }
        else{
            let SPACE_NAME = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
            var vcClass: AnyClass? = NSClassFromString(SPACE_NAME + "." + elementName);
            if vcClass == nil {
                //系统类
                vcClass = NSClassFromString(elementName);
            }
            if vcClass == nil {
                fatalError("Cannot find class " + elementName);
            }
            let typeClass : UIView.Type = vcClass as! UIView.Type;
            addedView = typeClass.init();
        }
        
        addedView!.tag = addedView!.hash;
        if attributeDict.keys.contains(PETRAL_ATTRIBUTE_ID){
            self.viewIdTagDict[attributeDict[PETRAL_ATTRIBUTE_ID]!] = addedView?.tag;
            addedView!.petralXmlViewId = attributeDict[PETRAL_ATTRIBUTE_ID]!;
        }
        self.viewIdentifierTagDict[currentViewIdentifier] = addedView!.tag;
        
        // 1.add view
        let superViewTag : Int? = self.viewIdentifierTagDict[superViewIdentifier];
        if superViewTag == nil {
            self.targetView.addSubview(addedView!);
        }
        else{
            if self.targetView.viewWithTag(superViewTag!)!.isKind(of: PetralFlexView.classForCoder()) {
                let templateView = addedView! as! PetralFlexTemplateView;
                let flexView = (self.targetView.viewWithTag(superViewTag!) as! PetralFlexView);
                flexView.addItemView(view: templateView);
                self.needDuplicateTemplateViewTags.append(addedView!.tag);
            }
            else {
                self.targetView.viewWithTag(superViewTag!)?.addSubview(addedView!);
            }
        }
        
        guard !addedView!.isKind(of: PetralFlexTemplateView.classForCoder()) else {
            return;
        }
        
        // 2.add attributes
        for attributeName in attributeDict.keys {
            if PetralRestraint.isRestraintAttribute(attributeName: attributeName) {
                continue;
            }
            let attributeValue : String = self.getRealAttributeValue(attributeValue: attributeDict[attributeName]!);
            
            addedView!.petralize().setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
            
            if addedView!.isKind(of: PetralFlexView.classForCoder()) {
                (addedView as! PetralFlexView).setXmlParam(attributeName: attributeName, attributeValue: attributeValue);
            }
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
                    if self.viewIdTagDict[params!.id!] == nil {
                        fatalError(elementName + ": Can not find view for view id = '" + params!.id! + "', have you defined it in the above code of xml file?");
                    }
                    toView = self.targetView.viewWithTag(self.viewIdTagDict[params!.id!]!);
                }
                else{
                    toView = addedView?.superview;
                }
                addedView!.petralRestraint.setXmlRestraint(attributeName: attributeName, restraintParam: params!, toView: toView!);
            }
        }
        
        if addedView?.petralXmlResource != nil {
            addedView!.petralLoadXmlViews(xmlPath: addedView!.petralXmlResource!, properties: self.getDataFromAttribute(dataAttributeValue: attributeDict[PETRAL_ATTRIBUTE_DATA]));
        }
    }
    
    func getDataFromAttribute(dataAttributeValue: String?) -> [String: String]? {
        if dataAttributeValue == nil || dataAttributeValue == "" {
            return nil;
        }
        let propValue = self.getRealAttributeValue(attributeValue: dataAttributeValue!);
        let jsonData = propValue.data(using: .utf8);
        var data: [String: String]?;
        do {
            try data = JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as? [String : String];
        }
        catch{
            return nil;
        }
        return data;
    }
    
    func getRealAttributeValue(attributeValue: String) -> String {
        var value = attributeValue;
        for key in self.xmlProperties.keys {
            value = value.replacingOccurrences(of: key, with: self.xmlProperties[key]!);
        }
        return value;
    }
    
    func duplicateView(view: UIView) -> UIView {
        let data = NSKeyedArchiver.archivedData(withRootObject: view);
        let duplicateView = NSKeyedUnarchiver.unarchiveObject(with: data);
        return duplicateView as! UIView;
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
            self.isParsing = true;
            return;
        }
        guard self.isParsing else {
            return;
        }
        print("=>" + elementName);
        
        print(attributeDict)
        currentElement = elementName;
        
        //
        
        
        //之前已经遇到no-show
        if (self.skipParseCursor > 0) {
            self.skipParseCursor += 1;
        }
        //首次已经遇到no-show
        else if attributeDict.keys.contains(PETRAL_ATTRIBUTE_SHOW) {
            let attributeValue = self.getRealAttributeValue(attributeValue: attributeDict[PETRAL_ATTRIBUTE_SHOW]!);
            if PetralParser.parseBool(attributeValue) == false {
                self.skipParseCursor = 1;
            }
        }
            
        if self.skipParseCursor == 0 {
            let currentIdentifier : String = String(self.randomInt()!);
            print("currentIdentifier="+String(currentIdentifier));
//            if elementName == "manyview" {
//                let duplicatedTimes :Int = Int(attributeDict[PETRAL_ATTRIBUTE_TIMES]!)!;
//                for index in 0...duplicatedTimes-1 {
//
//                }
//            }
            xmlItems.append(PetralXmlItem.init(elementName: elementName, attributeDict: attributeDict, currentViewIdentifier: currentIdentifier, superViewIdentifier: self.superViewIdentifiers.last!));
            self.superViewIdentifiers.append(currentIdentifier);
        }
    }
    
    // 遇到字符串时调用
    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        //接下来每遇到一个字符，将该字符追加到相应的 property 中
        //print(data);
    }
    
    // 遇到结束标签时调用
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        //标签User结束时将该用户对象，存入数组容器。
        if(CONTAINER_TAG == elementName){
            self.isParsing = false;
            return;
        }
        guard self.isParsing else {
            return;
        }
        
        print("<=" + elementName);
//        print(self.currentSuperViewTags);
        
        if (self.skipParseCursor > 0) {
            self.skipParseCursor -= 1;
        }
        else {
            self.superViewIdentifiers.removeLast();
        }
        
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
