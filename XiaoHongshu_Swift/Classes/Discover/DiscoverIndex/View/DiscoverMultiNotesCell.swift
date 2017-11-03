//
//  DiscoverMultiNotesCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/11.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class DiscoverMultiNotesCell: UITableViewCell {
    
    //描述图片
    let icoView = {return UIImageView()}()
    //标题
    let titleLabel = {return UILabel()}()
    //内容
    let contentLabel = {return UILabel()}()
    //标签
    let tagsView = {return UIScrollView()}()
    //底部分割线
    lazy var separatorLine = {return UIView()}()
    
    static let identifier = "DiscoverMultiNotesCell"
    class func cell(withTableView:UITableView) -> DiscoverMultiNotesCell {
        var cell = withTableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = DiscoverMultiNotesCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell!.selectionStyle = .none
        return cell as! DiscoverMultiNotesCell;
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化内容View
        setupUICoontent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    //MARK:设置内容View
    func setupUICoontent() -> () {
        
        addSubview(icoView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(tagsView)
        addSubview(separatorLine)

        
    }
    
    //MARK:数据源方法
    func fillter(model:DiscoverMuitiNotesModel,isLast:Bool) {

        //描述图片
        if let imageInfo =  model.images_list?[0] as? [String:Any]{
        
            if let url = imageInfo["original"] as? String{
                icoView.sd_setImage(with: URL(string:url), placeholderImage: nil);
                icoView.contentMode = .scaleAspectFill
                icoView.snp.remakeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.left.equalTo(self.snp.left).offset(15*APP_SCALE)
                    make.height.equalTo(self.snp.height).multipliedBy(0.7)
                    make.width.equalTo(self.snp.height).multipliedBy(0.7*1.4)
                })
                icoView.layer.cornerRadius = 5*APP_SCALE;
                icoView.clipsToBounds = true;
            }
            
        }
        
        //标题
        if let title = model.title{
            titleLabel.text = title;
            titleLabel.font = UIFont.boldSystemFont(ofSize: 13*APP_SCALE)
            titleLabel.textColor = UIColor.darkGray
            titleLabel.numberOfLines = 2;
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(icoView.snp.top)
                make.left.equalTo(icoView.snp.right).offset(10*APP_SCALE)
                make.right.equalTo(self.snp.right).offset(-10*APP_SCALE);
            })
        }
        
        //内容
        if let desc = model.desc{
            contentLabel.text = desc;
            contentLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            contentLabel.textColor = UIColor.gray
            contentLabel.numberOfLines = 2;
            contentLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5*APP_SCALE)
                make.left.equalTo(icoView.snp.right).offset(10*APP_SCALE)
                make.right.equalTo(self.snp.right).offset(-10*APP_SCALE);
            })
        }
        
        //标签
        if let tags = model.tags{
        
            for tag in tags {
            }
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
