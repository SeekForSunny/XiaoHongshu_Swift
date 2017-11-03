//
//  NoteInfoCell.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/10.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import SDWebImage


class NoteInfoCell: UICollectionViewCell {
    
    //identifier
    static let identifer = "NoteInfoCell"
    
    //回调函数
    var handleblock:(()->())?
    
    //描述图片
    lazy var iMGView = {return UIImageView()}()
    //标题
    lazy var titleLabel = {return UILabel()}()
    //描述
    lazy var descLabel = { return UILabel()}()
    //用户信息及点赞数
    lazy var BTView = {return UIView()}()
    //用户头像
    lazy var icoView = {return UIImageView()}()
    //用户昵称
    lazy var nameLabel = {return UILabel()}()
    //点赞按钮
    lazy var likeBtn = {return UIButton()}()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //布局内部View
        setupUIContent()
    }
    
    func setupUIContent() {
        
        backgroundColor = UIColor.white
        
        addSubview(iMGView);
        addSubview(titleLabel);
        addSubview(descLabel);
        addSubview(BTView);
        
        BTView.addSubview(icoView)
        BTView.addSubview(nameLabel)
        BTView.addSubview(likeBtn)
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
    }
    
    //MARK:数据源方法
    func fillterItem(model:HomeIndexModel,handleblock:@escaping ()->()) {
        self.handleblock = handleblock
        
        //图片
        var scale:CGFloat = 0
        var urlStr = "";
        if let images_list  = model.images_list {
            
            if let info = images_list[0] as? [String:Any] {
                
                let imageH = (info["height"] as? CGFloat) ?? 0
                let imageW = (info["width"] as? CGFloat) ?? 0
                scale = imageH/imageW;
                urlStr = info["url"] as! String;
                
                iMGView.contentMode = UIViewContentMode.scaleAspectFit
                iMGView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.snp.top)
                    make.left.equalTo(self.snp.left)
                    make.width.equalTo(self.snp.width)
                    make.height.equalTo(self.snp.width).multipliedBy(scale)
                }
                iMGView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
            }
            
        }
        
        
        //标题
        if let title = model.title{
            
            titleLabel.text = title;
            titleLabel.numberOfLines=2
            titleLabel.font = UIFont.boldSystemFont(ofSize: 12*APP_SCALE)
            titleLabel.textColor = UIColor.black
            titleLabel.snp.remakeConstraints{ (make) in
                make.top.equalTo(iMGView.snp.bottom).offset(5*APP_SCALE)
                make.left.equalTo(self.snp.left).offset(5*APP_SCALE);
                make.right.equalTo(self.snp.right).offset(-5*APP_SCALE);
            }
            
        }
        
        //内容
        if let desc = model.desc {
            
            descLabel.text = desc;
            descLabel.numberOfLines=2
            descLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
            descLabel.textColor = UIColor.gray
            descLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5*APP_SCALE)
                make.left.equalTo(self.snp.left).offset(5*APP_SCALE);
                make.right.equalTo(self.snp.right).offset(-5*APP_SCALE);
            }
            
        }
        
        
        //用户信息
        BTView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(40*APP_SCALE)
        }
        
        //头像
        if let ico = model.user?["images"] as? String{
            
            icoView.sd_setImage(with: URL(string:ico), placeholderImage: nil)
            let ICOWH = 20*APP_SCALE
            icoView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(BTView.snp.centerY)
                make.left.equalTo(BTView.snp.left).offset(5*APP_SCALE)
                make.width.height.equalTo(ICOWH)
            }
            icoView.layer.cornerRadius = ICOWH*0.5
            icoView.clipsToBounds = true
            icoView.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(showUserInfo))
            icoView.addGestureRecognizer(tapGes)
        }
        
        //昵称
        if let userName = model.user?["nickname"] as? String {
            
            nameLabel.text = userName
            nameLabel.font = UIFont.systemFont(ofSize: 10*APP_SCALE)
            nameLabel.textColor = UIColor.darkText
            nameLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(icoView.snp.centerY)
                make.left.equalTo(icoView.snp.right).offset(5*APP_SCALE)
                make.right.equalTo(self.snp.right).offset(-50*APP_SCALE)
            }
            
        }
        
        //点赞图标
        if let likes = model.likes {
            
            likeBtn.setTitle(" "+"\(likes)", for: UIControlState.normal)
            likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            likeBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            likeBtn.setImage(UIImage(named:"xyvg_home_like_16x16_"), for: UIControlState.normal)
            likeBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(BTView.snp.right)
                make.centerY.equalTo(BTView.snp.centerY)
                make.height.equalTo(BTView.snp.height)
                make.width.equalTo(50*APP_SCALE)
            }
        }
        
    }
    
}

extension NoteInfoCell{
    
    //MARK: 展示用户详情
    func showUserInfo(){
        if self.handleblock != nil  {
            NSLog("")
            self.handleblock!()
        }
    }
}
