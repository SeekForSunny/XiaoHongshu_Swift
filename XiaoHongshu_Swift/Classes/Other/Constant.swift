//
//  Constant.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import Foundation

//适配比例
let APP_SCALE = UIScreen.main.bounds.size.width/375;

//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
//屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

//背景颜色
let BACK_GROUND_COLOR = UIColor.init(red: 247/255.0, green: 250/255.0, blue: 252/255.0, alpha: 1.0)
//导航栏颜色
let NAV_BAR_RED_COLOR = UIColor.init(red: 246/255.0, green: 61/255.0, blue: 78/255.0, alpha: 1.0)
//搜索框颜色
let SEARCH_BAR_RED_COLOR = UIColor.init(red: 211/255.0, green: 51/255.0, blue: 65/255.0, alpha: 1.0)
//随机色
let RANDOM_COLOR = UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)

func SM_RANDOM_COLOR()->UIColor{
    
    let color = UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
    
    return color
}


//间隙
let SM_MRAGIN_5 = 5*APP_SCALE
let SM_MRAGIN_10 = 10*APP_SCALE
let SM_MRAGIN_15 = 15*APP_SCALE
let SM_MRAGIN_20 = 20*APP_SCALE
