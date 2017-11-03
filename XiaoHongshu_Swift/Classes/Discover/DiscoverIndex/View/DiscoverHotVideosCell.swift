//
//  DiscoverHotVideosCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/11.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class HotVideosItemView: UIView {
    
    //标题
    lazy var  titleLabel = {return UILabel()}()
    //描述图片
    lazy var  icoView = {return UIImageView()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icoView)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func  fillterWith(model:DiscoverHotVideosModel)  {
        
        //描述图片
        if  let images_list = model.images_list {
            
            if let imageInfo = images_list[0] as? [String:Any]{
                if let original = imageInfo["original"] as? String {
                    
                    icoView.sd_setImage(with: URL(string:original), placeholderImage: nil)
                    icoView.contentMode = .scaleAspectFill
                    icoView.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self)
                        make.width.equalTo(self)
                        make.top.equalTo(self)
                        make.height.equalTo(self.snp.height).multipliedBy(0.6)
                    })
                    icoView.layer.cornerRadius = 5*APP_SCALE
                    icoView.clipsToBounds = true
                    
                }
            }
            
            
        }
        
        //标题
        if let title = model.title {
            
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 13*APP_SCALE)
            titleLabel.textColor = UIColor.darkGray
            titleLabel.numberOfLines = 2;
            titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(icoView.snp.bottom).offset(10*APP_SCALE)
                make.left.equalTo(icoView.snp.left)
                make.right.equalTo(icoView.snp.right).offset(-5*APP_SCALE)
            })
            
        }
        
    }
    
    
}

class DiscoverHotVideosCell: UITableViewCell {
    
    //懒加载
    lazy var scrollView = {return UIScrollView()}()
    
    //View数组
    lazy var itemViewArr:[HotVideosItemView] = {return []}()
    
    static let identifier = "DiscoverHotVideosCell"
    class func cell(withTableView:UITableView) -> DiscoverHotVideosCell {
        var cell = withTableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = DiscoverHotVideosCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell!.selectionStyle = .none
        return cell as! DiscoverHotVideosCell;
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //初始化内容View
        setupUIContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    //MARK:设置内容View
    func setupUIContent() -> () {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    //MARK:数据源方法
    func fillter(modelArr:[DiscoverHotVideosModel]) {
        
        let margin = 15*APP_SCALE
        let itemW = (SCREEN_WIDTH - 3*margin)/2.5
        scrollView.contentSize = CGSize(width: CGFloat(modelArr.count)*(itemW+margin) + margin, height: 0)
        
        while itemViewArr.count < modelArr.count {
            
            let itemView = HotVideosItemView();
            scrollView.addSubview(itemView)
            itemViewArr.append(itemView)
            
        }
        
        for (index,model)  in modelArr.enumerated() {
            
            let itemView = itemViewArr[index];
            itemView.snp.remakeConstraints{ (make) in
                make.centerY.equalTo(scrollView)
                make.left.equalTo(scrollView).offset(margin + CGFloat(index)*(itemW + margin))
                make.height.equalTo(scrollView)
                make.width.equalTo(itemW)
            }
            
            itemView.backgroundColor = UIColor.white
            itemView.fillterWith(model: model);
            
            
        }
        
        
    }
}
