//
//  DiscoverGlobalBuyCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/11.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

//单个ItemView
class GlobalBuyItemView: UIView {
    
    //描述图片
    lazy var  icoView = {return UIImageView()}()
    
    //地标
    lazy var  titleLabel = {return UILabel()}()
    
    //内容条数
    lazy var  countLabel = {return UILabel()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icoView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillterWith(model:DiscoverGlobalBuyModel) {
        
        //描述图片
        if  let ico = model.image{
            
            icoView.sd_setImage(with: URL(string:ico), placeholderImage: nil)
            icoView.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.width.equalTo(self)
                make.top.equalTo(self)
                make.height.equalTo(self.snp.height).multipliedBy(0.6)
            })
            icoView.layer.cornerRadius = 5*APP_SCALE
            icoView.clipsToBounds = true
            
        }
        
        //地标
        if let title = model.name {
            
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            titleLabel.textColor = UIColor.darkGray
            titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(icoView.snp.bottom).offset(10*APP_SCALE)
                make.left.equalTo(icoView.snp.left)
                make.right.equalTo(icoView.snp.right).offset(-5*APP_SCALE)
            })
            
        }
        
        //内容条数
        if let count = model.discovery_total {
            
            countLabel.text = "\(count) 篇更新"
            countLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            countLabel.textColor = UIColor.gray
            countLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5*APP_SCALE)
                make.left.equalTo(icoView.snp.left)
                make.right.equalTo(icoView.snp.right).offset(-5*APP_SCALE)
            })
            
        }
    
    }
    
}


class DiscoverGlobalBuyCell: UITableViewCell {
    
    //懒加载
    lazy var scrollView = {return UIScrollView()}()
    
    //View数组
    lazy var itemViewArr:[GlobalBuyItemView] = {return []}()
    
    static let identifier = "DiscoverGlobalBuyCell"
    class func cell(withTableView:UITableView) -> DiscoverGlobalBuyCell {
        var cell = withTableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = DiscoverGlobalBuyCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell!.selectionStyle = .none
        return cell as! DiscoverGlobalBuyCell;
        
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
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK:数据源方法
    func fillter(modelArr:[DiscoverGlobalBuyModel]) {
        
        let margin = 15*APP_SCALE
        let itemW = (SCREEN_WIDTH - 3*margin)/2.5
        scrollView.contentSize = CGSize(width: CGFloat(modelArr.count)*(itemW+margin) + margin, height: 0)
        
        while itemViewArr.count < modelArr.count {
            let itemView = GlobalBuyItemView();
            scrollView.addSubview(itemView)
            itemViewArr.append(itemView)
        }
        
        print(modelArr)
        for (index,model)  in modelArr.enumerated() {
            
            let itemView = itemViewArr[index];
            itemView.snp.remakeConstraints{ (make) in
                make.centerY.equalTo(scrollView)
                make.left.equalTo(scrollView).offset(margin + CGFloat(index)*(itemW + margin))
                make.height.equalTo(scrollView)
                make.width.equalTo(itemW)
            }
            
            itemView.backgroundColor = UIColor.white
            itemView.fillterWith(model: model)
            
        }
        
        
    }
    
}
