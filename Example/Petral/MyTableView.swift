
//
//  MyTableView.swift
//  HdParent
//
//  Created by huangzhibin on 2019/06/11
//

import UIKit

protocol MyTableViewDelegate : NSObjectProtocol{
    func didSelectItem(item: MyTableModel);
}

class MyTableModel: NSObject{
    var image: String!;
    var name: String!;
    var desc: String!;
    
    init(image: String, name: String, desc: String) {
        self.image = image;
        self.name = name;
        self.desc = desc;
    }
}

class MyTableView: UITableView {
    
    let CELL_IDENTIFIER = "CELL_IDENTIFIER";
    
    var items : [MyTableModel] = []{
        didSet{
            self.reloadData();
        }
    };
    
    weak var tbDelegate : MyTableViewDelegate?;
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style);
        
        let tableView = self;
        tableView.backgroundColor = UIColor.green;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.transform = CGAffineTransform(rotationAngle: -.pi / 2);
        tableView.showsVerticalScrollIndicator = false;
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER);
        
        if(tableView.responds(to: #selector(setter: UITableView.separatorInset))) {
            tableView.separatorInset = UIEdgeInsets.zero;
        }
        if(tableView.responds(to: #selector(setter: UITableView.layoutMargins))) {
            tableView.layoutMargins = UIEdgeInsets.zero;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTableView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyTableViewCell.CELL_WIDTH;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! MyTableViewCell;
        
        let childModel = self.items[indexPath.row];
        cell.topImageView.image = UIImage.init(named: childModel.image);
        cell.nameLabel.text = childModel.name;
        cell.descLabel.text = childModel.desc;
        
        
        
        cell.selectedBackgroundView = UIView.init(frame: cell.frame);
        cell.selectedBackgroundView?.backgroundColor = UIColor.orange;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        
        let item = self.items[indexPath.row];
        if(self.tbDelegate != nil){
            self.tbDelegate?.didSelectItem(item: item);
        }
    }
}

class MyTableViewCell: UITableViewCell {
    
    static let CELL_WIDTH : CGFloat = 100;
    static let CELL_HEIGHT : CGFloat = 140;
    
    var topImageView: UIImageView!;
    var nameLabel: UILabel!;
    var descLabel: UILabel!;
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.initViews();
    }
    
    func initViews(){
        //self.contentView.backgroundColor = UIColor.purple;
        
        let containerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: MyTableViewCell.CELL_WIDTH, height: MyTableViewCell.CELL_HEIGHT));
        containerView.backgroundColor = UIColor.blue;
        let loader = containerView.petralLoadXmlViews(xmlPath: "MyTableViewCell");
        self.contentView.addSubview(containerView);
        
        containerView.transform = CGAffineTransform(rotationAngle: .pi / 2);
        containerView.petralRestraint.leftIn().topIn();
        
        self.topImageView = loader.petralViewById(id: "topImageView") as? UIImageView;
        self.nameLabel = loader.petralViewById(id: "nameLabel") as? UILabel;
        self.descLabel = loader.petralViewById(id: "descLabel") as? UILabel;
        
//        self.contentView.petralRestraint.rightIn().topIn();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
