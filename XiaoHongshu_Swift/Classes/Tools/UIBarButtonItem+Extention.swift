//
//  UIBarButtonItem+Extention.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/9.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

  static func item(normal:String,selected:String,target:Any,selector:Selector) -> [UIBarButtonItem]{
        
      let button =  UIButton()
        button.setImage(UIImage(named:normal), for: UIControlState.normal)
        button.setImage(UIImage(named:selected), for: UIControlState.selected)
        button.sizeToFit()
        button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
        let item =  UIBarButtonItem(customView: button)
        let spacer  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -10*APP_SCALE
        return [spacer,item]
        
    }
}
