//
//  UserInfoReusableViewHeader.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/13.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class UserInfoReusableViewHeader: UICollectionReusableView {
    
    //重用标识
    static let identifier = "UserInfoReusableViewHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化内容View
    func setupUIContent(){
        self.backgroundColor = UIColor.purple
        self.frame.size.height = 50
    }
    
    
    //数据源方法
    func fillterWith(titleArr:[String]){
        
    }
    
}
