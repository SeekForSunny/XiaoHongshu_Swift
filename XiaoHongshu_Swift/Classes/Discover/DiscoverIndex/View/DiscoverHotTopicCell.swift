//
//  DiscoverHotTopicCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/11.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class DiscoverHotTopicCell: UITableViewCell {

    //描述图片
    lazy var icoView = {return UIImageView()}()
    //话题名称
    lazy var titleLabel = {return UILabel()}()
    //参与人数
    lazy var countLabel = {return UILabel()}()
    //底部分割线
    lazy var separatorLine = {return UIView()}()

    
    static let identifier = "DiscoverHotTopicCell"
    class func cell(withTableView:UITableView) -> DiscoverHotTopicCell {
        var cell = withTableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = DiscoverHotTopicCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }
        cell!.selectionStyle = .none
        return cell as! DiscoverHotTopicCell;
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化内容View
        setupUICoontent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK:设置内容View
    func setupUICoontent() -> () {
        
        addSubview(icoView)
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(separatorLine)
        
    }
    
    //MARK:数据源方法
    func fillter(model:DiscoverHotTopicModel,isLast:Bool) {
        //描述图片
        if let ico = model.image {
            icoView.sd_setImage(with: URL(string:ico), placeholderImage: nil)
            icoView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(self.snp.left).offset(15*APP_SCALE)
                make.width.height.equalTo(60*APP_SCALE)
            })
            icoView.layer.cornerRadius = 5*APP_SCALE
            icoView.clipsToBounds = true
        }
        
        //话题名称
        if let name = model.name {
    
            titleLabel.text = name
            titleLabel.font = UIFont.boldSystemFont(ofSize: 13*APP_SCALE)
            titleLabel.textColor = UIColor.darkGray
            titleLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.snp.centerY).offset(-4*APP_SCALE)
                make.left.equalTo(icoView.snp.right).offset(12*APP_SCALE)
            })
            
        }
        
        //参与人数
        if let count = model.total_follows {
            
            countLabel.text = "\(count) 人参与"
            countLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            countLabel.textColor = UIColor.darkGray
            countLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.centerY).offset(4*APP_SCALE)
                make.left.equalTo(icoView.snp.right).offset(12*APP_SCALE)
            })
            
        }
        
        //底部分割线
        separatorLine.backgroundColor = isLast ? UIColor.clear : UIColor.lightGray
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15*APP_SCALE)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
    }
    
}
