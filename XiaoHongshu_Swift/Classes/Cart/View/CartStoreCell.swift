//
//  CartStoreCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/13.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class CartStoreCell: UICollectionViewCell {
    //标识
    static let identifier = "CartStoreCell"
    
    //背景图片
    lazy var iMGView = {return UIImageView()}()
    //折扣信息
    lazy var onSaleLabel = {return UILabel()}()
    //标题
    lazy var titleLabel = {return UILabel()}()
    //文字描述
    lazy var descLabel = {return UILabel()}()
    //底部描述
    lazy var BTView = {return UIView()}()
    //价格信息
    lazy var priceLabel = {return UILabel()}()
    //商家头像
    lazy var icoView = {return UIImageView()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置背景颜色
        backgroundColor = UIColor.white
        
        //设置内容View
        setupContentView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //设置子控件
    func setupContentView(){
        
        addSubview(iMGView)
        addSubview(onSaleLabel)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(BTView)
        
        BTView.addSubview(priceLabel)
        BTView.addSubview(icoView)
        
        self.clipsToBounds = true;
        
        
    }
    
    //数据源方法
    func fillterWith(model:CartStoreModel){
        
        //背景图片
        if let url = model.image {
            
            iMGView.sd_setImage(with: URL(string:url), placeholderImage: nil)
            iMGView.contentMode = .scaleAspectFill
            
            let height = (model.height as? CGFloat)!
            let width = (model.width as? CGFloat)!
            let scale = height/width
            let iViewH = self.frame.size.width*scale
            iMGView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(iViewH)
            })
        }
        
        if let model_type = model.model_type{
            if model_type.contains("banner"){
                onSaleLabel.isHidden = true
                titleLabel.isHidden = true
                descLabel.isHidden = true
                BTView.isHidden = true
                return;
            }else{
                onSaleLabel.isHidden = false
                titleLabel.isHidden = false
                descLabel.isHidden = false
                BTView.isHidden = false
            }
        }
        
        //折扣信息
        if let promotion_text = model.promotion_text as? String{
            onSaleLabel.text = promotion_text;
            onSaleLabel.textColor = UIColor.white
            onSaleLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
            onSaleLabel.backgroundColor = NAV_BAR_RED_COLOR
            onSaleLabel.textAlignment = .center
            onSaleLabel.sizeToFit()
            let size = onSaleLabel.frame.size
            onSaleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(iMGView.snp.left).offset(-size.height*0.5)
                make.bottom.equalTo(iMGView.snp.bottom).offset(-10*APP_SCALE)
                make.size.equalTo(CGSize(width:size.width + size.height,height:size.height))
            })
            onSaleLabel.layer.cornerRadius = size.height*0.5
            onSaleLabel.clipsToBounds = true;
        }
        
        //标题
        if let title = model.title{
            
            if title.characters.count != 0{
                
                titleLabel.text = title;
                titleLabel.font = UIFont.boldSystemFont(ofSize: 12*APP_SCALE)
                titleLabel.textColor = UIColor.darkGray
                titleLabel.numberOfLines = 1;
                titleLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(iMGView.snp.bottom).offset(5*APP_SCALE)
                    make.left.equalTo(self.snp.left).offset(5*APP_SCALE)
                    make.right.equalTo(self.snp.right).offset(-5*APP_SCALE)
                })
                
            }
        }
        //文字描述
        if let desc = model.desc as? String{
            if desc.characters.count != 0{
                descLabel.text = desc;
                descLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
                descLabel.textColor = UIColor.gray
                descLabel.numberOfLines = 2;
                descLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(5*APP_SCALE)
                    make.left.equalTo(self.snp.left).offset(5*APP_SCALE)
                    make.right.equalTo(self.snp.right).offset(-5*APP_SCALE)
                })
            }
        }
        
        //其他信息
        BTView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(descLabel.snp.bottom);
        }
        
        //价格
        if let price = model.price {
            if price.characters.count != 0{
                priceLabel.text = "¥ \(price)"
                priceLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
                priceLabel.textColor = NAV_BAR_RED_COLOR
                priceLabel.snp.remakeConstraints({ (make) in
                    make.centerY.equalTo(BTView.snp.centerY)
                    make.left.equalTo(BTView.snp.left).offset(5*APP_SCALE)
                })
            }
        }
        
        //标识
        if let vendor_icon = model.vendor_icon{
            icoView.sd_setImage(with: URL(string:vendor_icon), placeholderImage: nil)
            icoView.contentMode = .scaleAspectFit
            icoView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(BTView.snp.centerY)
                make.right.equalTo(BTView.snp.right).offset(-5*APP_SCALE);
                make.height.equalTo(BTView.snp.height).multipliedBy(0.5)
                make.width.equalTo(30*APP_SCALE)
            })
        }
        
    }
}
