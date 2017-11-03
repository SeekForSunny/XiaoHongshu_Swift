//
//  MainController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

   // MARK: - 初始化
    override func viewDidLoad() {
        
        //添加并设置子控制器
        addChildViewControllers();
        
    }
}

extension MainController{

  // MARK: 添加子控制器
    func addChildViewControllers() {
        
        //首页
        let homeIndexVc = HomeIndexController();
        addChildViewController(childController: homeIndexVc, title: "首页", icon:"tab_home");
        
        //发现
        let discoverIndexVc = DiscoverIndexController();
        addChildViewController(childController: discoverIndexVc, title: "发现", icon: "tab_search");
        
        //购物车
        let cartIndexVc = CartIndexController();
        addChildViewController(childController: cartIndexVc, title: "购物车", icon: "tab_store");
        
        //消息
        let messageIndexVc = MessageIndexController();
        addChildViewController(childController: messageIndexVc, title: "消息", icon: "tab_msn");
        
        //我
        let profileVc = ProfileIndexController();
        addChildViewController(childController: profileVc, title: "我", icon:"tab_me");

    }
    
    
    //MARK: 添加并设置单个子控制器
    
    func addChildViewController(childController: UIViewController,title:String,icon:String) {
        
        //添加子控制器
        let navigationVc = NavigationController(rootViewController: childController);
        addChildViewController(navigationVc);
        
        //设置子控制器标题及图标显示
        childController.title = title;
        childController.tabBarItem.image = UIImage(named: icon+"_25x25_")
        childController.tabBarItem.selectedImage = UIImage(named: icon+"_h_25x25_");
        
        //设置标题属性
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 11*APP_SCALE),NSForegroundColorAttributeName:UIColor.lightGray], for: UIControlState.normal);
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 11*APP_SCALE),NSForegroundColorAttributeName:UIColor.red], for: UIControlState.selected);
    }
}
