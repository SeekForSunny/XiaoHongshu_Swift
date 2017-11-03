//
//  AppDelegate.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    //获取接口信息
    static func apiInfo() -> [String:Any] {
        var dic:[String:Any] = [:]
        if let path = Bundle.main.path(forResource: "api.json", ofType: nil){
            if let data = NSData(contentsOfFile: path){
                do {
                    
                    if let info = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]{
                        dic =  info
                    }
                    
                    
                } catch {
                    print(HomeIndexContentView.self,"Error",error);
                }
                
            }
        }
        return dic
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.rootViewController = MainController();
        window?.makeKeyAndVisible();
        
        return true
    }



}

