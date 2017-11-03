//
//  UserInfoViewHeader.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/8/1.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class UserInfoViewHeader: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContentView(){
        
    }
    
    func fillterWith(dict:[String:Any])->CGFloat{
        return 270*APP_SCALE
    }
}
