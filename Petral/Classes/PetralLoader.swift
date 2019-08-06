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
    var tableViewTags : [Int] = [];
    
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
    }
    
    func injectViews(toView: UIView) {
        self.targetView = toView;
        if self.targetView.tag == 0 {
            self.targetView.tag = self.targetView.hash;
        }
        self.superViewIdentifiers.append(String(self.targetView.tag));
        
        var parser : XMLParser?;
        if PetralConfig.shared.reloadUrl == nil {
            //获取xml文件路径
            let file = Bundle.main.path(forResource: self.xmlFileName, ofType: "xml")
            //初始化parser
            parser = XMLParser(contentsOf: URL.init(fileURLWithPath: file!))!;
        }
        else{
            //初始化parser
            do{
                let data = try Data.init(contentsOf: URL.init(string: "http://" + PetralConfig.shared.reloadUrl! + "/" + self.targetView.petralXmlResource! + ".xml")!);
                parser = XMLParser(data: data);
            } catch{
                print("Fail to get local XML: \(error)");
            }
        }
        self.xmlParser = parser;
        //设置delegate
        parser!.delegate = self;
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
        var enumerateIndex = 0;
        while(enumerateIndex < self.xmlItems.count) {
            let item = self.xmlItems[enumerateIndex];
            
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
                
                "tableview": NSStringFromClass(PetralTableView.classForCoder()),
                "UITableView": NSStringFromClass(PetralTableView.classForCoder()),
                
                PETRAL_FLEX_VIEW_NAME: NSStringFromClass(PetralFlexView.classForCoder()),
                PETRAL_ATTRIBUTE_TEMPLATE: NSStringFromClass(PetralFlexTemplateView.classForCoder()),
                
                PETRAL_ELEMENT_HEADER: NSStringFromClass(PetralTableHeaderView.classForCoder()),
                PETRAL_ELEMENT_FOOTER: NSStringFromClass(PetralTableFooterView.classForCoder()),
                PETRAL_ELEMENT_CELL: NSStringFromClass(PetralTableCellView.classForCoder()),
                PETRAL_ELEMENT_SECTION_HEADER: NSStringFromClass(PetralTableSectionHeaderView.classForCoder()),
                PETRAL_ELEMENT_SECTION_FOOTER: NSStringFromClass(PetralTableSectionFooterView.classForCoder()),
            ];
            if shortNameClassDict.keys.contains(elementName) {
                elementName = shortNameClassDict[elementName]!;
            }
            
            let tableViewElements : [String] = [PETRAL_ELEMENT_HEADER, PETRAL_ELEMENT_FOOTER, PETRAL_ELEMENT_CELL, PETRAL_ELEMENT_SECTION_HEADER, PETRAL_ELEMENT_SECTION_FOOTER];
            let isTableViewElement = tableViewElements.contains(item.elementName);
            
            let createdView = self.creatView(className: elementName, attributeDict: attributeDict, currentViewIdentifier: currentViewIdentifier, superViewIdentifier: superViewIdentifier, needFillWidth: isTableViewElement);
            if isTableViewElement || elementName == self.getClassName(class:PetralFlexTemplateView.classForCoder()) {
                createdView?.petralRestraint.reset();
                createdView?.frame.origin = CGPoint.zero;
            }
            
            if createdView != nil && (createdView?.isKind(of: PetralTableView.classForCoder()))! {
                
                tableViewTags.append(createdView!.tag);
                
                /*
                var tableViewElements : [PetralXmlItem] = [];
                var tableViewElementsIdentifiers : [String] = [item.currentViewIdentifier];//tableview itself
                for elementIndex in (enumerateIndex+1)...(self.xmlItems.count-1) {
                    let elementItem = self.xmlItems[elementIndex];
                    let elementItemIdentifier: String = elementItem.currentViewIdentifier;
                    let elementItemSuperIdentifier: String = elementItem.superViewIdentifier;
                    
                    if tableViewElementsIdentifiers.contains(elementItemSuperIdentifier) {
                        tableViewElementsIdentifiers.append(elementItemIdentifier);
                        tableViewElements.append(elementItem);
                        continue;
                    }
                    else {
                        break;
                    }
                }
                enumerateIndex += tableViewElements.count;*/
            }
            
            if createdView != nil && createdView!.isKind(of: PetralFlexTemplateView.classForCoder()) {
                self.needDuplicateTemplateViewTags.append(createdView!.tag);
            }
            
            if enumerateIndex < self.xmlItems.count - 1 {
                enumerateIndex += 1;
                continue;
            }
            else {
                break;
            }
        }
        
        //flexview: reversed() 解决子flexview不复制的问题.reversed()
        for needDuplicateTemplateViewTag in self.needDuplicateTemplateViewTags.reversed() {
            let templateView: PetralFlexTemplateView = self.targetView.viewWithTag(needDuplicateTemplateViewTag) as! PetralFlexTemplateView;
            let flexView: PetralFlexView = templateView.superview as! PetralFlexView;
            templateView.removeFromSuperview();
            flexView.templateView = templateView;
        }
        
        //tableview
        for tableViewTag in self.tableViewTags.reversed() {
            let tableView: PetralTableView = self.targetView.viewWithTag(tableViewTag) as! PetralTableView;
            for subView in tableView.subviews {
                if subView.isKind(of: PetralTableHeaderView.classForCoder()) {
                    subView.removeFromSuperview();
                    tableView.tableHeaderView = subView;
                }
                else if subView.isKind(of: PetralTableFooterView.classForCoder()) {
                    subView.removeFromSuperview();
                    tableView.tableFooterView = subView;
                }
                else if subView.isKind(of: PetralTableCellView.classForCoder()) {
                    subView.removeFromSuperview();
                    tableView.cellView = subView;
                    tableView.cellHeight = subView.frame.size.height;
                }
                else if subView.isKind(of: PetralTableSectionHeaderView.classForCoder()) {
                    subView.removeFromSuperview();
                    tableView.sectionHeaderView = subView;
                    tableView.sectionHeightHeader = subView.frame.size.height;
                }
                else if subView.isKind(of: PetralTableSectionFooterView.classForCoder()) {
                    subView.removeFromSuperview();
                    tableView.sectionFooterView = subView;
                    tableView.sectionHeightFooter = subView.frame.size.height;
                }
            }
        }
    }
    
    func creatView(className : String, attributeDict: [String: String], currentViewIdentifier: String, superViewIdentifier: String, needFillWidth: Bool) -> UIView? {
        
        var addedView : UIView?;
        if NSClassFromString(className) == PetralFlexView.classForCoder() {
            addedView = PetralFlexView.init();
        }
        else if NSClassFromString(className) == PetralFlexTemplateView.classForCoder() {
            addedView = PetralFlexTemplateView.init();
        }
        else if className == NSStringFromClass(UICollectionView.classForCoder()){
            addedView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init());
        }
        else{
            let SPACE_NAME = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
            var vcClass: AnyClass? = NSClassFromString(SPACE_NAME + "." + className);
            if vcClass == nil {
                //系统类
                vcClass = NSClassFromString(className);
            }
            if vcClass == nil {
                fatalError("Cannot find class " + className);
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
        
        // 1.add attributes
        for attributeName in attributeDict.keys {
            if PetralRestraint.isRestraintAttribute(attributeName: attributeName) {
                continue;
            }
            let attributeValue : String = self.getRealAttributeValue(attributeValue: attributeDict[attributeName]!);
            
            addedView!.petralize().setXmlAttribute(attributeName: attributeName, attributeValue: attributeValue);
            
            if addedView!.isKind(of: PetralFlexView.classForCoder()) {
                (addedView as! PetralFlexView).setXmlParam(attributeName: attributeName, attributeValue: attributeValue);
            }
            else if addedView!.isKind(of: PetralTableView.classForCoder()) {
                (addedView as! PetralTableView).setXmlParam(attributeName: attributeName, attributeValue: attributeValue);
            }
        }
        
        // 2.add view
        let superViewTag : Int? = self.viewIdentifierTagDict[superViewIdentifier];
        if superViewTag == nil {
            self.targetView.addSubview(addedView!);
        }
        else{
            self.targetView.viewWithTag(superViewTag!)?.addSubview(addedView!);
            /*
            if self.targetView.viewWithTag(superViewTag!)!.isKind(of: PetralFlexView.classForCoder()) {
                let templateView = addedView! as! PetralFlexTemplateView;
                let flexView = (self.targetView.viewWithTag(superViewTag!) as! PetralFlexView);
                flexView.addItemView(view: templateView);
                self.needDuplicateTemplateViewTags.append(addedView!.tag);
            }
            else {
                self.targetView.viewWithTag(superViewTag!)?.addSubview(addedView!);
            }
 */
        }
        
        if needFillWidth {
            addedView?.frame.size.width = (addedView?.superview?.frame.size.width)!;
        }
        
//        guard !addedView!.isKind(of: PetralFlexTemplateView.classForCoder()) else {
//            return addedView;
//        }
        
        // 3.add restraints
        for attributeName in attributeDict.keys {
            if PetralRestraint.isRestraintAttribute(attributeName: attributeName) == false {
                continue;
            }
            var attributeValue : String = attributeDict[attributeName]!.trimmingCharacters(in: .whitespaces);
            attributeValue = self.getRealAttributeValue(attributeValue: attributeValue);
            
            let params : PetralRestraintParam? = PetralParser.parseRestraint(attributeValue);
            if params != nil {
                var toView: UIView?;
                if params!.id != nil {
                    if self.viewIdTagDict[params!.id!] == nil {
                        fatalError(className + ": Can not find view for view id = '" + params!.id! + "', have you defined it in the above code of xml file?");
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
        
        return addedView;
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
    
    func getClassName(class aClass: AnyClass) -> String {
        var classString = NSStringFromClass(aClass);
        if classString.contains("."){
            classString = NSString(string: classString).substring(from: classString.index(of: ".")!.encodedOffset + 1);
        }
        return classString;
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
