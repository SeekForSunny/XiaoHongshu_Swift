//
//  NavigationController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化设置
        setup();

    }

}


extension NavigationController{
    
    //统一设置导航栏颜色
    func setup() {
        
        //设置导航栏背景颜色
        navigationBar.setBackgroundImage(UIImage.image(color: NAV_BAR_RED_COLOR), for: UIBarMetrics.default)
        
        //设置标题属性
        navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18*APP_SCALE),NSForegroundColorAttributeName:UIColor.white];
        navigationBar.shadowImage = UIImage.image(color: UIColor.lightGray);
        
    }
    
    
    //统一设置返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let button = UIButton(type: UIButtonType.custom);
        button.setImage(UIImage(named:"navi_back_shadow_25x25_"), for: UIControlState.normal);
        button.sizeToFit();
        
        if childViewControllers.count >= 1{
            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: button);
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        super.pushViewController(viewController, animated: animated);
        button.addTarget(self, action: #selector(back as ()->()), for: UIControlEvents.touchUpInside);
        
    }
    
    func back() {
        self.popViewController(animated: true);
    }
}
